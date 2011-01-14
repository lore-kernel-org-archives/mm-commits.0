From: akpm@linux-foundation.org
Subject: [merged] hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:13 -0800
Message-ID: <201101142252.p0EMq30V005577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab1ANWwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, aarcange@redhat.com, caiqian@redhat.com, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: check the return value of string conversion in sysctl handler
has been removed from the -mm tree.  Its filename was
     hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: check the return value of string conversion in sysctl handler
From: Michal Hocko <mhocko@suse.cz>

proc_doulongvec_minmax may fail if the given buffer doesn't represent a
valid number.  If we provide something invalid we will initialize the
resulting value (nr_overcommit_huge_pages in this case) to a random value
from the stack.

The issue was introduced by a3d0c6aa when the default handler has been
replaced by the helper function where we do not check the return value.

Reproducer:
echo "" > /proc/sys/vm/nr_overcommit_hugepages

[akpm@linux-foundation.org: correctly propagate proc_doulongvec_minmax return code]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler
+++ a/mm/hugetlb.c
@@ -1859,13 +1859,16 @@ static int hugetlb_sysctl_handler_common
 {
 	struct hstate *h = &default_hstate;
 	unsigned long tmp;
+	int ret;
 
 	if (!write)
 		tmp = h->max_huge_pages;
 
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
-	proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+		goto out;
 
 	if (write) {
 		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
@@ -1880,8 +1883,8 @@ static int hugetlb_sysctl_handler_common
 		if (nodes_allowed != &node_states[N_HIGH_MEMORY])
 			NODEMASK_FREE(nodes_allowed);
 	}
-
-	return 0;
+out:
+	return ret;
 }
 
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
@@ -1919,21 +1922,24 @@ int hugetlb_overcommit_handler(struct ct
 {
 	struct hstate *h = &default_hstate;
 	unsigned long tmp;
+	int ret;
 
 	if (!write)
 		tmp = h->nr_overcommit_huge_pages;
 
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
-	proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+		goto out;
 
 	if (write) {
 		spin_lock(&hugetlb_lock);
 		h->nr_overcommit_huge_pages = tmp;
 		spin_unlock(&hugetlb_lock);
 	}
