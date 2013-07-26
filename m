From: akpm@linux-foundation.org
Subject: + s390-vmcore-use-vmcore-for-zfcpdump.patch added to -mm tree
Date: Fri, 26 Jul 2013 13:20:58 -0700
Message-ID: <51f2da2a.tY8vNVeKyo6YhLbV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3GZUU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willeke@de.ibm.com, vgoyal@redhat.com, d.hatayama@jp.fujitsu.com, holzheu@linux.vnet.ibm.com

Subject: + s390-vmcore-use-vmcore-for-zfcpdump.patch added to -mm tree
To: holzheu@linux.vnet.ibm.com,d.hatayama@jp.fujitsu.com,vgoyal@redhat.com,willeke@de.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:20:58 -0700


The patch titled
     Subject: s390/vmcore: use vmcore for zfcpdump
has been added to the -mm tree.  Its filename is
     s390-vmcore-use-vmcore-for-zfcpdump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-vmcore-use-vmcore-for-zfcpdump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-vmcore-use-vmcore-for-zfcpdump.patch

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
Subject: s390/vmcore: use vmcore for zfcpdump

Modify the s390 copy_oldmem_page() and remap_oldmem_pfn_range() function
for zfcpdump to read from the HSA memory if memory below HSA_SIZE bytes is
requested.  Otherwise real memory is used.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Willeke <willeke@de.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig             |    3 
 arch/s390/include/asm/sclp.h  |    1 
 arch/s390/kernel/crash_dump.c |  122 +++++++++++++++++++++++++++-----
 drivers/s390/char/zcore.c     |    6 -
 4 files changed, 110 insertions(+), 22 deletions(-)

diff -puN arch/s390/Kconfig~s390-vmcore-use-vmcore-for-zfcpdump arch/s390/Kconfig
--- a/arch/s390/Kconfig~s390-vmcore-use-vmcore-for-zfcpdump
+++ a/arch/s390/Kconfig
@@ -514,6 +514,7 @@ config CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on 64BIT && SMP
 	select KEXEC
+	select ZFCPDUMP
 	help
 	  Generate crash dump after being started by kexec.
 	  Crash dump kernels are loaded in the main kernel with kexec-tools
@@ -524,7 +525,7 @@ config CRASH_DUMP
 config ZFCPDUMP
 	def_bool n
 	prompt "zfcpdump support"
-	select SMP
+	depends on SMP
 	help
 	  Select this option if you want to build an zfcpdump enabled kernel.
 	  Refer to <file:Documentation/s390/zfcpdump.txt> for more details on this.
diff -puN arch/s390/include/asm/sclp.h~s390-vmcore-use-vmcore-for-zfcpdump arch/s390/include/asm/sclp.h
--- a/arch/s390/include/asm/sclp.h~s390-vmcore-use-vmcore-for-zfcpdump
+++ a/arch/s390/include/asm/sclp.h
@@ -56,5 +56,6 @@ bool sclp_has_linemode(void);
 bool sclp_has_vt220(void);
 int sclp_pci_configure(u32 fid);
 int sclp_pci_deconfigure(u32 fid);
+int memcpy_hsa(void *dest, unsigned long src, size_t count, int mode);
 
 #endif /* _ASM_S390_SCLP_H */
diff -puN arch/s390/kernel/crash_dump.c~s390-vmcore-use-vmcore-for-zfcpdump arch/s390/kernel/crash_dump.c
--- a/arch/s390/kernel/crash_dump.c~s390-vmcore-use-vmcore-for-zfcpdump
+++ a/arch/s390/kernel/crash_dump.c
@@ -16,6 +16,7 @@
 #include <asm/os_info.h>
 #include <asm/elf.h>
 #include <asm/ipl.h>
+#include <asm/sclp.h>
 
 #define PTR_ADD(x, y) (((char *) (x)) + ((unsigned long) (y)))
 #define PTR_SUB(x, y) (((char *) (x)) - ((unsigned long) (y)))
@@ -69,22 +70,41 @@ static ssize_t copy_page_real(void *buf,
 static void *elfcorehdr_newmem;
 
 /*
- * Copy one page from "oldmem"
+ * Copy one page from zfcpdump "oldmem"
+ *
+ * For pages below ZFCPDUMP_HSA_SIZE memory from the HSA is copied. Otherwise
+ * real memory copy is used.
+ */
+static ssize_t copy_oldmem_page_zfcpdump(char *buf, size_t csize,
+					 unsigned long src, int userbuf)
+{
+	int rc;
+
+	if (src < ZFCPDUMP_HSA_SIZE) {
+		rc = memcpy_hsa(buf, src, csize, userbuf);
+	} else {
+		if (userbuf)
+			rc = copy_to_user_real((void __force __user *) buf,
+					       (void *) src, csize);
+		else
+			rc = memcpy_real(buf, (void *) src, csize);
+	}
+	return rc ? rc : csize;
+}
+
+/*
+ * Copy one page from kdump "oldmem"
  *
  * For the kdump reserved memory this functions performs a swap operation:
  *  - [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE] is mapped to [0 - OLDMEM_SIZE].
  *  - [0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]
  */
-ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
-			 size_t csize, unsigned long offset, int userbuf)
+static ssize_t copy_oldmem_page_kdump(char *buf, size_t csize,
+				      unsigned long src, int userbuf)
+
 {
-	unsigned long src;
 	int rc;
 
-	if (!csize)
-		return 0;
-
-	src = (pfn << PAGE_SHIFT) + offset;
 	if (src < OLDMEM_SIZE)
 		src += OLDMEM_BASE;
 	else if (src > OLDMEM_BASE &&
@@ -95,17 +115,35 @@ ssize_t copy_oldmem_page(unsigned long p
 				       (void *) src, csize);
 	else
 		rc = copy_page_real(buf, (void *) src, csize);
-	return (rc == 0) ? csize : rc;
+	return (rc == 0) ? rc : csize;
 }
 
 /*
- * Remap "oldmem"
+ * Copy one page from "oldmem"
+ */
+ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
+			 unsigned long offset, int userbuf)
+{
+	unsigned long src;
+
+	if (!csize)
+		return 0;
+	src = (pfn << PAGE_SHIFT) + offset;
+	if (OLDMEM_BASE)
+		return copy_oldmem_page_kdump(buf, csize, src, userbuf);
+	else
+		return copy_oldmem_page_zfcpdump(buf, csize, src, userbuf);
+}
+
+/*
+ * Remap "oldmem" for kdump
  *
  * For the kdump reserved memory this functions performs a swap operation:
  * [0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]
  */
-int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
-			   unsigned long pfn, unsigned long size, pgprot_t prot)
+static int remap_oldmem_pfn_range_kdump(struct vm_area_struct *vma,
+					unsigned long from, unsigned long pfn,
+					unsigned long size, pgprot_t prot)
 {
 	unsigned long size_old;
 	int rc;
@@ -125,6 +163,43 @@ int remap_oldmem_pfn_range(struct vm_are
 }
 
 /*
+ * Remap "oldmem" for zfcpdump
+ *
+ * We only map available memory above ZFCPDUMP_HSA_SIZE. Memory below
+ * ZFCPDUMP_HSA_SIZE is read on demand using the copy_oldmem_page() function.
+ */
+static int remap_oldmem_pfn_range_zfcpdump(struct vm_area_struct *vma,
+					   unsigned long from,
+					   unsigned long pfn,
+					   unsigned long size, pgprot_t prot)
+{
+	unsigned long size_hsa;
+
+	if (pfn < ZFCPDUMP_HSA_SIZE >> PAGE_SHIFT) {
+		size_hsa = min(size, ZFCPDUMP_HSA_SIZE - (pfn << PAGE_SHIFT));
+		if (size == size_hsa)
+			return 0;
+		size -= size_hsa;
+		from += size_hsa;
+		pfn += size_hsa >> PAGE_SHIFT;
+	}
+	return remap_pfn_range(vma, from, pfn, size, prot);
+}
+
+/*
+ * Remap "oldmem" for kdump or zfcpdump
+ */
+int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
+			   unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	if (OLDMEM_BASE)
+		return remap_oldmem_pfn_range_kdump(vma, from, pfn, size, prot);
+	else
+		return remap_oldmem_pfn_range_zfcpdump(vma, from, pfn, size,
+						       prot);
+}
+
+/*
  * Copy memory from old kernel
  */
 int copy_from_oldmem(void *dest, void *src, size_t count)
@@ -132,11 +207,21 @@ int copy_from_oldmem(void *dest, void *s
 	unsigned long copied = 0;
 	int rc;
 
-	if ((unsigned long) src < OLDMEM_SIZE) {
-		copied = min(count, OLDMEM_SIZE - (unsigned long) src);
-		rc = memcpy_real(dest, src + OLDMEM_BASE, copied);
-		if (rc)
-			return rc;
+	if (OLDMEM_BASE) {
+		if ((unsigned long) src < OLDMEM_SIZE) {
+			copied = min(count, OLDMEM_SIZE - (unsigned long) src);
+			rc = memcpy_real(dest, src + OLDMEM_BASE, copied);
+			if (rc)
+				return rc;
+		}
+	} else {
+		if ((unsigned long) src < ZFCPDUMP_HSA_SIZE) {
+			copied = min(count,
+				     ZFCPDUMP_HSA_SIZE - (unsigned long) src);
+			rc = memcpy_hsa(dest, (unsigned long) src, copied, 0);
+			if (rc)
+				return rc;
+		}
 	}
 	return memcpy_real(dest + copied, src + copied, count - copied);
 }
@@ -466,7 +551,8 @@ int elfcorehdr_alloc(unsigned long long
 	u32 alloc_size;
 	u64 hdr_off;
 
-	if (!OLDMEM_BASE)
+	/* If we are not in kdump or zfcpdump mode return */
+	if (!OLDMEM_BASE && ipl_info.type != IPL_TYPE_FCP_DUMP)
 		return 0;
 	/* If elfcorehdr= has been passed via cmdline, we use that one */
 	if (elfcorehdr_addr != ELFCORE_ADDR_MAX)
diff -puN drivers/s390/char/zcore.c~s390-vmcore-use-vmcore-for-zfcpdump drivers/s390/char/zcore.c
--- a/drivers/s390/char/zcore.c~s390-vmcore-use-vmcore-for-zfcpdump
+++ a/drivers/s390/char/zcore.c
@@ -30,8 +30,8 @@
 
 #define TRACE(x...) debug_sprintf_event(zcore_dbf, 1, x)
 
-#define TO_USER		0
-#define TO_KERNEL	1
+#define TO_USER		1
+#define TO_KERNEL	0
 #define CHUNK_INFO_SIZE	34 /* 2 16-byte char, each followed by blank */
 
 enum arch_id {
@@ -73,7 +73,7 @@ static struct ipl_parameter_block *ipl_b
  * @count: Size of buffer, which should be copied
  * @mode:  Either TO_KERNEL or TO_USER
  */
-static int memcpy_hsa(void *dest, unsigned long src, size_t count, int mode)
+int memcpy_hsa(void *dest, unsigned long src, size_t count, int mode)
 {
 	int offs, blk_num;
 	static char buf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

vmcore-introduce-elf-header-in-new-memory-feature.patch
s390-vmcore-use-elf-header-in-new-memory-feature.patch
vmcore-introduce-remap_oldmem_pfn_range.patch
s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch
vmcore-enable-proc-vmcore-mmap-for-s390.patch
s390-vmcore-use-vmcore-for-zfcpdump.patch

