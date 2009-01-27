From: akpm@linux-foundation.org
Subject: + lib-rbtreec-optimize-rb_erase.patch added to -mm tree
Date: Tue, 27 Jan 2009 13:56:25 -0800
Message-ID: <200901272156.n0RLuP9G016541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939AbZA0V4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 16:56:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wstrepp@gmx.de, a.p.zijlstra@chello.nl, andrea@qumranet.com


The patch titled
     lib/rbtree.c: optimize rb_erase()
has been added to the -mm tree.  Its filename is
     lib-rbtreec-optimize-rb_erase.patch

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

lib-rbtreec-optimize-rb_erase.patch

