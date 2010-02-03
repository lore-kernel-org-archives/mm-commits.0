From: akpm@linux-foundation.org
Subject: [merged] hugetlb-fix-section-mismatches.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:55:11 -0800
Message-ID: <201002031755.o13HtBus008962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932802Ab0BCRzq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:55:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix section mismatches
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-section-mismatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix section mismatches
From: Jeff Mahoney <jeffm@suse.com>

hugetlb_sysfs_add_hstate is called by hugetlb_register_node directly
during init and also indirectly via sysfs after init.

This patch removes the __init tag from hugetlb_sysfs_add_hstate.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-section-mismatches mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-section-mismatches
+++ a/mm/hugetlb.c
@@ -1515,10 +1515,9 @@ static struct attribute_group hstate_att
 	.attrs = hstate_attrs,
 };
 
-static int __init hugetlb_sysfs_add_hstate(struct hstate *h,
-				struct kobject *parent,
-				struct kobject **hstate_kobjs,
-				struct attribute_group *hstate_attr_group)
+static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
+				    struct kobject **hstate_kobjs,
+				    struct attribute_group *hstate_attr_group)
 {
 	int retval;
 	int hi = h - hstates;
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
linux-next.patch
drivers-scsi-hpsac-fix-section-mismatch.patch

