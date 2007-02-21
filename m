From: akpm@linux-foundation.org
Subject: + proper-prototype-for-hugetlb_get_unmapped_area.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:57:48 -0800
Message-ID: <200702212157.l1LLvmN8027634@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50996 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbXBUWBE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:01:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, wli@holomorphy.com


The patch titled
     proper prototype for hugetlb_get_unmapped_area()
has been added to the -mm tree.  Its filename is
     proper-prototype-for-hugetlb_get_unmapped_area.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proper prototype for hugetlb_get_unmapped_area()
From: Adrian Bunk <bunk@stusta.de>

Add a proper prototype for hugetlb_get_unmapped_area() in
include/linux/hugetlb.h.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: William Irwin <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    5 +----
 include/linux/hugetlb.h |    6 ++++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/hugetlbfs/inode.c~proper-prototype-for-hugetlb_get_unmapped_area fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~proper-prototype-for-hugetlb_get_unmapped_area
+++ a/fs/hugetlbfs/inode.c
@@ -98,10 +98,7 @@ out:
  * Called under down_write(mmap_sem).
  */
 
-#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags);
-#else
+#ifndef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 static unsigned long
 hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
diff -puN include/linux/hugetlb.h~proper-prototype-for-hugetlb_get_unmapped_area include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~proper-prototype-for-hugetlb_get_unmapped_area
+++ a/include/linux/hugetlb.h
@@ -183,4 +183,10 @@ static inline void set_file_hugepages(st
 
 #endif /* !CONFIG_HUGETLBFS */
 
+#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
+					unsigned long len, unsigned long pgoff,
+					unsigned long flags);
+#endif /* HAVE_ARCH_HUGETLB_UNMAPPED_AREA */
+
 #endif /* _LINUX_HUGETLB_H */
_

Patches currently in -mm which might be from bunk@stusta.de are

git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-ubi.patch
git-net.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
