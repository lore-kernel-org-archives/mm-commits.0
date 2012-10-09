From: akpm@linux-foundation.org
Subject: [merged] rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:07 -0700
Message-ID: <20121009180908.570255C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37938 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab2JISJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:12 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so363172eek.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: move some implementation details from rbtree.h to=
 rbtree.c
has been removed from the -mm tree.  Its filename was
     rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.pa=
tch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Michel Lespinasse <walken@google.com>
Subject: rbtree: move some implementation details from rbtree.h to rbtr=
ee.c

rbtree users must use the documented APIs to manipulate the tree
structure.  Low-level helpers to manipulate node colors and parenthood =
are
not part of that API, so move them to lib/rbtree.c

[dwmw2@infradead.org: fix jffs2 build issue due to renamed __rb_parent_=
color field]
Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/readinode.c   |   13 ++++++++-----
 include/linux/rbtree.h |   34 +++++++++-------------------------
 lib/rbtree.c           |   20 +++++++++++++++++++-
 3 files changed, 36 insertions(+), 31 deletions(-)

diff -puN fs/jffs2/readinode.c~rbtree-move-some-implementation-details-=
from-rbtreeh-to-rbtreec fs/jffs2/readinode.c
--- a/fs/jffs2/readinode.c~rbtree-move-some-implementation-details-from=
-rbtreeh-to-rbtreec
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
diff -puN include/linux/rbtree.h~rbtree-move-some-implementation-detail=
s-from-rbtreeh-to-rbtreec include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-move-some-implementation-details-fr=
om-rbtreeh-to-rbtreec
+++ a/include/linux/rbtree.h
@@ -32,37 +32,19 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
=20
-struct rb_node
-{
-	unsigned long  rb_parent_color;
-#define	RB_RED		0
-#define	RB_BLACK	1
+struct rb_node {
+	unsigned long  __rb_parent_color;
 	struct rb_node *rb_right;
 	struct rb_node *rb_left;
 } __attribute__((aligned(sizeof(long))));
     /* The alignment might seem pointless, but allegedly CRIS needs it=
 */
=20
-struct rb_root
-{
+struct rb_root {
 	struct rb_node *rb_node;
 };
=20
=20
-#define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
-#define rb_color(r)   ((r)->rb_parent_color & 1)
-#define rb_is_red(r)   (!rb_color(r))
-#define rb_is_black(r) rb_color(r)
-#define rb_set_red(r)  do { (r)->rb_parent_color &=3D ~1; } while (0)
-#define rb_set_black(r)  do { (r)->rb_parent_color |=3D 1; } while (0)
-
-static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p=
)
-{
-	rb->rb_parent_color =3D (rb->rb_parent_color & 3) | (unsigned long)p;
-}
-static inline void rb_set_color(struct rb_node *rb, int color)
-{
-	rb->rb_parent_color =3D (rb->rb_parent_color & ~1) | color;
-}
+#define rb_parent(r)   ((struct rb_node *)((r)->__rb_parent_color & ~3=
))
=20
 #define RB_ROOT	(struct rb_root) { NULL, }
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
@@ -70,8 +52,10 @@ static inline void rb_set_color(struct r
 #define RB_EMPTY_ROOT(root)  ((root)->rb_node =3D=3D NULL)
=20
 /* 'empty' nodes are nodes that are known not to be inserted in an rbr=
ee */
-#define RB_EMPTY_NODE(node)  ((node)->rb_parent_color =3D=3D (unsigned=
 long)(node))
-#define RB_CLEAR_NODE(node)  ((node)->rb_parent_color =3D (unsigned lo=
ng)(node))
+#define RB_EMPTY_NODE(node)  \
+	((node)->__rb_parent_color =3D=3D (unsigned long)(node))
+#define RB_CLEAR_NODE(node)  \
+	((node)->__rb_parent_color =3D (unsigned long)(node))
=20
=20
 extern void rb_insert_color(struct rb_node *, struct rb_root *);
@@ -98,7 +82,7 @@ extern void rb_replace_node(struct rb_no
 static inline void rb_link_node(struct rb_node * node, struct rb_node =
* parent,
 				struct rb_node ** rb_link)
 {
-	node->rb_parent_color =3D (unsigned long )parent;
+	node->__rb_parent_color =3D (unsigned long)parent;
 	node->rb_left =3D node->rb_right =3D NULL;
=20
 	*rb_link =3D node;
diff -puN lib/rbtree.c~rbtree-move-some-implementation-details-from-rbt=
reeh-to-rbtreec lib/rbtree.c
--- a/lib/rbtree.c~rbtree-move-some-implementation-details-from-rbtreeh=
-to-rbtreec
+++ a/lib/rbtree.c
@@ -23,6 +23,24 @@
 #include <linux/rbtree.h>
 #include <linux/export.h>
=20
+#define	RB_RED		0
+#define	RB_BLACK	1
+
+#define rb_color(r)   ((r)->__rb_parent_color & 1)
+#define rb_is_red(r)   (!rb_color(r))
+#define rb_is_black(r) rb_color(r)
+#define rb_set_red(r)  do { (r)->__rb_parent_color &=3D ~1; } while (0=
)
+#define rb_set_black(r)  do { (r)->__rb_parent_color |=3D 1; } while (=
0)
+
+static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p=
)
+{
+	rb->__rb_parent_color =3D rb_color(rb) | (unsigned long)p;
+}
+static inline void rb_set_color(struct rb_node *rb, int color)
+{
+	rb->__rb_parent_color =3D (rb->__rb_parent_color & ~1) | color;
+}
+
 static void __rb_rotate_left(struct rb_node *node, struct rb_root *roo=
t)
 {
 	struct rb_node *right =3D node->rb_right;
@@ -255,7 +273,7 @@ void rb_erase(struct rb_node *node, stru
 			rb_set_parent(old->rb_right, node);
 		}
=20
-		node->rb_parent_color =3D old->rb_parent_color;
+		node->__rb_parent_color =3D old->__rb_parent_color;
 		node->rb_left =3D old->rb_left;
 		rb_set_parent(old->rb_left, node);
=20
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
