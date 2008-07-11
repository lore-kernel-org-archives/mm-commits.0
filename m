From: akpm@linux-foundation.org
Subject: + hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:39:56 -0700
Message-ID: <200807111845.m6BIjb15030967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757323AbYGKSvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au


The patch titled
     hugetlb: remove CONFIG_SYSFS dependency
has been added to the -mm tree.  Its filename is
     hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: remove CONFIG_SYSFS dependency
From: Nishanth Aravamudan <nacc@us.ibm.com>

I incorrectly made the hugetlb kobject functionality depend on SYSFS, when, in
fact, the kobject functions fully work even with out sysfs.  Without sysfs,
there is no interface to manipulate the attributes of the various hugetlb
kobjects, but they still exist.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency
+++ a/mm/hugetlb.c
@@ -1040,7 +1040,6 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_SYSFS
 #define HSTATE_ATTR_RO(_name) \
 	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
@@ -1192,12 +1191,6 @@ static void __exit hugetlb_exit(void)
 }
 module_exit(hugetlb_exit);
 
-#else
-static void __init hugetlb_sysfs_init(void)
-{
-}
-#endif
-
 static int __init hugetlb_init(void)
 {
 	BUILD_BUG_ON(HPAGE_SHIFT == 0);
_

Patches currently in -mm which might be from nacc@us.ibm.com are

vma-page-offset-has-no-callees-drop-it.patch
mm-remove-mm_init-compilation-dependency-on-config_debug_memory_init.patch
mm-create-sys-kernel-mm.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-new-sysfs-interface-hugetlb-hang-off-of-sys-kernel-mm-rather-than-sys-kernel.patch
hugetlb-new-sysfs-interface-hugetlb-remove-config_sysfs-dependency.patch
hugetlb-abstract-numa-round-robin-selection.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
fs-check-for-statfs-overflow.patch
ixj-push-bkl-into-driver-and-wrap-ioctls.patch

