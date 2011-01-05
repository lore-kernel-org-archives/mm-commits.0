From: akpm@linux-foundation.org
Subject: + hugetlb-fix-handling-of-parse-errors-in-sysfs.patch added to -mm tree
Date: Wed, 05 Jan 2011 13:16:23 -0800
Message-ID: <201101052116.p05LGNCa018988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779Ab1AEVQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 16:16:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: emunson@mgebm.net, aarcange@redhat.com, caiqian@redhat.com, mhocko@suse.cz, nacc@us.ibm.com


The patch titled
     hugetlb: fix handling of parse errors in sysfs
has been added to the -mm tree.  Its filename is
     hugetlb-fix-handling-of-parse-errors-in-sysfs.patch

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
@@ -1468,7 +1466,7 @@ static ssize_t nr_overcommit_hugepages_s
 
 	err = strict_strtoul(buf, 10, &input);
 	if (err)
-		return 0;
+		return err;
 
 	spin_lock(&hugetlb_lock);
 	h->nr_overcommit_huge_pages = input;
_

Patches currently in -mm which might be from emunson@mgebm.net are

mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
hugetlb-fix-handling-of-parse-errors-in-sysfs.patch

