From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-sleeping-function-warning-from-__put_anon_vma.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:41:57 -0700
Message-ID: <5390c805.+fCdgCvFZuR0Tvd4%akpm__16563.0439449616$1401997339$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaFETl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, peterz@infradead.org, davej@redhat.com, hughd@google.com

Subject: [merged] mm-fix-sleeping-function-warning-from-__put_anon_vma.patch removed from -mm tree
To: hughd@google.com,davej@redhat.com,peterz@infradead.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:41:57 -0700


The patch titled
     Subject: mm: fix sleeping function warning from __put_anon_vma
has been removed from the -mm tree.  Its filename was
     mm-fix-sleeping-function-warning-from-__put_anon_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix sleeping function warning from __put_anon_vma

Trinity reports BUG:
sleeping function called from invalid context at kernel/locking/rwsem.c:47
in_atomic(): 0, irqs_disabled(): 0, pid: 5787, name: trinity-c27
__might_sleep < down_write < __put_anon_vma < page_get_anon_vma <
migrate_pages < compact_zone < compact_zone_order < try_to_compact_pages ..

Right, since conversion to mutex then rwsem, we should not put_anon_vma()
from inside an rcu_read_lock()ed section: fix the two places that did so. 
And add might_sleep() to anon_vma_free(), as suggested by Peter Zijlstra.

Fixes: 88c22088bf23 ("mm: optimize page_lock_anon_vma() fast-path")
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-fix-sleeping-function-warning-from-__put_anon_vma mm/rmap.c
--- a/mm/rmap.c~mm-fix-sleeping-function-warning-from-__put_anon_vma
+++ a/mm/rmap.c
@@ -103,6 +103,7 @@ static inline void anon_vma_free(struct
 	 * LOCK should suffice since the actual taking of the lock must
 	 * happen _before_ what follows.
 	 */
+	might_sleep();
 	if (rwsem_is_locked(&anon_vma->root->rwsem)) {
 		anon_vma_lock_write(anon_vma);
 		anon_vma_unlock_write(anon_vma);
@@ -426,8 +427,9 @@ struct anon_vma *page_get_anon_vma(struc
 	 * above cannot corrupt).
 	 */
 	if (!page_mapped(page)) {
+		rcu_read_unlock();
 		put_anon_vma(anon_vma);
-		anon_vma = NULL;
+		return NULL;
 	}
 out:
 	rcu_read_unlock();
@@ -477,9 +479,9 @@ struct anon_vma *page_lock_anon_vma_read
 	}
 
 	if (!page_mapped(page)) {
+		rcu_read_unlock();
 		put_anon_vma(anon_vma);
-		anon_vma = NULL;
-		goto out;
+		return NULL;
 	}
 
 	/* we pinned the anon_vma, its safe to sleep */
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-mm-introduce-lowlimit-reclaim-fix2patch.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o-om-control-fixpatch.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

