From: akpm@linux-foundation.org
Subject: [merged]
 z3fold-use-kref-to-prevent-page-free-compact-race.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:22:37 -0800
Message-ID: <20171120212237.W7D5x9YV8%akpm__1069.29496764696$1511212964$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39930 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdKTVWj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:22:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Oleksiy.Avramchenko@sony.com, stable@vger.kernel.org, vitaly.wool@sonymobile.com, vitalywool@gmail.com


The patch titled
     Subject: mm/z3fold.c: use kref to prevent page free/compact race
has been removed from the -mm tree.  Its filename was
     z3fold-use-kref-to-prevent-page-free-compact-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: mm/z3fold.c: use kref to prevent page free/compact race

There is a race in the current z3fold implementation between do_compact()
called in a work queue context and the page release procedure when page's
kref goes to 0.  do_compact() may be waiting for page lock, which is
released by release_z3fold_page_locked right before putting the page onto
the "stale" list, and then the page may be freed as do_compact() modifies
its contents.

The mechanism currently implemented to handle that (checking the
PAGE_STALE flag) is not reliable enough.  Instead, we'll use page's kref
counter to guarantee that the page is not released if its compaction is
scheduled.  It then becomes compaction function's responsibility to
decrease the counter and quit immediately if the page was actually freed.

Link: http://lkml.kernel.org/r/20171117092032.00ea56f42affbed19f4fcc6c@gmail.com
Signed-off-by: Vitaly Wool <vitaly.wool@sonymobile.com>
Cc: <Oleksiy.Avramchenko@sony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/z3fold.c~z3fold-use-kref-to-prevent-page-free-compact-race mm/z3fold.c
--- a/mm/z3fold.c~z3fold-use-kref-to-prevent-page-free-compact-race
+++ a/mm/z3fold.c
@@ -404,8 +404,7 @@ static void do_compact_page(struct z3fol
 		WARN_ON(z3fold_page_trylock(zhdr));
 	else
 		z3fold_page_lock(zhdr);
-	if (test_bit(PAGE_STALE, &page->private) ||
-	    !test_and_clear_bit(NEEDS_COMPACTING, &page->private)) {
+	if (WARN_ON(!test_and_clear_bit(NEEDS_COMPACTING, &page->private))) {
 		z3fold_page_unlock(zhdr);
 		return;
 	}
@@ -413,6 +412,11 @@ static void do_compact_page(struct z3fol
 	list_del_init(&zhdr->buddy);
 	spin_unlock(&pool->lock);
 
+	if (kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
+		atomic64_dec(&pool->pages_nr);
+		return;
+	}
+
 	z3fold_compact_page(zhdr);
 	unbuddied = get_cpu_ptr(pool->unbuddied);
 	fchunks = num_free_chunks(zhdr);
@@ -753,9 +757,11 @@ static void z3fold_free(struct z3fold_po
 		list_del_init(&zhdr->buddy);
 		spin_unlock(&pool->lock);
 		zhdr->cpu = -1;
+		kref_get(&zhdr->refcount);
 		do_compact_page(zhdr, true);
 		return;
 	}
+	kref_get(&zhdr->refcount);
 	queue_work_on(zhdr->cpu, pool->compact_wq, &zhdr->work);
 	z3fold_page_unlock(zhdr);
 }
_

Patches currently in -mm which might be from vitalywool@gmail.com are


