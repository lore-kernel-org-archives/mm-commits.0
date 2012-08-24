From: akpm@linux-foundation.org
Subject: [merged] alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:00 -0700
Message-ID: <20120824184100.8B655100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:65465 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab2HXSlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:02 -0400
Received: by vcqp1 with SMTP id p1so311760vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, James.Bottomley@hansenpartnership.com, dave.anglin@bell.net, davem@davemloft.net, fengguang.wu@intel.com, ink@jurassic.park.msu.ru, kyle@parisc-linux.org, mattst88@gmail.com, rth@twiddle.net, tony.luck@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts
has been removed from the -mm tree.  Its filename was
     alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: alpha: redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

The following build error occurred during an alpha build:

net/core/sock.c:274:36: error: initializer element is not constant

Dave Anglin says:
> Here is the line in sock.i:
>
> struct static_key memalloc_socks = ((struct static_key) { .enabled =
> ((atomic_t) { (0) }) });

The above line contains two compound literals.  It also uses a designated
initializer to initialize the field enabled.  A compound literal is not a
constant expression.

The location of the above statement isn't fully clear, but if a compound
literal occurs outside the body of a function, the initializer list must
consist of constant expressions.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/atomic.h~alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts arch/alpha/include/asm/atomic.h
--- a/arch/alpha/include/asm/atomic.h~alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts
+++ a/arch/alpha/include/asm/atomic.h
@@ -14,8 +14,8 @@
  */
 
 
-#define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
-#define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
+#define ATOMIC_INIT(i)		{ (i) }
+#define ATOMIC64_INIT(i)	{ (i) }
 
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic64_read(v)	(*(volatile long *)&(v)->counter)
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch

