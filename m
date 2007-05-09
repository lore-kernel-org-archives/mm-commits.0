From: akpm@linux-foundation.org
Subject: - pretend-cpuset-has-some-form-of-hugetlb-page-reservation.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:04 -0700
Message-ID: <200705092150.l49Lo43H002769@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516AbXEIVuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, clameter@engr.sgi.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     pretend cpuset has some form of hugetlb page reservation
has been removed from the -mm tree.  Its filename was
     pretend-cpuset-has-some-form-of-hugetlb-page-reservation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pretend cpuset has some form of hugetlb page reservation
From: "Ken Chen" <kenchen@google.com>

When cpuset is configured, it breaks the strict hugetlb page reservation as
the accounting is done on a global variable.  Such reservation is
completely rubbish in the presence of cpuset because the reservation is not
checked against page availability for the current cpuset.  Application can
still potentially OOM'ed by kernel with lack of free htlb page in cpuset
that the task is in.  Attempt to enforce strict accounting with cpuset is
almost impossible (or too ugly) because cpuset is too fluid that task or
memory node can be dynamically moved between cpusets.

The change of semantics for shared hugetlb mapping with cpuset is
undesirable.  However, in order to preserve some of the semantics, we fall
back to check against current free page availability as a best attempt and
hopefully to minimize the impact of changing semantics that cpuset has on
hugetlb.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff -puN mm/hugetlb.c~pretend-cpuset-has-some-form-of-hugetlb-page-reservation mm/hugetlb.c
--- a/mm/hugetlb.c~pretend-cpuset-has-some-form-of-hugetlb-page-reservation
+++ a/mm/hugetlb.c
@@ -174,6 +174,17 @@ static int __init hugetlb_setup(char *s)
 }
 __setup("hugepages=", hugetlb_setup);
 
+static unsigned int cpuset_mems_nr(unsigned int *array)
+{
+	int node;
+	unsigned int nr = 0;
+
+	for_each_node_mask(node, cpuset_current_mems_allowed)
+		nr += array[node];
+
+	return nr;
+}
+
 #ifdef CONFIG_SYSCTL
 static void update_and_free_page(struct page *page)
 {
@@ -819,6 +830,26 @@ int hugetlb_reserve_pages(struct inode *
 	chg = region_chg(&inode->i_mapping->private_list, from, to);
 	if (chg < 0)
 		return chg;
+	/*
+	 * When cpuset is configured, it breaks the strict hugetlb page
+	 * reservation as the accounting is done on a global variable. Such
+	 * reservation is completely rubbish in the presence of cpuset because
+	 * the reservation is not checked against page availability for the
+	 * current cpuset. Application can still potentially OOM'ed by kernel
+	 * with lack of free htlb page in cpuset that the task is in.
+	 * Attempt to enforce strict accounting with cpuset is almost
+	 * impossible (or too ugly) because cpuset is too fluid that
+	 * task or memory node can be dynamically moved between cpusets.
+	 *
+	 * The change of semantics for shared hugetlb mapping with cpuset is
+	 * undesirable. However, in order to preserve some of the semantics,
+	 * we fall back to check against current free page availability as
+	 * a best attempt and hopefully to minimize the impact of changing
+	 * semantics that cpuset has.
+	 */
+	if (chg > cpuset_mems_nr(free_huge_pages_node))
+		return -ENOMEM;
+
 	ret = hugetlb_acct_memory(chg);
 	if (ret < 0)
 		return ret;
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
