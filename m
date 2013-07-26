From: akpm@linux-foundation.org
Subject: + s390-vmcore-use-elf-header-in-new-memory-feature.patch added to -mm tree
Date: Fri, 26 Jul 2013 13:20:54 -0700
Message-ID: <51f2da26.QeiLBKUHxlgRK2ya%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3GZUUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willeke@de.ibm.com, vgoyal@redhat.com, d.hatayama@jp.fujitsu.com, holzheu@linux.vnet.ibm.com

Subject: + s390-vmcore-use-elf-header-in-new-memory-feature.patch added to -mm tree
To: holzheu@linux.vnet.ibm.com,d.hatayama@jp.fujitsu.com,vgoyal@redhat.com,willeke@de.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:20:54 -0700


The patch titled
     Subject: s390/vmcore: use ELF header in new memory feature
has been added to the -mm tree.  Its filename is
     s390-vmcore-use-elf-header-in-new-memory-feature.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-vmcore-use-elf-header-in-new-memory-feature.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-vmcore-use-elf-header-in-new-memory-feature.patch

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
Subject: s390/vmcore: use ELF header in new memory feature

Exchange the old relocate mechanism with the new arch function call
override mechanism that allows to create the ELF core header in the 2nd
kernel.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/crash_dump.c |   79 +++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 26 deletions(-)

diff -puN arch/s390/kernel/crash_dump.c~s390-vmcore-use-elf-header-in-new-memory-feature arch/s390/kernel/crash_dump.c
--- a/arch/s390/kernel/crash_dump.c~s390-vmcore-use-elf-header-in-new-memory-feature
+++ a/arch/s390/kernel/crash_dump.c
@@ -64,6 +64,11 @@ static ssize_t copy_page_real(void *buf,
 }
 
 /*
+ * Pointer to ELF header in new kernel
+ */
+static void *elfcorehdr_newmem;
+
+/*
  * Copy one page from "oldmem"
  *
  * For the kdump reserved memory this functions performs a swap operation:
@@ -368,14 +373,6 @@ static int get_mem_chunk_cnt(void)
 }
 
 /*
- * Relocate pointer in order to allow vmcore code access the data
- */
-static inline unsigned long relocate(unsigned long addr)
-{
-	return OLDMEM_BASE + addr;
-}
-
-/*
  * Initialize ELF loads (new kernel)
  */
 static int loads_init(Elf64_Phdr *phdr, u64 loads_offset)
@@ -426,7 +423,7 @@ static void *notes_init(Elf64_Phdr *phdr
 	ptr = nt_vmcoreinfo(ptr);
 	memset(phdr, 0, sizeof(*phdr));
 	phdr->p_type = PT_NOTE;
-	phdr->p_offset = relocate(notes_offset);
+	phdr->p_offset = notes_offset;
 	phdr->p_filesz = (unsigned long) PTR_SUB(ptr, ptr_start);
 	phdr->p_memsz = phdr->p_filesz;
 	return ptr;
@@ -435,7 +432,7 @@ static void *notes_init(Elf64_Phdr *phdr
 /*
  * Create ELF core header (new kernel)
  */
-static void s390_elf_corehdr_create(char **elfcorebuf, size_t *elfcorebuf_sz)
+int elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size)
 {
 	Elf64_Phdr *phdr_notes, *phdr_loads;
 	int mem_chunk_cnt;
@@ -443,6 +440,11 @@ static void s390_elf_corehdr_create(char
 	u32 alloc_size;
 	u64 hdr_off;
 
+	if (!OLDMEM_BASE)
+		return 0;
+	/* If elfcorehdr= has been passed via cmdline, we use that one */
+	if (elfcorehdr_addr != ELFCORE_ADDR_MAX)
+		return 0;
 	mem_chunk_cnt = get_mem_chunk_cnt();
 
 	alloc_size = 0x1000 + get_cpu_cnt() * 0x300 +
@@ -460,27 +462,52 @@ static void s390_elf_corehdr_create(char
 	ptr = notes_init(phdr_notes, ptr, ((unsigned long) hdr) + hdr_off);
 	/* Init loads */
 	hdr_off = PTR_DIFF(ptr, hdr);
-	loads_init(phdr_loads, ((unsigned long) hdr) + hdr_off);
-	*elfcorebuf_sz = hdr_off;
-	*elfcorebuf = (void *) relocate((unsigned long) hdr);
-	BUG_ON(*elfcorebuf_sz > alloc_size);
+	loads_init(phdr_loads, hdr_off);
+	*addr = (unsigned long long) hdr;
+	elfcorehdr_newmem = hdr;
+	*size = (unsigned long long) hdr_off;
+	BUG_ON(elfcorehdr_size > alloc_size);
+	return 0;
 }
 
 /*
- * Create kdump ELF core header in new kernel, if it has not been passed via
- * the "elfcorehdr" kernel parameter
+ * Free ELF core header (new kernel)
  */
-static int setup_kdump_elfcorehdr(void)
+void elfcorehdr_free(unsigned long long addr)
 {
-	size_t elfcorebuf_sz;
-	char *elfcorebuf;
+	if (!elfcorehdr_newmem)
+		return;
+	kfree((void *)(unsigned long)addr);
+}
 
-	if (!OLDMEM_BASE || is_kdump_kernel())
-		return -EINVAL;
-	s390_elf_corehdr_create(&elfcorebuf, &elfcorebuf_sz);
-	elfcorehdr_addr = (unsigned long long) elfcorebuf;
-	elfcorehdr_size = elfcorebuf_sz;
-	return 0;
+/*
+ * Read from ELF header
+ */
+ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
+{
+	void *src = (void *)(unsigned long)*ppos;
+
+	src = elfcorehdr_newmem ? src : src - OLDMEM_BASE;
+	memcpy(buf, src, count);
+	*ppos += count;
+	return count;
 }
 
-subsys_initcall(setup_kdump_elfcorehdr);
+/*
+ * Read from ELF notes data
+ */
+ssize_t elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
+{
+	void *src = (void *)(unsigned long)*ppos;
+	int rc;
+
+	if (elfcorehdr_newmem) {
+		memcpy(buf, src, count);
+	} else {
+		rc = copy_from_oldmem(buf, src, count);
+		if (rc)
+			return rc;
+	}
+	*ppos += count;
+	return count;
+}
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

vmcore-introduce-elf-header-in-new-memory-feature.patch
s390-vmcore-use-elf-header-in-new-memory-feature.patch
vmcore-introduce-remap_oldmem_pfn_range.patch
s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch
vmcore-enable-proc-vmcore-mmap-for-s390.patch
s390-vmcore-use-vmcore-for-zfcpdump.patch

