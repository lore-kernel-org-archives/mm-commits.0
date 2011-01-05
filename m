From: akpm@linux-foundation.org
Subject: + hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch added to -mm tree
Date: Wed, 05 Jan 2011 13:12:18 -0800
Message-ID: <201101052112.p05LCITQ018776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab1AEVMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 16:12:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: emunson@mgebm.net, aarcange@redhat.com, caiqian@redhat.com, mhocko@suse.cz, nacc@us.ibm.com


The patch titled
     hugetlb: do not allow pagesize >= MAX_ORDER pool adjustment
has been added to the -mm tree.  Its filename is
     hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch

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
Subject: hugetlb: do not allow pagesize >= MAX_ORDER pool adjustment
From: Eric B Munson <emunson@mgebm.net>

Huge pages with order >= MAX_ORDER must be allocated at boot via the
kernel command line, they cannot be allocated or freed once the kernel is
up and running.  Currently we allow values to be written to the sysfs and
sysctl files controling pool size for these huge page sizes.  This patch
makes the store functions for nr_hugepages and nr_overcommit_hugepages
return -EINVAL when the pool for a page size >= MAX_ORDER is changed.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Reported-by: CAI Qian <caiqian@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment
+++ a/mm/hugetlb.c
@@ -1380,6 +1380,12 @@ static ssize_t nr_hugepages_store_common
 	}
 
 	h = kobj_to_hstate(kobj, &nid);
+
+	if (h->order >= MAX_ORDER) {
+		NODEMASK_FREE(nodes_allowed);
+		return -EINVAL;
+	}
+
 	if (nid == NUMA_NO_NODE) {
 		/*
 		 * global hstate attribute
@@ -1454,6 +1460,9 @@ static ssize_t nr_overcommit_hugepages_s
 	unsigned long input;
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
+	if (h->order >= MAX_ORDER)
+		return -EINVAL;
+
 	err = strict_strtoul(buf, 10, &input);
 	if (err)
 		return 0;
@@ -1864,6 +1873,9 @@ static int hugetlb_sysctl_handler_common
 	if (!write)
 		tmp = h->max_huge_pages;
 
+	if (write && h->order >= MAX_ORDER)
+		return -EINVAL;
+
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
 	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
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

