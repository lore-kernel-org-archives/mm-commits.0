From: akpm@linux-foundation.org
Subject: [folded-dropped] rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:05:48 -0700
Message-ID: <20121008230549.4335120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60549 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab2JHXFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:05:51 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so295144wey.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:05:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, David.Woodhouse@intel.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: fix jffs2 build issue due to renamed __rb_parent_=
color field
has been removed from the -mm tree.  Its filename was
     rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fi=
x.patch

This patch was dropped because it was folded into rbtree-move-some-impl=
ementation-details-from-rbtreeh-to-rbtreec.patch

------------------------------------------------------
=46rom: David Woodhouse <dwmw2@infradead.org>
Subject: rbtree: fix jffs2 build issue due to renamed __rb_parent_color=
 field

=2E.. and clean up the comments to better explain why it's acceptable t=
o
do it this way instead of using rb_erase() "properly".

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/readinode.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/jffs2/readinode.c~rbtree-move-some-implementation-details-=
from-rbtreeh-to-rbtreec-fix fs/jffs2/readinode.c
--- a/fs/jffs2/readinode.c~rbtree-move-some-implementation-details-from=
-rbtreeh-to-rbtreec-fix
+++ a/fs/jffs2/readinode.c
@@ -394,8 +394,11 @@ static int jffs2_add_tn_to_tree(struct j
 }
=20
 /* Trivial function to remove the last node in the tree. Which by defi=
nition
-   has no right-hand -- so can be removed just by making its only chil=
d (if
-   any) take its place under its parent. */
+   has no right-hand child =E2=80=94 so can be removed just by making =
its left-hand
+   child (if any) take its place under its parent. Since this is only =
done
+   when we're consuming the whole tree, there's no need to use rb_eras=
e()
+   and let it worry about adjusting colours and balancing the tree. Th=
at
+   would just be a waste of time. */
 static void eat_last(struct rb_root *root, struct rb_node *node)
 {
 	struct rb_node *parent =3D rb_parent(node);
@@ -412,12 +415,12 @@ static void eat_last(struct rb_root *roo
 		link =3D &parent->rb_right;
=20
 	*link =3D node->rb_left;
-	/* Colour doesn't matter now. Only the parent pointer. */
 	if (node->rb_left)
-		node->rb_left->rb_parent_color =3D node->rb_parent_color;
+		node->rb_left->__rb_parent_color =3D node->__rb_parent_color;
 }
=20
-/* We put this in reverse order, so we can just use eat_last */
+/* We put the version tree in reverse order, so we can use the same ea=
t_last()
+   function that we use to consume the tmpnode tree (tn_root). */
 static void ver_insert(struct rb_root *ver_root, struct jffs2_tmp_dnod=
e_info *tn)
 {
 	struct rb_node **link =3D &ver_root->rb_node;
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.=
patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
