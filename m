From: akpm@linux-foundation.org
Subject: [merged] lib-genallocc-remove-unmatched-write_lock-in-gen_pool_destroy.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:01 -0700
Message-ID: <200906171838.n5HIc12D004102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756162AbZFQSt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:49:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zygo.blaxell@xandros.com, stable@kernel.org, swise@opengridcomputing.com, trivial@kernel.org, mm-commits@vger.kernel.org


The patch titled
     lib/genalloc.c: remove unmatched write_lock() in gen_pool_destroy
has been removed from the -mm tree.  Its filename was
     lib-genallocc-remove-unmatched-write_lock-in-gen_pool_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/genalloc.c: remove unmatched write_lock() in gen_pool_destroy
From: Zygo Blaxell <zygo.blaxell@xandros.com>

There is a call to write_lock() in gen_pool_destroy which is not balanced
by any corresponding write_unlock().  This causes problems with preemption
because the preemption-disable counter is incremented in the write_lock()
call, but never decremented by any call to write_unlock().  This bug is
gen_pool_destroy, and one of them is non-x86 arch-specific code.

Signed-off-by: Zygo Blaxell <zygo.blaxell@xandros.com>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/genalloc.c~lib-genallocc-remove-unmatched-write_lock-in-gen_pool_destroy lib/genalloc.c
--- a/lib/genalloc.c~lib-genallocc-remove-unmatched-write_lock-in-gen_pool_destroy
+++ a/lib/genalloc.c
@@ -85,7 +85,6 @@ void gen_pool_destroy(struct gen_pool *p
 	int bit, end_bit;
 
 
-	write_lock(&pool->lock);
 	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 		list_del(&chunk->next_chunk);
_

Patches currently in -mm which might be from zygo.blaxell@xandros.com are

origin.patch

