From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb_cgroup-round-limit_in_bytes-down-to-hugepage-size.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:46:12 -0700
Message-ID: <57435e04.GncJuA4QQuzu+d0n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbcEWTqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kernel@kyup.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb_cgroup: round limit_in_bytes down to hugepage size
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-round-limit_in_bytes-down-to-hugepage-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb_cgroup: round limit_in_bytes down to hugepage size

The page_counter rounds limits down to page size values.  This makes
sense, except in the case of hugetlb_cgroup where it's not possible to
charge partial hugepages.  If the hugetlb_cgroup margin is less than the
hugepage size being charged, it will fail as expected.

Round the hugetlb_cgroup limit down to hugepage size, since it is the
effective limit of the cgroup.

For consistency, round down PAGE_COUNTER_MAX as well when a hugetlb_cgroup
is created: this prevents error reports when a user cannot restore the
value to the kernel default.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nikolay Borisov <kernel@kyup.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff -puN mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-round-limit_in_bytes-down-to-hugepage-size mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-round-limit_in_bytes-down-to-hugepage-size
+++ a/mm/hugetlb_cgroup.c
@@ -67,26 +67,42 @@ static inline bool hugetlb_cgroup_have_u
 	return false;
 }
 
+static void hugetlb_cgroup_init(struct hugetlb_cgroup *h_cgroup,
+				struct hugetlb_cgroup *parent_h_cgroup)
+{
+	int idx;
+
+	for (idx = 0; idx < HUGE_MAX_HSTATE; idx++) {
+		struct page_counter *counter = &h_cgroup->hugepage[idx];
+		struct page_counter *parent = NULL;
+		unsigned long limit;
+		int ret;
+
+		if (parent_h_cgroup)
+			parent = &parent_h_cgroup->hugepage[idx];
+		page_counter_init(counter, parent);
+
+		limit = round_down(PAGE_COUNTER_MAX,
+				   1 << huge_page_order(&hstates[idx]));
+		ret = page_counter_limit(counter, limit);
+		VM_BUG_ON(ret);
+	}
+}
+
 static struct cgroup_subsys_state *
 hugetlb_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
 	struct hugetlb_cgroup *parent_h_cgroup = hugetlb_cgroup_from_css(parent_css);
 	struct hugetlb_cgroup *h_cgroup;
-	int idx;
 
 	h_cgroup = kzalloc(sizeof(*h_cgroup), GFP_KERNEL);
 	if (!h_cgroup)
 		return ERR_PTR(-ENOMEM);
 
-	if (parent_h_cgroup) {
-		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
-			page_counter_init(&h_cgroup->hugepage[idx],
-					  &parent_h_cgroup->hugepage[idx]);
-	} else {
+	if (!parent_h_cgroup)
 		root_h_cgroup = h_cgroup;
-		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
-			page_counter_init(&h_cgroup->hugepage[idx], NULL);
-	}
+
+	hugetlb_cgroup_init(h_cgroup, parent_h_cgroup);
 	return &h_cgroup->css;
 }
 
@@ -285,6 +301,7 @@ static ssize_t hugetlb_cgroup_write(stru
 		return ret;
 
 	idx = MEMFILE_IDX(of_cft(of)->private);
+	nr_pages = round_down(nr_pages, 1 << huge_page_order(&hstates[idx]));
 
 	switch (MEMFILE_ATTR(of_cft(of)->private)) {
 	case RES_LIMIT:
_

Patches currently in -mm which might be from rientjes@google.com are

mm-thp-khugepaged-should-scan-when-sleep-value-is-written.patch
mm-migrate-increment-fail-count-on-enomem.patch

