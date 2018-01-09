From: akpm@linux-foundation.org
Subject: + ida-do-zeroing-in-ida_pre_get.patch added to -mm tree
Date: Mon, 08 Jan 2018 16:15:04 -0800
Message-ID: <5a540988.tBrKp8DT6DAmkLK5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbeAIAPH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jan 2018 19:15:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, ebiggers@google.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ida: do zeroing in ida_pre_get()
has been added to the -mm tree.  Its filename is
     ida-do-zeroing-in-ida_pre_get.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ida-do-zeroing-in-ida_pre_get.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ida-do-zeroing-in-ida_pre_get.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: ida: do zeroing in ida_pre_get()

As far as I can tell, the only place the per-cpu ida_bitmap is populated
is in ida_pre_get.  The pre-allocated element is stolen in two places in
ida_get_new_above, in both cases immediately followed by a memset(0).

Since ida_get_new_above is called with locks held, do the zeroing in
ida_pre_get, or rather let kmalloc() do it.  Also, apparently gcc
generates ~44 bytes of code to do a memset(, 0, 128):

$ scripts/bloat-o-meter vmlinux.{0,1}
add/remove: 0/0 grow/shrink: 2/1 up/down: 5/-88 (-83)
Function                                     old     new   delta
ida_pre_get                                  115     119      +4
vermagic                                      27      28      +1
ida_get_new_above                            715     627     -88

Link: http://lkml.kernel.org/r/20180108225634.15340-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c        |    2 --
 lib/radix-tree.c |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN lib/idr.c~ida-do-zeroing-in-ida_pre_get lib/idr.c
--- a/lib/idr.c~ida-do-zeroing-in-ida_pre_get
+++ a/lib/idr.c
@@ -300,7 +300,6 @@ int ida_get_new_above(struct ida *ida, i
 			bitmap = this_cpu_xchg(ida_bitmap, NULL);
 			if (!bitmap)
 				return -EAGAIN;
-			memset(bitmap, 0, sizeof(*bitmap));
 			bitmap->bitmap[0] = tmp >> RADIX_TREE_EXCEPTIONAL_SHIFT;
 			rcu_assign_pointer(*slot, bitmap);
 		}
@@ -333,7 +332,6 @@ int ida_get_new_above(struct ida *ida, i
 			bitmap = this_cpu_xchg(ida_bitmap, NULL);
 			if (!bitmap)
 				return -EAGAIN;
-			memset(bitmap, 0, sizeof(*bitmap));
 			__set_bit(bit, bitmap->bitmap);
 			radix_tree_iter_replace(root, &iter, slot, bitmap);
 		}
diff -puN lib/radix-tree.c~ida-do-zeroing-in-ida_pre_get lib/radix-tree.c
--- a/lib/radix-tree.c~ida-do-zeroing-in-ida_pre_get
+++ a/lib/radix-tree.c
@@ -2124,7 +2124,7 @@ int ida_pre_get(struct ida *ida, gfp_t g
 		preempt_enable();
 
 	if (!this_cpu_read(ida_bitmap)) {
-		struct ida_bitmap *bitmap = kmalloc(sizeof(*bitmap), gfp);
+		struct ida_bitmap *bitmap = kzalloc(sizeof(*bitmap), gfp);
 		if (!bitmap)
 			return 0;
 		if (this_cpu_cmpxchg(ida_bitmap, NULL, bitmap))
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

revert-async-simplify-lowest_in_progress.patch
ida-do-zeroing-in-ida_pre_get.patch

