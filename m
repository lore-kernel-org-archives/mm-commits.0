From: akpm@linux-foundation.org
Subject: + lib-rbtreec-fix-typo-in-comment-of-____rb_erase_color.patch
 added to -mm tree
Date: Fri, 21 Oct 2016 16:47:00 -0700
Message-ID: <580aa8f4.3rAffNB0dfYSLl3A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935413AbcJUXrB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2016 19:47:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fykcee1@gmail.com, guangrong.xiao@linux.intel.com, weiyang@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/rbtree.c: fix typo in comment of ____rb_erase_color
has been added to the -mm tree.  Its filename is
     lib-rbtreec-fix-typo-in-comment-of-____rb_erase_color.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-rbtreec-fix-typo-in-comment-of-____rb_erase_color.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-rbtreec-fix-typo-in-comment-of-____rb_erase_color.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jie Chen <fykcee1@gmail.com>
Subject: lib/rbtree.c: fix typo in comment of ____rb_erase_color

In Case 3 of `sibling == parent->rb_right':

Right rotation will not change color of sl and S in the diagram
(i.e. should not change "sl" to "Sl", "S" to "s")

In Case 3 of `sibling == parent->rb_left':

     (p)           (p)
     / \           / \
    S   N    -->  sr  N
   / \           /
  Sl  sr        S
               /
              Sl

  This is actually left rotation at "S", not right rotation.

In Case 4 of `sibling == parent->rb_left':

     (p)             (s)
     / \             / \
    S   N     -->   Sl  P
   / \                 / \
  sl (sr)            (sr) N

  This is actually right rotation at "(p)" + color flips, not left
  rotation + color flips.

Link: http://lkml.kernel.org/r/1472391115-3702-1-git-send-email-fykcee1@gmail.com
Signed-off-by: Jie Chen <fykcee1@gmail.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN lib/rbtree.c~lib-rbtreec-fix-typo-in-comment-of-____rb_erase_color lib/rbtree.c
--- a/lib/rbtree.c~lib-rbtreec-fix-typo-in-comment-of-____rb_erase_color
+++ a/lib/rbtree.c
@@ -296,11 +296,26 @@ ____rb_erase_color(struct rb_node *paren
 				 *
 				 *   (p)           (p)
 				 *   / \           / \
-				 *  N   S    -->  N   Sl
+				 *  N   S    -->  N   sl
 				 *     / \             \
-				 *    sl  Sr            s
+				 *    sl  Sr            S
 				 *                       \
 				 *                        Sr
+				 *
+				 * Note: p might be red, and then both
+				 * p and sl are red after rotation(which
+				 * breaks property 4). This is fixed in
+				 * Case 4 (in __rb_rotate_set_parents()
+				 *         which set sl the color of p
+				 *         and set p RB_BLACK)
+				 *
+				 *   (p)            (sl)
+				 *   / \            /  \
+				 *  N   sl   -->   P    S
+				 *       \        /      \
+				 *        S      N        Sr
+				 *         \
+				 *          Sr
 				 */
 				tmp1 = tmp2->rb_right;
 				WRITE_ONCE(sibling->rb_left, tmp1);
@@ -365,7 +380,7 @@ ____rb_erase_color(struct rb_node *paren
 					}
 					break;
 				}
-				/* Case 3 - right rotate at sibling */
+				/* Case 3 - left rotate at sibling */
 				tmp1 = tmp2->rb_left;
 				WRITE_ONCE(sibling->rb_right, tmp1);
 				WRITE_ONCE(tmp2->rb_left, sibling);
@@ -377,7 +392,7 @@ ____rb_erase_color(struct rb_node *paren
 				tmp1 = sibling;
 				sibling = tmp2;
 			}
-			/* Case 4 - left rotate at parent + color flips */
+			/* Case 4 - right rotate at parent + color flips */
 			tmp2 = sibling->rb_right;
 			WRITE_ONCE(parent->rb_left, tmp2);
 			WRITE_ONCE(sibling->rb_right, parent);
_

Patches currently in -mm which might be from fykcee1@gmail.com are

lib-rbtreec-fix-typo-in-comment-of-____rb_erase_color.patch

