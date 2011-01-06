From: akpm@linux-foundation.org
Subject: + hugetlb-handle-nodemask_alloc-failure-correctly.patch added to -mm tree
Date: Thu, 06 Jan 2011 12:39:03 -0800
Message-ID: <201101062039.p06Kd3ZL014025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407Ab1AFUkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jan 2011 15:40:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, caiqian@redhat.com, nacc@us.ibm.com


The patch titled
     hugetlb: handle NODEMASK_ALLOC failure correctly
has been added to the -mm tree.  Its filename is
     hugetlb-handle-nodemask_alloc-failure-correctly.patch

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
Subject: hugetlb: handle NODEMASK_ALLOC failure correctly
From: Michal Hocko <mhocko@suse.cz>

NODEMASK_ALLOC can use kmalloc if nodemask_t > 256 bytes so it might
fail with NULL as a result. Let's check the resulting variable and
fail with -ENOMEM if NODEMASK_ALLOC failed.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-handle-nodemask_alloc-failure-correctly mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-handle-nodemask_alloc-failure-correctly
+++ a/mm/hugetlb.c
@@ -1374,14 +1374,19 @@ static ssize_t nr_hugepages_store_common
 	struct hstate *h;
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
+	if (!nodes_allowed) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	err = strict_strtoul(buf, 10, &count);
 	if (err)
-		goto out;
+		goto out_free_mask;
 
 	h = kobj_to_hstate(kobj, &nid);
 	if (h->order >= MAX_ORDER) {
 		err = -EINVAL;
-		goto out;
+		goto out_free_mask;
 	}
 
 	if (nid == NUMA_NO_NODE) {
@@ -1409,8 +1414,9 @@ static ssize_t nr_hugepages_store_common
 		NODEMASK_FREE(nodes_allowed);
 
 	return len;
-out:
+out_free_mask:
 	NODEMASK_FREE(nodes_allowed);
+out:
 	return err;
 }
 
@@ -1886,6 +1892,12 @@ static int hugetlb_sysctl_handler_common
 	if (write) {
 		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
 						GFP_KERNEL | __GFP_NORETRY);
+
+		if (!nodes_allowed) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
 		if (!(obey_mempolicy &&
 			       init_nodemask_of_mempolicy(nodes_allowed))) {
 			NODEMASK_FREE(nodes_allowed);
_

Patches currently in -mm which might be from mhocko@suse.cz are

hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
hugetlb-fix-handling-of-parse-errors-in-sysfs.patch
hugetlb-handle-nodemask_alloc-failure-correctly.patch

