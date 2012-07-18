From: akpm@linux-foundation.org
Subject: + rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch added to -mm tree
Date: Wed, 18 Jul 2012 14:03:08 -0700
Message-ID: <20120718210308.989E11E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:55840 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2GRVDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jul 2012 17:03:10 -0400
Received: by ggeh3 with SMTP id h3so217822gge.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jul 2012 14:03:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org, David.Woodhouse@intel.com


The patch titled
     Subject: rbtree: fix jffs2 build issue due to renamed __rb_parent_=
color field
has been added to the -mm tree.  Its filename is
     rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fi=
x.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: David Woodhouse <dwmw2@infradead.org>
Subject: rbtree: fix jffs2 build issue due to renamed __rb_parent_color=
 field

=2E.. and clean up the comments to better explain why it's acceptable t=
o
do it this way instead of using rb_erase() "properly".

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
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
Subject: Subject: rbtree: fix jffs2 build issue due to renamed __rb_par=
ent_color field

Patches currently in -mm which might be from dwmw2@infradead.org are

linux-next.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.pat=
ch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
