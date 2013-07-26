From: akpm@linux-foundation.org
Subject: + vmcore-introduce-elf-header-in-new-memory-feature.patch added
 to -mm tree
Date: Fri, 26 Jul 2013 13:20:53 -0700
Message-ID: <51f2da25.qlEftzdFXIQcdWu3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3GZUUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:20:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willeke@de.ibm.com, vgoyal@redhat.com, d.hatayama@jp.fujitsu.com, holzheu@linux.vnet.ibm.com

Subject: + vmcore-introduce-elf-header-in-new-memory-feature.patch added to -mm tree
To: holzheu@linux.vnet.ibm.com,d.hatayama@jp.fujitsu.com,vgoyal@redhat.com,willeke@de.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:20:53 -0700


The patch titled
     Subject: vmcore: introduce ELF header in new memory feature
has been added to the -mm tree.  Its filename is
     vmcore-introduce-elf-header-in-new-memory-feature.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmcore-introduce-elf-header-in-new-memory-feature.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmcore-introduce-elf-header-in-new-memory-feature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: vmcore: introduce ELF header in new memory feature

For s390 we want to use /proc/vmcore for our SCSI stand-alone dump
(zfcpdump).  We have support where the first HSA_SIZE bytes are saved into
a hypervisor owned memory area (HSA) before the kdump kernel is booted. 
When the kdump kernel starts, it is restricted to use only HSA_SIZE bytes.

The advantages of this mechanism are:

* No crashkernel memory has to be defined in the old kernel.
* Early boot problems (before kexec_load has been done) can be dumped 
* Non-Linux systems can be dumped.

We modify the s390 copy_oldmem_page() function to read from the HSA memory
if memory below HSA_SIZE bytes is requested.

Since we cannot use the kexec tool to load the kernel in this scenario,
we have to build the ELF header in the 2nd (kdump/new) kernel.

So with the following patch set we would like to introduce the new
function that the ELF header for /proc/vmcore can be created in the 2nd
kernel memory.

The following steps are done during zfcpdump execution:

1.  Production system crashes
2.  User boots a SCSI disk that has been prepared with the zfcpdump tool
3.  Hypervisor saves CPU state of boot CPU and HSA_SIZE bytes of memory into HSA
4.  Boot loader loads kernel into low memory area
5.  Kernel boots and uses only HSA_SIZE bytes of memory
6.  Kernel saves registers of non-boot CPUs
7.  Kernel does memory detection for dump memory map
8.  Kernel creates ELF header for /proc/vmcore
9.  /proc/vmcore uses this header for initialization
10. The zfcpdump user space reads /proc/vmcore to write dump to SCSI disk
    - copy_oldmem_page() copies from HSA for memory below HSA_SIZE
    - copy_oldmem_page() copies from real memory for memory above HSA_SIZE

Currently for s390 we create the ELF core header in the 2nd kernel with a
small trick.  We relocate the addresses in the ELF header in a way that
for the /proc/vmcore code it seems to be in the 1st kernel (old) memory
and the read_from_oldmem() returns the correct data.  This allows the
/proc/vmcore code to use the ELF header in the 2nd kernel.



This patch:

Exchange the old mechanism with the new and much cleaner function call
override feature that now offcially allows to create the ELF core header
in the 2nd kernel.

To use the new feature the following function have to be defined
by the architecture backend code to read from new memory:

 * elfcorehdr_alloc: Allocate ELF header
 * elfcorehdr_free: Free the memory of the ELF header
 * elfcorehdr_read: Read from ELF header
 * elfcorehdr_read_notes: Read from ELF notes

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c           |   61 +++++++++++++++++++++++++++++------
 include/linux/crash_dump.h |    6 +++
 2 files changed, 57 insertions(+), 10 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-introduce-elf-header-in-new-memory-feature fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-introduce-elf-header-in-new-memory-feature
+++ a/fs/proc/vmcore.c
@@ -123,6 +123,36 @@ static ssize_t read_from_oldmem(char *bu
 	return read;
 }
 
+/*
+ * Architectures may override this function to allocate ELF header in 2nd kernel
+ */
+int __weak elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size)
+{
+	return 0;
+}
+
+/*
+ * Architectures may override this function to free header
+ */
+void __weak elfcorehdr_free(unsigned long long addr)
+{}
+
+/*
+ * Architectures may override this function to read from ELF header
+ */
+ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos)
+{
+	return read_from_oldmem(buf, count, ppos, 0);
+}
+
+/*
+ * Architectures may override this function to read from notes sections
+ */
+ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
+{
+	return read_from_oldmem(buf, count, ppos, 0);
+}
+
 /* Read from the ELF header and then the crash dump. On error, negative value is
  * returned otherwise number of bytes read are returned.
  */
@@ -357,7 +387,7 @@ static int __init update_note_header_siz
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = elfcorehdr_read_notes(notes_section, max_sz, &offset);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -444,7 +474,8 @@ static int __init copy_notes_elf64(const
 		if (phdr_ptr->p_type != PT_NOTE)
 			continue;
 		offset = phdr_ptr->p_offset;
-		rc = read_from_oldmem(notes_buf, phdr_ptr->p_memsz, &offset, 0);
+		rc = elfcorehdr_read_notes(notes_buf, phdr_ptr->p_memsz,
+					   &offset);
 		if (rc < 0)
 			return rc;
 		notes_buf += phdr_ptr->p_memsz;
@@ -536,7 +567,7 @@ static int __init update_note_header_siz
 		notes_section = kmalloc(max_sz, GFP_KERNEL);
 		if (!notes_section)
 			return -ENOMEM;
-		rc = read_from_oldmem(notes_section, max_sz, &offset, 0);
+		rc = elfcorehdr_read_notes(notes_section, max_sz, &offset);
 		if (rc < 0) {
 			kfree(notes_section);
 			return rc;
@@ -623,7 +654,8 @@ static int __init copy_notes_elf32(const
 		if (phdr_ptr->p_type != PT_NOTE)
 			continue;
 		offset = phdr_ptr->p_offset;
-		rc = read_from_oldmem(notes_buf, phdr_ptr->p_memsz, &offset, 0);
+		rc = elfcorehdr_read_notes(notes_buf, phdr_ptr->p_memsz,
+					   &offset);
 		if (rc < 0)
 			return rc;
 		notes_buf += phdr_ptr->p_memsz;
@@ -810,7 +842,7 @@ static int __init parse_crash_elf64_head
 	addr = elfcorehdr_addr;
 
 	/* Read Elf header */
-	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf64_Ehdr), &addr, 0);
+	rc = elfcorehdr_read((char *)&ehdr, sizeof(Elf64_Ehdr), &addr);
 	if (rc < 0)
 		return rc;
 
@@ -837,7 +869,7 @@ static int __init parse_crash_elf64_head
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
+	rc = elfcorehdr_read(elfcorebuf, elfcorebuf_sz_orig, &addr);
 	if (rc < 0)
 		goto fail;
 
@@ -866,7 +898,7 @@ static int __init parse_crash_elf32_head
 	addr = elfcorehdr_addr;
 
 	/* Read Elf header */
-	rc = read_from_oldmem((char*)&ehdr, sizeof(Elf32_Ehdr), &addr, 0);
+	rc = elfcorehdr_read((char *)&ehdr, sizeof(Elf32_Ehdr), &addr);
 	if (rc < 0)
 		return rc;
 
@@ -892,7 +924,7 @@ static int __init parse_crash_elf32_head
 	if (!elfcorebuf)
 		return -ENOMEM;
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(elfcorebuf, elfcorebuf_sz_orig, &addr, 0);
+	rc = elfcorehdr_read(elfcorebuf, elfcorebuf_sz_orig, &addr);
 	if (rc < 0)
 		goto fail;
 
@@ -919,7 +951,7 @@ static int __init parse_crash_elf_header
 	int rc=0;
 
 	addr = elfcorehdr_addr;
-	rc = read_from_oldmem(e_ident, EI_NIDENT, &addr, 0);
+	rc = elfcorehdr_read(e_ident, EI_NIDENT, &addr);
 	if (rc < 0)
 		return rc;
 	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
@@ -952,7 +984,14 @@ static int __init vmcore_init(void)
 {
 	int rc = 0;
 
-	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
+	/* Allow architectures to allocate ELF header in 2nd kernel */
+	rc = elfcorehdr_alloc(&elfcorehdr_addr, &elfcorehdr_size);
+	if (rc)
+		return rc;
+	/*
+	 * If elfcorehdr= has been passed in cmdline or created in 2nd kernel,
+	 * then capture the dump.
+	 */
 	if (!(is_vmcore_usable()))
 		return rc;
 	rc = parse_crash_elf_headers();
@@ -960,6 +999,8 @@ static int __init vmcore_init(void)
 		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
 	}
+	elfcorehdr_free(elfcorehdr_addr);
+	elfcorehdr_addr = ELFCORE_ADDR_ERR;
 
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
diff -puN include/linux/crash_dump.h~vmcore-introduce-elf-header-in-new-memory-feature include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~vmcore-introduce-elf-header-in-new-memory-feature
+++ a/include/linux/crash_dump.h
@@ -12,6 +12,12 @@
 extern unsigned long long elfcorehdr_addr;
 extern unsigned long long elfcorehdr_size;
 
+extern int __weak elfcorehdr_alloc(unsigned long long *addr,
+				   unsigned long long *size);
+extern void __weak elfcorehdr_free(unsigned long long addr);
+extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
+extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
+
 extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 						unsigned long, int);
 
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

vmcore-introduce-elf-header-in-new-memory-feature.patch
s390-vmcore-use-elf-header-in-new-memory-feature.patch
vmcore-introduce-remap_oldmem_pfn_range.patch
s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch
vmcore-enable-proc-vmcore-mmap-for-s390.patch
s390-vmcore-use-vmcore-for-zfcpdump.patch

