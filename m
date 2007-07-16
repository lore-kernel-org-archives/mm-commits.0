From: akpm@linux-foundation.org
Subject: - lib-add-idr_remove_all.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:21 -0700
Message-ID: <200707162048.l6GKmLG1001032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46508 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756974AbXGPUsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krh@redhat.com, airlied@linux.ie, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib: add idr_remove_all
has been removed from the -mm tree.  Its filename was
     lib-add-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib: add idr_remove_all
From: Kristian Hoegsberg <krh@redhat.com>

Remove all ids from the given idr tree.  idr_destroy() only frees up
unused, cached idp_layers, but this function will remove all id mappings
and leave all idp_layers unused.

A typical clean-up sequence for objects stored in an idr tree, will use
idr_for_each() to free all objects, if necessay, then idr_remove_all() to
remove all ids, and idr_destroy() to free up the cached idr_layers.

Signed-off-by: Kristian Hoegsberg <krh@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    1 
 lib/idr.c           |   47 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff -puN include/linux/idr.h~lib-add-idr_remove_all include/linux/idr.h
--- a/include/linux/idr.h~lib-add-idr_remove_all
+++ a/include/linux/idr.h
@@ -82,6 +82,7 @@ int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
+void idr_remove_all(struct idr *idp);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
diff -puN lib/idr.c~lib-add-idr_remove_all lib/idr.c
--- a/lib/idr.c~lib-add-idr_remove_all
+++ a/lib/idr.c
@@ -391,6 +391,53 @@ void idr_remove(struct idr *idp, int id)
 EXPORT_SYMBOL(idr_remove);
 
 /**
+ * idr_remove_all - remove all ids from the given idr tree
+ * @idp: idr handle
+ *
+ * idr_destroy() only frees up unused, cached idp_layers, but this
+ * function will remove all id mappings and leave all idp_layers
+ * unused.
+ *
+ * A typical clean-up sequence for objects stored in an idr tree, will
+ * use idr_for_each() to free all objects, if necessay, then
+ * idr_remove_all() to remove all ids, and idr_destroy() to free
+ * up the cached idr_layers.
+ */
+void idr_remove_all(struct idr *idp)
+{
+	int n, id, max, error = 0;
+	struct idr_layer *p;
+	struct idr_layer *pa[MAX_LEVEL];
+	struct idr_layer **paa = &pa[0];
+
+	n = idp->layers * IDR_BITS;
+	p = idp->top;
+	max = 1 << n;
+
+	id = 0;
+	while (id < max && !error) {
+		while (n > IDR_BITS && p) {
+			n -= IDR_BITS;
+			*paa++ = p;
+			p = p->ary[(id >> n) & IDR_MASK];
+		}
+
+		id += 1 << n;
+		while (n < fls(id)) {
+			if (p) {
+				memset(p, 0, sizeof *p);
+				free_layer(idp, p);
+			}
+			n += IDR_BITS;
+			p = *--paa;
+		}
+	}
+	idp->top = NULL;
+	idp->layers = 0;
+}
+EXPORT_SYMBOL(idr_remove_all);
+
+/**
  * idr_destroy - release all cached layers within an idr tree
  * idp: idr handle
  */
_

Patches currently in -mm which might be from krh@redhat.com are

origin.patch
git-ieee1394.patch
