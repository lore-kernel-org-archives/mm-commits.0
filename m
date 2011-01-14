From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:57 -0800
Message-ID: <201101142251.p0EMplGw005547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab1ANWvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm/hugetlb.c: fix error-path memory leak in nr_hugepages_store_common()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/hugetlb.c: fix error-path memory leak in nr_hugepages_store_common()
From: Jesper Juhl <jj@chaosbits.net>

The NODEMASK_ALLOC macro may dynamically allocate memory for its second
argument ('nodes_allowed' in this context).

In nr_hugepages_store_common() we may abort early if strict_strtoul()
fails, but in that case we do not free the memory already allocated to
'nodes_allowed', causing a memory leak.

This patch closes the leak by freeing the memory in the error path.

[akpm@linux-foundation.org: use NODEMASK_FREE, per Minchan Kim]
Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common
+++ a/mm/hugetlb.c
@@ -1374,8 +1374,10 @@ static ssize_t nr_hugepages_store_common
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
 	err = strict_strtoul(buf, 10, &count);
-	if (err)
+	if (err) {
+		NODEMASK_FREE(nodes_allowed);
 		return 0;
+	}
 
 	h = kobj_to_hstate(kobj, &nid);
 	if (nid == NUMA_NO_NODE) {
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
linux-next.patch
audit-always-follow-va_copy-with-va_end.patch

