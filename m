From: akpm@linux-foundation.org
Subject: + lockdep-lookup_chain_cache-comment-errata.patch added to -mm tree
Date: Thu, 19 Apr 2007 14:59:37 -0700
Message-ID: <200704192159.l3JLxbIb032124@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198AbXDSWAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 18:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, mingo@elte.hu


The patch titled
     lockdep: lookup_chain_cache comment errata
has been added to the -mm tree.  Its filename is
     lockdep-lookup_chain_cache-comment-errata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockdep: lookup_chain_cache comment errata
From: Jarek Poplawski <jarkao2@o2.pl>

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/lockdep.c~lockdep-lookup_chain_cache-comment-errata kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-lookup_chain_cache-comment-errata
+++ a/kernel/lockdep.c
@@ -1309,8 +1309,9 @@ out_unlock_set:
 
 /*
  * Look up a dependency chain. If the key is not present yet then
- * add it and return 0 - in this case the new dependency chain is
- * validated. If the key is already hashed, return 1.
+ * add it and return 1 - in this case the new dependency chain is
+ * validated. If the key is already hashed, return 0.
+ * (On return with 1 graph_lock is held.)
  */
 static inline int lookup_chain_cache(u64 chain_key, struct lock_class *class)
 {
_

Patches currently in -mm which might be from jarkao2@o2.pl are

ppp_generic-fix-lockdep-warning.patch
lockdep-lookup_chain_cache-comment-errata.patch
