From: akpm@linux-foundation.org
Subject: [merged] lib-rbtreec-optimize-rb_erase.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:38 -0700
Message-ID: <200904011839.n31IdcRZ008725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341AbZDASyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wstrepp@gmx.de, a.p.zijlstra@chello.nl, andrea@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     lib/rbtree.c: optimize rb_erase()
has been removed from the -mm tree.  Its filename was
     lib-rbtreec-optimize-rb_erase.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/rbtree.c: optimize rb_erase()
From: "Wolfram Strepp" <wstrepp@gmx.de>

Tfour 4 redundant if-conditions in function __rb_erase_color() in
lib/rbtree.c are removed.

In pseudo-source-code, the structure of the code is as follows:

if ((!A || B) && (!C || D)) {
	.
	.
	.
} else {
	if (!C || D) {//if this is true, it implies: (A == true) && (B == false)
		if (A) {//hence this always evaluates to 'true'...
			.
		}
		.
		//at this point, C always becomes true, because of:
		__rb_rotate_right/left();
		//and:
		other = parent->rb_right/left;
	}
	.
	.
	if (C) {//...and this too !
		.
	}
}

Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN lib/rbtree.c~lib-rbtreec-optimize-rb_erase lib/rbtree.c
--- a/lib/rbtree.c~lib-rbtreec-optimize-rb_erase
+++ a/lib/rbtree.c
@@ -163,17 +163,14 @@ static void __rb_erase_color(struct rb_n
 			{
 				if (!other->rb_right || rb_is_black(other->rb_right))
 				{
-					struct rb_node *o_left;
-					if ((o_left = other->rb_left))
-						rb_set_black(o_left);
+					rb_set_black(other->rb_left);
 					rb_set_red(other);
 					__rb_rotate_right(other, root);
 					other = parent->rb_right;
 				}
 				rb_set_color(other, rb_color(parent));
 				rb_set_black(parent);
-				if (other->rb_right)
-					rb_set_black(other->rb_right);
+				rb_set_black(other->rb_right);
 				__rb_rotate_left(parent, root);
 				node = root->rb_node;
 				break;
@@ -200,17 +197,14 @@ static void __rb_erase_color(struct rb_n
 			{
 				if (!other->rb_left || rb_is_black(other->rb_left))
 				{
-					register struct rb_node *o_right;
-					if ((o_right = other->rb_right))
-						rb_set_black(o_right);
+					rb_set_black(other->rb_right);
 					rb_set_red(other);
 					__rb_rotate_left(other, root);
 					other = parent->rb_left;
 				}
 				rb_set_color(other, rb_color(parent));
 				rb_set_black(parent);
-				if (other->rb_left)
-					rb_set_black(other->rb_left);
+				rb_set_black(other->rb_left);
 				__rb_rotate_right(parent, root);
 				node = root->rb_node;
 				break;
_

Patches currently in -mm which might be from wstrepp@gmx.de are

origin.patch

