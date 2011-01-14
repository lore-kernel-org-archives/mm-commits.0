From: akpm@linux-foundation.org
Subject: [merged] hugetlb-fix-handling-of-parse-errors-in-sysfs.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:17 -0800
Message-ID: <201101142252.p0EMq7Nb005589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1ANWwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@mgebm.net, aarcange@redhat.com, caiqian@redhat.com, mhocko@suse.cz, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix handling of parse errors in sysfs
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-handling-of-parse-errors-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix handling of parse errors in sysfs
From: Eric B Munson <emunson@mgebm.net>

When parsing changes to the huge page pool sizes made from userspace via
the sysfs interface, bogus input values are being covered up by
nr_hugepages_store_common and nr_overcommit_hugepages_store returning 0
when strict_strtoul returns an error.  This can cause an infinite loop in
the nr_hugepages_store code.  This patch changes the return value for
these functions to -EINVAL when strict_strtoul returns an error.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Reported-by: CAI Qian <caiqian@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-handling-of-parse-errors-in-sysfs mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-handling-of-parse-errors-in-sysfs
+++ a/mm/hugetlb.c
@@ -1375,10 +1375,8 @@ static ssize_t nr_hugepages_store_common
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
 	err = strict_strtoul(buf, 10, &count);
-	if (err) {
-		err = 0;		/* This seems wrong */
+	if (err)
 		goto out;
-	}
 
 	h = kobj_to_hstate(kobj, &nid);
 	if (h->order >= MAX_ORDER) {
@@ -1469,7 +1467,7 @@ static ssize_t nr_overcommit_hugepages_s
 
 	err = strict_strtoul(buf, 10, &input);
 	if (err)
-		return 0;
+		return err;
 
 	spin_lock(&hugetlb_lock);
 	h->nr_overcommit_huge_pages = input;
_

Patches currently in -mm which might be from emunson@mgebm.net are

origin.patch

