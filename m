From: akpm@linux-foundation.org
Subject: [patch 055/117] mm/hugetlb.c: use first_memory_node
Date: Thu, 19 May 2016 17:11:40 -0700
Message-ID: <573e563c.t7QvAkwOFvPTzOsU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbcETALl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:11:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb.c: use first_memory_node

Instead of open-coding it.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-use-first_memory_node mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-use-first_memory_node
+++ a/mm/hugetlb.c
@@ -2684,8 +2684,8 @@ void __init hugetlb_add_hstate(unsigned
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
-	h->next_nid_to_alloc = first_node(node_states[N_MEMORY]);
-	h->next_nid_to_free = first_node(node_states[N_MEMORY]);
+	h->next_nid_to_alloc = first_memory_node;
+	h->next_nid_to_free = first_memory_node;
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
 
_
