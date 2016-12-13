From: akpm@linux-foundation.org
Subject: [patch 083/123] mm: add three more cond_resched() in swapoff
Date: Mon, 12 Dec 2016 16:44:44 -0800
Message-ID: <584f447c.6CAetayjxvlSb11m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932380AbcLMAoq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com, edumazet@google.com, rientjes@google.com

From: Hugh Dickins <hughd@google.com>
Subject: mm: add three more cond_resched() in swapoff

Add a cond_resched() in the unuse_pmd_range() loop (so as to call it even
when pmd none or trans_huge, like zap_pmd_range() does); and in the
unuse_mm() loop (since that might skip over many vmas).  shmem_unuse() and
radix_tree_locate_item() look good enough already.

Those were the obvious places, but in fact the stalls came from
find_next_to_unuse(), which sometimes scans through many unused entries. 
Apply scan_swap_map()'s LATENCY_LIMIT of 256 there too; and only go off to
test frontswap_map when a used entry is found.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1612052155140.13021@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/swapfile.c~mm-add-three-more-cond_resched-in-swapoff mm/swapfile.c
--- a/mm/swapfile.c~mm-add-three-more-cond_resched-in-swapoff
+++ a/mm/swapfile.c
@@ -1234,6 +1234,7 @@ static inline int unuse_pmd_range(struct
 
 	pmd = pmd_offset(pud, addr);
 	do {
+		cond_resched();
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			continue;
@@ -1313,6 +1314,7 @@ static int unuse_mm(struct mm_struct *mm
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->anon_vma && (ret = unuse_vma(vma, entry, page)))
 			break;
+		cond_resched();
 	}
 	up_read(&mm->mmap_sem);
 	return (ret < 0)? ret: 0;
@@ -1350,15 +1352,12 @@ static unsigned int find_next_to_unuse(s
 			prev = 0;
 			i = 1;
 		}
-		if (frontswap) {
-			if (frontswap_test(si, i))
-				break;
-			else
-				continue;
-		}
 		count = READ_ONCE(si->swap_map[i]);
 		if (count && swap_count(count) != SWAP_MAP_BAD)
-			break;
+			if (!frontswap || frontswap_test(si, i))
+				break;
+		if ((i % LATENCY_LIMIT) == 0)
+			cond_resched();
 	}
 	return i;
 }
_
