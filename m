From: akpm@linux-foundation.org
Subject: [alternative-merged] sort-introduce-generic-list_sort-function.patch removed from -mm tree
Date: Wed, 13 Jan 2010 11:28:12 -0800
Message-ID: <201001131928.o0DJSCkk023799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab0AMT25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 14:28:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fromorbit.com, airlied@redhat.com, dedekind@infradead.org, mm-commits@vger.kernel.org


The patch titled
     sort: introduce generic list_sort function
has been removed from the -mm tree.  Its filename was
     sort-introduce-generic-list_sort-function.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: sort: introduce generic list_sort function
=46rom: Dave Chinner <david@fromorbit.com>

There are two copies of list_sort() in the tree already, one in the DRM
code, another in ubifs.  Now XFS needs this as well.  Create a generic
list_sort() function from the ubifs version and convert existing users =
to
it so we don't end up with yet another copy in the tree.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Acked-by: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_modes.c |   90 +------------------------------
 fs/ubifs/gc.c               |   95 ---------------------------------
 include/linux/sort.h        |    5 +
 lib/sort.c                  |   97 ++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 181 deletions(-)

diff -puN drivers/gpu/drm/drm_modes.c~sort-introduce-generic-list_sort-=
function drivers/gpu/drm/drm_modes.c
--- a/drivers/gpu/drm/drm_modes.c~sort-introduce-generic-list_sort-func=
tion
+++ a/drivers/gpu/drm/drm_modes.c
@@ -1,9 +1,4 @@
 /*
- * The list_sort function is (presumably) licensed under the GPL (see =
the
- * top level "COPYING" file for details).
- *
- * The remainder of this file is:
- *
  * Copyright =C2=A9 1997-2003 by The XFree86 Project, Inc.
  * Copyright =C2=A9 2007 Dave Airlie
  * Copyright =C2=A9 2007-2008 Intel Corporation
@@ -36,6 +31,7 @@
  */
=20
 #include <linux/list.h>
+#include <linux/sort.h>
 #include "drmP.h"
 #include "drm.h"
 #include "drm_crtc.h"
@@ -855,6 +851,7 @@ EXPORT_SYMBOL(drm_mode_prune_invalid);
=20
 /**
  * drm_mode_compare - compare modes for favorability
+ * @priv: unused
  * @lh_a: list_head for first mode
  * @lh_b: list_head for second mode
  *
@@ -868,7 +865,7 @@ EXPORT_SYMBOL(drm_mode_prune_invalid);
  * Negative if @lh_a is better than @lh_b, zero if they're equivalent,=
 or
  * positive if @lh_b is better than @lh_a.
  */
-static int drm_mode_compare(struct list_head *lh_a, struct list_head *=
lh_b)
+static int drm_mode_compare(void *priv, struct list_head *lh_a, struct=
 list_head *lh_b)
 {
 	struct drm_display_mode *a =3D list_entry(lh_a, struct drm_display_mo=
de, head);
 	struct drm_display_mode *b =3D list_entry(lh_b, struct drm_display_mo=
de, head);
@@ -885,85 +882,6 @@ static int drm_mode_compare(struct list_
 	return diff;
 }
=20
-/* FIXME: what we don't have a list sort function? */
-/* list sort from Mark J Roberts (mjr@znex.org) */
-void list_sort(struct list_head *head,
-	       int (*cmp)(struct list_head *a, struct list_head *b))
-{
-	struct list_head *p, *q, *e, *list, *tail, *oldhead;
-	int insize, nmerges, psize, qsize, i;
-
-	list =3D head->next;
-	list_del(head);
-	insize =3D 1;
-	for (;;) {
-		p =3D oldhead =3D list;
-		list =3D tail =3D NULL;
-		nmerges =3D 0;
-
-		while (p) {
-			nmerges++;
-			q =3D p;
-			psize =3D 0;
-			for (i =3D 0; i < insize; i++) {
-				psize++;
-				q =3D q->next =3D=3D oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
-
-			qsize =3D insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e =3D q;
-					q =3D q->next;
-					qsize--;
-					if (q =3D=3D oldhead)
-						q =3D NULL;
-				} else if (!qsize || !q) {
-					e =3D p;
-					p =3D p->next;
-					psize--;
-					if (p =3D=3D oldhead)
-						p =3D NULL;
-				} else if (cmp(p, q) <=3D 0) {
-					e =3D p;
-					p =3D p->next;
-					psize--;
-					if (p =3D=3D oldhead)
-						p =3D NULL;
-				} else {
-					e =3D q;
-					q =3D q->next;
-					qsize--;
-					if (q =3D=3D oldhead)
-						q =3D NULL;
-				}
-				if (tail)
-					tail->next =3D e;
-				else
-					list =3D e;
-				e->prev =3D tail;
-				tail =3D e;
-			}
-			p =3D q;
-		}
-
-		tail->next =3D list;
-		list->prev =3D tail;
-
-		if (nmerges <=3D 1)
-			break;
-
-		insize *=3D 2;
-	}
-
-	head->next =3D list;
-	head->prev =3D list->prev;
-	list->prev->next =3D head;
-	list->prev =3D head;
-}
-
 /**
  * drm_mode_sort - sort mode list
  * @mode_list: list to sort
@@ -975,7 +893,7 @@ void list_sort(struct list_head *head,
  */
 void drm_mode_sort(struct list_head *mode_list)
 {
-	list_sort(mode_list, drm_mode_compare);
+	list_sort(NULL, mode_list, drm_mode_compare);
 }
 EXPORT_SYMBOL(drm_mode_sort);
=20
diff -puN fs/ubifs/gc.c~sort-introduce-generic-list_sort-function fs/ub=
ifs/gc.c
--- a/fs/ubifs/gc.c~sort-introduce-generic-list_sort-function
+++ a/fs/ubifs/gc.c
@@ -108,101 +108,6 @@ static int switch_gc_head(struct ubifs_i
 }
=20
 /**
- * list_sort - sort a list.
- * @priv: private data, passed to @cmp
- * @head: the list to sort
- * @cmp: the elements comparison function
- *
- * This function has been implemented by Mark J Roberts <mjr@znex.org>=
=2E It
- * implements "merge sort" which has O(nlog(n)) complexity. The list i=
s sorted
- * in ascending order.
- *
- * The comparison function @cmp is supposed to return a negative value=
 if @a is
- * than @b, and a positive value if @a is greater than @b. If @a and @=
b are
- * equivalent, then it does not matter what this function returns.
- */
-static void list_sort(void *priv, struct list_head *head,
-		      int (*cmp)(void *priv, struct list_head *a,
-				 struct list_head *b))
-{
-	struct list_head *p, *q, *e, *list, *tail, *oldhead;
-	int insize, nmerges, psize, qsize, i;
-
-	if (list_empty(head))
-		return;
-
-	list =3D head->next;
-	list_del(head);
-	insize =3D 1;
-	for (;;) {
-		p =3D oldhead =3D list;
-		list =3D tail =3D NULL;
-		nmerges =3D 0;
-
-		while (p) {
-			nmerges++;
-			q =3D p;
-			psize =3D 0;
-			for (i =3D 0; i < insize; i++) {
-				psize++;
-				q =3D q->next =3D=3D oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
-
-			qsize =3D insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e =3D q;
-					q =3D q->next;
-					qsize--;
-					if (q =3D=3D oldhead)
-						q =3D NULL;
-				} else if (!qsize || !q) {
-					e =3D p;
-					p =3D p->next;
-					psize--;
-					if (p =3D=3D oldhead)
-						p =3D NULL;
-				} else if (cmp(priv, p, q) <=3D 0) {
-					e =3D p;
-					p =3D p->next;
-					psize--;
-					if (p =3D=3D oldhead)
-						p =3D NULL;
-				} else {
-					e =3D q;
-					q =3D q->next;
-					qsize--;
-					if (q =3D=3D oldhead)
-						q =3D NULL;
-				}
-				if (tail)
-					tail->next =3D e;
-				else
-					list =3D e;
-				e->prev =3D tail;
-				tail =3D e;
-			}
-			p =3D q;
-		}
-
-		tail->next =3D list;
-		list->prev =3D tail;
-
-		if (nmerges <=3D 1)
-			break;
-
-		insize *=3D 2;
-	}
-
-	head->next =3D list;
-	head->prev =3D list->prev;
-	list->prev->next =3D head;
-	list->prev =3D head;
-}
-
-/**
  * data_nodes_cmp - compare 2 data nodes.
  * @priv: UBIFS file-system description object
  * @a: first data node
diff -puN include/linux/sort.h~sort-introduce-generic-list_sort-functio=
n include/linux/sort.h
--- a/include/linux/sort.h~sort-introduce-generic-list_sort-function
+++ a/include/linux/sort.h
@@ -3,8 +3,13 @@
=20
 #include <linux/types.h>
=20
+struct list_head;
+
 void sort(void *base, size_t num, size_t size,
 	  int (*cmp)(const void *, const void *),
 	  void (*swap)(void *, void *, int));
=20
+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b));
 #endif
diff -puN lib/sort.c~sort-introduce-generic-list_sort-function lib/sort=
=2Ec
--- a/lib/sort.c~sort-introduce-generic-list_sort-function
+++ a/lib/sort.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
+#include <linux/list.h>
=20
 static void u32_swap(void *a, void *b, int size)
 {
@@ -121,3 +122,99 @@ static int sort_test(void)
=20
 module_init(sort_test);
 #endif
+
+/**
+ * list_sort - sort a list.
+ * @priv: private data, passed to @cmp
+ * @head: the list to sort
+ * @cmp: the elements comparison function
+ *
+ * This function has been implemented by Mark J Roberts <mjr@znex.org>=
=2E It
+ * implements "merge sort" which has O(nlog(n)) complexity. The list i=
s sorted
+ * in ascending order.
+ *
+ * The comparison function @cmp is supposed to return a negative value=
 if @a is
+ * less than @b, and a positive value if @a is greater than @b. If @a =
and @b
+ * are equivalent, then it does not matter what this function returns.
+ */
+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b))
+{
+	struct list_head *p, *q, *e, *list, *tail, *oldhead;
+	int insize, nmerges, psize, qsize, i;
+
+	if (list_empty(head))
+		return;
+
+	list =3D head->next;
+	list_del(head);
+	insize =3D 1;
+	for (;;) {
+		p =3D oldhead =3D list;
+		list =3D tail =3D NULL;
+		nmerges =3D 0;
+
+		while (p) {
+			nmerges++;
+			q =3D p;
+			psize =3D 0;
+			for (i =3D 0; i < insize; i++) {
+				psize++;
+				q =3D q->next =3D=3D oldhead ? NULL : q->next;
+				if (!q)
+					break;
+			}
+
+			qsize =3D insize;
+			while (psize > 0 || (qsize > 0 && q)) {
+				if (!psize) {
+					e =3D q;
+					q =3D q->next;
+					qsize--;
+					if (q =3D=3D oldhead)
+						q =3D NULL;
+				} else if (!qsize || !q) {
+					e =3D p;
+					p =3D p->next;
+					psize--;
+					if (p =3D=3D oldhead)
+						p =3D NULL;
+				} else if (cmp(priv, p, q) <=3D 0) {
+					e =3D p;
+					p =3D p->next;
+					psize--;
+					if (p =3D=3D oldhead)
+						p =3D NULL;
+				} else {
+					e =3D q;
+					q =3D q->next;
+					qsize--;
+					if (q =3D=3D oldhead)
+						q =3D NULL;
+				}
+				if (tail)
+					tail->next =3D e;
+				else
+					list =3D e;
+				e->prev =3D tail;
+				tail =3D e;
+			}
+			p =3D q;
+		}
+
+		tail->next =3D list;
+		list->prev =3D tail;
+
+		if (nmerges <=3D 1)
+			break;
+
+		insize *=3D 2;
+	}
+
+	head->next =3D list;
+	head->prev =3D list->prev;
+	list->prev->next =3D head;
+	list->prev =3D head;
+}
+
_

Patches currently in -mm which might be from david@fromorbit.com are

linux-next.patch
sort-introduce-generic-list_sort-function.patch
sort-introduce-generic-list_sort-function-v3.patch
sort-introduce-generic-list_sort-function-v3-checkpatch-fixes.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
