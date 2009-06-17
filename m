From: akpm@linux-foundation.org
Subject: [merged] mm-alloc_large_system_hash-check-order.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:28 -0700
Message-ID: <200906171833.n5HIXSXb031952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760160AbZFQSe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, cl@linux.com, dada1@cosmosbay.com, davem@davemloft.net, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: alloc_large_system_hash check order
has been removed from the -mm tree.  Its filename was
     mm-alloc_large_system_hash-check-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: alloc_large_system_hash check order
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

On an x86_64 with 4GB ram, tcp_init()'s call to alloc_large_system_hash(),
to allocate tcp_hashinfo.ehash, is now triggering an mmotm WARN_ON_ONCE on
order >= MAX_ORDER - it's hoping for order 11.  alloc_large_system_hash()
had better make its own check on the order.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: David Miller <davem@davemloft.net>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-alloc_large_system_hash-check-order mm/page_alloc.c
--- a/mm/page_alloc.c~mm-alloc_large_system_hash-check-order
+++ a/mm/page_alloc.c
@@ -4511,7 +4511,10 @@ void *__init alloc_large_system_hash(con
 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
 		else {
 			unsigned long order = get_order(size);
-			table = (void*) __get_free_pages(GFP_ATOMIC, order);
+
+			if (order < MAX_ORDER)
+				table = (void *)__get_free_pages(GFP_ATOMIC,
+								order);
 			/*
 			 * If bucketsize is not a power-of-two, we may free
 			 * some pages at the end of hash table.
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
getrusage-fill-ru_maxrss-value.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch
elf-reduce-default-max_map_count-to-be-safe-value.patch
prio_tree-debugging-patch.patch

