From: akpm@linux-foundation.org
Subject: [patch 2/2] mm: prevent NR_ISOLATE_* stats from going negative
Date: Thu, 20 Apr 2017 14:37:46 -0700
Message-ID: <58f92a2a.6ePF+Z/t+BxNmArM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44512 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971274AbdDTVhr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Apr 2017 17:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rabinv@axis.com, mhocko@suse.com, minchan@kernel.org, ming.ling@spreadtrum.com, stable@vger.kernel.org, vbabka@suse.cz

From: Rabin Vincent <rabinv@axis.com>
Subject: mm: prevent NR_ISOLATE_* stats from going negative

Commit 6afcf8ef0ca0 ("mm, compaction: fix NR_ISOLATED_* stats for pfn
based migration") moved the dec_node_page_state() call (along with the
page_is_file_cache() call) to after putback_lru_page().  But
page_is_file_cache() can change after putback_lru_page() is called, so it
should be called before putback_lru_page(), as it was before that patch,
to prevent NR_ISOLATE_* stats from going negative.

Without this fix, non-CONFIG_SMP kernels end up hanging in the
while(too_many_isolated()) { congestion_wait() } loop in
shrink_active_list() due to the negative stats.

 Mem-Info:
  active_anon:32567 inactive_anon:121 isolated_anon:1
  active_file:6066 inactive_file:6639 isolated_file:4294967295
                                                    ^^^^^^^^^^
  unevictable:0 dirty:115 writeback:0 unstable:0
  slab_reclaimable:2086 slab_unreclaimable:3167
  mapped:3398 shmem:18366 pagetables:1145 bounce:0
  free:1798 free_pcp:13 free_cma:0

Fixes: 6afcf8ef0ca0 ("mm, compaction: fix NR_ISOLATED_* stats for pfn based migration")
Link: http://lkml.kernel.org/r/1492683865-27549-1-git-send-email-rabin.vincent@axis.com
Signed-off-by: Rabin Vincent <rabinv@axis.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Ming Ling <ming.ling@spreadtrum.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-prevent-nr_isolate_-stats-from-going-negative mm/migrate.c
--- a/mm/migrate.c~mm-prevent-nr_isolate_-stats-from-going-negative
+++ a/mm/migrate.c
@@ -184,9 +184,9 @@ void putback_movable_pages(struct list_h
 			unlock_page(page);
 			put_page(page);
 		} else {
-			putback_lru_page(page);
 			dec_node_page_state(page, NR_ISOLATED_ANON +
 					page_is_file_cache(page));
+			putback_lru_page(page);
 		}
 	}
 }
_
