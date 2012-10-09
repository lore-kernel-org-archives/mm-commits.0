From: akpm@linux-foundation.org
Subject: [merged] rbtree-test-fix-sparse-warning-about-64-bit-constant.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:48 -0700
Message-ID: <20121009180948.C20271E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50800 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab2JISJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:49 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574008yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree test: fix sparse warning about 64-bit constant
has been removed from the -mm tree.  Its filename was
     rbtree-test-fix-sparse-warning-about-64-bit-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree test: fix sparse warning about 64-bit constant

Just a small fix to make sparse happy.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reported-by: Fengguang Wu <wfg@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/rbtree_test.c~rbtree-test-fix-sparse-warning-about-64-bit-constant lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree-test-fix-sparse-warning-about-64-bit-constant
+++ a/lib/rbtree_test.c
@@ -88,7 +88,7 @@ static int rbtree_test_init(void)
 
 	printk(KERN_ALERT "rbtree testing");
 
-	prandom32_seed(&rnd, 3141592653589793238);
+	prandom32_seed(&rnd, 3141592653589793238ULL);
 	init();
 
 	time1 = get_cycles();
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

