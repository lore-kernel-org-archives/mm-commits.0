From: akpm@linux-foundation.org
Subject: + hugetlb-fix-section-mismatches.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:52:34 -0800
Message-ID: <201002012052.o11KqYJQ011710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118Ab0BAUwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:52:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, lee.schermerhorn@hp.com


The patch titled
     hugetlb: fix section mismatches
has been added to the -mm tree.  Its filename is
     hugetlb-fix-section-mismatches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
hugetlb-fix-section-mismatches.patch
drivers-scsi-hpsac-fix-section-mismatch.patch

