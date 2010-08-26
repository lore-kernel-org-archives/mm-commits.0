From: akpm@linux-foundation.org
Subject: + mm-fix-hang-on-anon_vma-root-lock.patch added to -mm tree
Date: Thu, 26 Aug 2010 14:31:58 -0700
Message-ID: <201008262131.o7QLVwDd015700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267Ab0HZVck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Aug 2010 17:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, davem@davemloft.net, riel@redhat.com


The patch titled
     mm: fix hang on anon_vma->root->lock
has been added to the -mm tree.  Its filename is
     mm-fix-hang-on-anon_vma-root-lock.patch

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
Subject: mm: fix hang on anon_vma->root->lock
From: Hugh Dickins <hughd@google.com>

After several hours, kbuild tests hang with anon_vma_prepare() spinning on
a newly allocated anon_vma's lock - on a box with
CONFIG_TREE_PREEMPT_RCU=y (which makes this very much more likely, but it
could happen without).

The ever-subtle page_lock_anon_vma() now needs a further twist: since
anon_vma_prepare() and anon_vma_fork() are liable to change the ->root of
a reused anon_vma structure at any moment, page_lock_anon_vma() needs to
check page_mapped() again before succeeding, otherwise
page_unlock_anon_vma() might address a different root->lock.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-fix-hang-on-anon_vma-root-lock mm/rmap.c
--- a/mm/rmap.c~mm-fix-hang-on-anon_vma-root-lock
+++ a/mm/rmap.c
@@ -316,7 +316,7 @@ void __init anon_vma_init(void)
  */
 struct anon_vma *page_lock_anon_vma(struct page *page)
 {
-	struct anon_vma *anon_vma;
+	struct anon_vma *anon_vma, *root_anon_vma;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
@@ -327,8 +327,21 @@ struct anon_vma *page_lock_anon_vma(stru
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	anon_vma_lock(anon_vma);
-	return anon_vma;
+	root_anon_vma = ACCESS_ONCE(anon_vma->root);
+	spin_lock(&root_anon_vma->lock);
+
+	/*
+	 * If this page is still mapped, then its anon_vma cannot have been
+	 * freed.  But if it has been unmapped, we have no security against
+	 * the anon_vma structure being freed and reused (for another anon_vma:
+	 * SLAB_DESTROY_BY_RCU guarantees that - so the spin_lock above cannot
+	 * corrupt): with anon_vma_prepare() or anon_vma_fork() redirecting
+	 * anon_vma->root before page_unlock_anon_vma() is called to unlock.
+	 */
+	if (page_mapped(page))
+		return anon_vma;
+
+	spin_unlock(&root_anon_vma->lock);
 out:
 	rcu_read_unlock();
 	return NULL;
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-hang-on-anon_vma-root-lock.patch
linux-next.patch
ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm.patch
ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2.patch
prio_tree-debugging-patch.patch

