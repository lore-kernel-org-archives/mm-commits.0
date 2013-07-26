From: akpm@linux-foundation.org
Subject: + s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch
 added to -mm tree
Date: Fri, 26 Jul 2013 13:20:56 -0700
Message-ID: <51f2da28.fqeoWPee5f3Vq147%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3GZUU5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 16:20:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, holzheu@linux.vnet.ibm.com, d.hatayama@jp.fujitsu.com, willeke@de.ibm.com

Subject: + s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch added to -mm tree
To: willeke@de.ibm.com,d.hatayama@jp.fujitsu.com,holzheu@linux.vnet.ibm.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 13:20:56 -0700


The patch titled
     Subject: s390/vmcore: implement remap_oldmem_pfn_range for s390
has been added to the -mm tree.  Its filename is
     s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Willeke <willeke@de.ibm.com>
Subject: s390/vmcore: implement remap_oldmem_pfn_range for s390

Introduce the s390 specific way to map pages from oldmem.  The memory area
below OLDMEM_SIZE is mapped with offset OLDMEM_BASE.  The other old memory
is mapped directly.

Signed-off-by: Jan Willeke <willeke@de.ibm.com>
Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/crash_dump.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN arch/s390/kernel/crash_dump.c~s390-vmcore-implement-remap_oldmem_pfn_range-for-s390 arch/s390/kernel/crash_dump.c
--- a/arch/s390/kernel/crash_dump.c~s390-vmcore-implement-remap_oldmem_pfn_range-for-s390
+++ a/arch/s390/kernel/crash_dump.c
@@ -99,6 +99,32 @@ ssize_t copy_oldmem_page(unsigned long p
 }
 
 /*
+ * Remap "oldmem"
+ *
+ * For the kdump reserved memory this functions performs a swap operation:
+ * [0 - OLDMEM_SIZE] is mapped to [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]
+ */
+int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
+			   unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	unsigned long size_old;
+	int rc;
+
+	if (pfn < OLDMEM_SIZE >> PAGE_SHIFT) {
+		size_old = min(size, OLDMEM_SIZE - (pfn << PAGE_SHIFT));
+		rc = remap_pfn_range(vma, from,
+				     pfn + (OLDMEM_BASE >> PAGE_SHIFT),
+				     size_old, prot);
+		if (rc || size == size_old)
+			return rc;
+		size -= size_old;
+		from += size_old;
+		pfn += size_old >> PAGE_SHIFT;
+	}
+	return remap_pfn_range(vma, from, pfn, size, prot);
+}
+
+/*
  * Copy memory from old kernel
  */
 int copy_from_oldmem(void *dest, void *src, size_t count)
_

Patches currently in -mm which might be from willeke@de.ibm.com are

vmcore-introduce-elf-header-in-new-memory-feature.patch
s390-vmcore-use-elf-header-in-new-memory-feature.patch
vmcore-introduce-remap_oldmem_pfn_range.patch
s390-vmcore-implement-remap_oldmem_pfn_range-for-s390.patch
vmcore-enable-proc-vmcore-mmap-for-s390.patch
s390-vmcore-use-vmcore-for-zfcpdump.patch

