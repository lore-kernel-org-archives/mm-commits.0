From: akpm@linux-foundation.org
Subject: + hugetlb-new-sysfs-interface-fix.patch added to -mm tree
Date: Tue, 24 Jun 2008 00:12:55 -0700
Message-ID: <200806240712.m5O7CtF0006135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbYFXHNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 03:13:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@bakeyournoodle.com, npiggin@suse.de


The patch titled
     Fix compilation of mm/hugetlb.c when !CONFIG_SYS
has been added to the -mm tree.  Its filename is
     hugetlb-new-sysfs-interface-fix.patch

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
Subject: Fix compilation of mm/hugetlb.c when !CONFIG_SYS
From: Tony Breeds <tony@bakeyournoodle.com>

Building without CONFIG_SYS yields:
mm/hugetlb.c: In function 'hugetlb_exit':
mm/hugetlb.c:1234: error: 'hstate_kobjs' undeclared (first use in this function)
mm/hugetlb.c:1234: error: (Each undeclared identifier is reported only once
mm/hugetlb.c:1234: error: for each function it appears in.)
mm/hugetlb.c:1237: error: 'hugepages_kobj' undeclared (first use in this function)

The declaration of hstate_kobjs is guarded by CONFIG_SYS so likewise
guard the _exit function.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-new-sysfs-interface-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-new-sysfs-interface-fix
+++ a/mm/hugetlb.c
@@ -1130,6 +1130,7 @@ static int __init hugetlb_init(void)
 }
 module_init(hugetlb_init);
 
+#ifdef CONFIG_SYSFS
 static void __exit hugetlb_exit(void)
 {
 	struct hstate *h;
@@ -1141,6 +1142,7 @@ static void __exit hugetlb_exit(void)
 	kobject_put(hugepages_kobj);
 }
 module_exit(hugetlb_exit);
+#endif
 
 /* Should be called on processing a hugepagesz=... option */
 void __init hugetlb_add_hstate(unsigned order)
_

Patches currently in -mm which might be from tony@bakeyournoodle.com are

hugetlb-new-sysfs-interface-fix.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch

