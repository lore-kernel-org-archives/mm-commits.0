From: akpm@linux-foundation.org
Subject: [merged] lib-bump-stackdepot-capacity-from-16mb-to-128mb.patch
 removed from -mm tree
Date: Fri, 28 Oct 2016 11:30:36 -0700
Message-ID: <5813994c.TJVPV0Y63PF9cwmu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45744 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030224AbcJ1Sah (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:30:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, glider@google.com, iamjoonsoo.kim@lge.com, sploving1@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: bump stackdepot capacity from 16MB to 128MB
has been removed from the -mm tree.  Its filename was
     lib-bump-stackdepot-capacity-from-16mb-to-128mb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: lib/stackdepot.c: bump stackdepot capacity from 16MB to 128MB

KASAN uses stackdepot to memorize stacks for all kmalloc/kfree calls. 
Current stackdepot capacity is 16MB (1024 top level entries x 4 pages on
second level).  Size of each stack is (num_frames + 3) * sizeof(long). 
Which gives us ~84K stacks.  This capacity was chosen empirically and it
is enough to run kernel normally.

However, when lots of configs are enabled and a fuzzer tries to maximize
code coverage, it easily hits the limit within tens of minutes.  I've
tested for long a time with number of top level entries bumped 4x (4096). 
And I think I've seen overflow only once.  But I don't have all configs
enabled and code coverage has not reached maximum yet.  So bump it 8x to
8192.  Since we have two-level table, memory cost of this is very moderate
-- currently the top-level table is 8KB, with this patch it is 64KB, which
is negligible under KASAN.

Here is some approx math.

128MB allows us to memorize ~670K stacks (assuming stack is ~200b).  I've
grepped kernel for kmalloc|kfree|kmem_cache_alloc|kmem_cache_free|
kzalloc|kstrdup|kstrndup|kmemdup and it gives ~60K matches.  Most of
alloc/free call sites are reachable with only one stack.  But some utility
functions can have large fanout.  Assuming average fanout is 5x, total
number of alloc/free stacks is ~300K.

Link: http://lkml.kernel.org/r/1476458416-122131-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Baozeng Ding <sploving1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/stackdepot.c~lib-bump-stackdepot-capacity-from-16mb-to-128mb lib/stackdepot.c
--- a/lib/stackdepot.c~lib-bump-stackdepot-capacity-from-16mb-to-128mb
+++ a/lib/stackdepot.c
@@ -50,7 +50,7 @@
 					STACK_ALLOC_ALIGN)
 #define STACK_ALLOC_INDEX_BITS (DEPOT_STACK_BITS - \
 		STACK_ALLOC_NULL_PROTECTION_BITS - STACK_ALLOC_OFFSET_BITS)
-#define STACK_ALLOC_SLABS_CAP 1024
+#define STACK_ALLOC_SLABS_CAP 8192
 #define STACK_ALLOC_MAX_SLABS \
 	(((1LL << (STACK_ALLOC_INDEX_BITS)) < STACK_ALLOC_SLABS_CAP) ? \
 	 (1LL << (STACK_ALLOC_INDEX_BITS)) : STACK_ALLOC_SLABS_CAP)
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-support-panic_on_warn.patch

