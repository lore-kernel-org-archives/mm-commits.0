From: akpm@linux-foundation.org
Subject: + lib-genallocc-remove-unmatched-write_lock-in-gen_pool_destroy.patch added to -mm tree
Date: Mon, 15 Jun 2009 15:24:12 -0700
Message-ID: <200906152224.n5FMOCIa008643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935592AbZFOWZP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 18:25:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zygo.blaxell@xandros.com, stable@kernel.org, swise@opengridcomputing.com, trivial@kernel.org


The patch titled
     lib/genalloc.c: remove unmatched write_lock() in gen_pool_destroy
has been added to the -mm tree.  Its filename is
     lib-genallocc-remove-unmatched-write_lock-in-gen_pool_destroy.patch

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

lib-genallocc-remove-unmatched-write_lock-in-gen_pool_destroy.patch

