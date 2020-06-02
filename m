From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 071/128] mm/swapfile.c: __swap_entry_free() always
 free 1 entry
Date: Tue, 02 Jun 2020 13:14:04 -0700
Message-ID: <20200602201404.snD5-mPgW%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBUOF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:14:05 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/swapfile.c: __swap_entry_free() always free 1 entry

__swap_entry_free() always frees 1 entry.  Let's remove the usage.

Link: http://lkml.kernel.org/r/20200501015259.32237-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-__swap_entry_free-always-free-1-entry
+++ a/mm/swapfile.c
@@ -1273,13 +1273,14 @@ unlock_out:
 }
 
 static unsigned char __swap_entry_free(struct swap_info_struct *p,
-				       swp_entry_t entry, unsigned char usage)
+				       swp_entry_t entry)
 {
 	struct swap_cluster_info *ci;
 	unsigned long offset = swp_offset(entry);
+	unsigned char usage;
 
 	ci = lock_cluster_or_swap_info(p, offset);
-	usage = __swap_entry_free_locked(p, offset, usage);
+	usage = __swap_entry_free_locked(p, offset, 1);
 	unlock_cluster_or_swap_info(p, ci);
 	if (!usage)
 		free_swap_slot(entry);
@@ -1314,7 +1315,7 @@ void swap_free(swp_entry_t entry)
 
 	p = _swap_info_get(entry);
 	if (p)
-		__swap_entry_free(p, entry, 1);
+		__swap_entry_free(p, entry);
 }
 
 /*
@@ -1737,7 +1738,7 @@ int free_swap_and_cache(swp_entry_t entr
 
 	p = _swap_info_get(entry);
 	if (p) {
-		count = __swap_entry_free(p, entry, 1);
+		count = __swap_entry_free(p, entry);
 		if (count == SWAP_HAS_CACHE &&
 		    !swap_page_trans_huge_swapped(p, entry))
 			__try_to_reclaim_swap(p, swp_offset(entry),
_
