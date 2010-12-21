From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch added to -mm tree
Date: Tue, 21 Dec 2010 15:34:19 -0800
Message-ID: <201012212334.oBLNYJFL032379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab0LUXex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 18:34:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, minchan.kim@gmail.com


The patch titled
     mm/hugetlb.c: fix error-path memory leak in nr_hugepages_store_common()
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch

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
Subject: mm/hugetlb.c: fix error-path memory leak in nr_hugepages_store_common()
From: Jesper Juhl <jj@chaosbits.net>

The NODEMASK_ALLOC macro may dynamically allocate memory for its second
argument ('nodes_allowed' in this context).

In nr_hugepages_store_common() we may abort early if strict_strtoul()
fails, but in that case we do not free the memory already allocated to
'nodes_allowed', causing a memory leak.

This patch closes the leak by freeing the memory in the error path.

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
+		kfree(nodes_allowed);
 		return 0;
+	}
 
 	h = kobj_to_hstate(kobj, &nid);
 	if (nid == NUMA_NO_NODE) {
_

Patches currently in -mm which might be from jj@chaosbits.net are

linux-next.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

