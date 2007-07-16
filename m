From: akpm@linux-foundation.org
Subject: - lib-add-idr_for_each.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:18 -0700
Message-ID: <200707162048.l6GKmIkd001029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554AbXGPUse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krh@redhat.com, airlied@linux.ie, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib: add idr_for_each()
has been removed from the -mm tree.  Its filename was
     lib-add-idr_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib: add idr_for_each()
From: Kristian Hoegsberg <krh@redhat.com>

This patch adds an iterator function for the idr data structure.  Compared
to just iterating through the idr with an integer and idr_find, this
iterator is (almost, but not quite) linear in the number of elements, as
opposed to the number of integers in the range covered by the idr.  This
makes a difference for sparse idrs, but more importantly, it's a nicer way
to iterate through the elements.

The drm subsystem is moving to idr for tracking contexts and drawables, and
with this change, we can use the idr exclusively for tracking these
resources.

[akpm@linux-foundation.org: fix comment]
Signed-off-by: Kristian Hoegsberg <krh@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    2 +
 lib/idr.c           |   55 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff -puN include/linux/idr.h~lib-add-idr_for_each include/linux/idr.h
--- a/include/linux/idr.h~lib-add-idr_for_each
+++ a/include/linux/idr.h
@@ -78,6 +78,8 @@ void *idr_find(struct idr *idp, int id);
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
 int idr_get_new(struct idr *idp, void *ptr, int *id);
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
+int idr_for_each(struct idr *idp,
+		 int (*fn)(int id, void *p, void *data), void *data);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
 void idr_destroy(struct idr *idp);
diff -puN lib/idr.c~lib-add-idr_for_each lib/idr.c
--- a/lib/idr.c~lib-add-idr_for_each
+++ a/lib/idr.c
@@ -437,6 +437,61 @@ void *idr_find(struct idr *idp, int id)
 EXPORT_SYMBOL(idr_find);
 
 /**
+ * idr_for_each - iterate through all stored pointers
+ * @idp: idr handle
+ * @fn: function to be called for each pointer
+ * @data: data passed back to callback function
+ *
+ * Iterate over the pointers registered with the given idr.  The
+ * callback function will be called for each pointer currently
+ * registered, passing the id, the pointer and the data pointer passed
+ * to this function.  It is not safe to modify the idr tree while in
+ * the callback, so functions such as idr_get_new and idr_remove are
+ * not allowed.
+ *
+ * We check the return of @fn each time. If it returns anything other
+ * than 0, we break out and return that value.
+ *
+ * The caller must serialize idr_for_each() vs idr_get_new() and idr_remove().
+ */
+int idr_for_each(struct idr *idp,
+		 int (*fn)(int id, void *p, void *data), void *data)
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
+	while (id < max) {
+		while (n > 0 && p) {
+			n -= IDR_BITS;
+			*paa++ = p;
+			p = p->ary[(id >> n) & IDR_MASK];
+		}
+
+		if (p) {
+			error = fn(id, (void *)p, data);
+			if (error)
+				break;
+		}
+
+		id += 1 << n;
+		while (n < fls(id)) {
+			n += IDR_BITS;
+			p = *--paa;
+		}
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(idr_for_each);
+
+/**
  * idr_replace - replace pointer for given id
  * @idp: idr handle
  * @ptr: pointer you want associated with the id
_

Patches currently in -mm which might be from krh@redhat.com are

origin.patch
git-ieee1394.patch
