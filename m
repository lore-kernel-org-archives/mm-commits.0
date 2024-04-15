Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA200155A43
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 19:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713208352; cv=none; b=di/W5jYfxNTb7rIZ2PBm06vXfr/FodXvQ90pUm74hKa2uRAuBWjqf+pZwECFGy3MZ5tRVRNmNJ/iMqWMqXCOaGl1HRtVqh6KbTQF59yDUU3DZu15k1MVkE7+3QFKQEe4AVZmgpK2srf2EYAz4ubhgxvJ21Vdj1sqRug5cEAubDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713208352; c=relaxed/simple;
	bh=65YkFCt8Ec81rBi5gi3kzWkRleCRUXuzIIREJyrSdG4=;
	h=Date:To:From:Subject:Message-Id; b=VeM/vz4ewh5YUbTjPZmXwxw86KhNqyXjU4mETqxYBCT35Xj5d5TOrHF4ySuIz2PBgbcN5DtJnfB5l/996ijf8LcpmJnEJI9ZN3NhZ0/EA0+IOVkSOFOI0zrRP7J2OAXtjzFnoOYl37gmcG+KEUiqTVSSB0Q56gOXO5vtvpYcGcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NxNFDGOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NxNFDGOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598F6C113CC;
	Mon, 15 Apr 2024 19:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713208352;
	bh=65YkFCt8Ec81rBi5gi3kzWkRleCRUXuzIIREJyrSdG4=;
	h=Date:To:From:Subject:From;
	b=NxNFDGOIDpuWTnyetvS6YxRJcf7DlJ6YOFtbpBvvG9RhRig6UByeGo5J8zr9W4Aol
	 ufqzp59SEA5vE/vTFY69wkE2nfql2an6qXGWjy0nh1t0NrAP1sfHAgvbGk5DEsuo/D
	 AxairiYBQ5l4W+MoZKj5bZCD8K+wl/hQW5yB+6BE=
Date: Mon, 15 Apr 2024 12:12:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xarray-introduce-a-new-helper-xas_get_order.patch added to mm-unstable branch
Message-Id: <20240415191232.598F6C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/xarray: introduce a new helper xas_get_order
has been added to the -mm mm-unstable branch.  Its filename is
     lib-xarray-introduce-a-new-helper-xas_get_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xarray-introduce-a-new-helper-xas_get_order.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: lib/xarray: introduce a new helper xas_get_order
Date: Tue, 16 Apr 2024 01:18:55 +0800

It can be used after xas_load to check the order of loaded entries.
Compared to xa_get_order, it saves an XA_STATE and avoid a rewalk.

Also add new test for xas_get_order, to make the test work we have to
export xas_get_order with EXPORT_SYMBOL_GPL.

Link: https://lkml.kernel.org/r/20240415171857.19244-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |    6 ++++
 lib/test_xarray.c      |   34 +++++++++++++++++++++++++++
 lib/xarray.c           |   49 ++++++++++++++++++++++++---------------
 3 files changed, 71 insertions(+), 18 deletions(-)

--- a/include/linux/xarray.h~lib-xarray-introduce-a-new-helper-xas_get_order
+++ a/include/linux/xarray.h
@@ -1548,6 +1548,7 @@ void xas_create_range(struct xa_state *)
 
 #ifdef CONFIG_XARRAY_MULTI
 int xa_get_order(struct xarray *, unsigned long index);
+int xas_get_order(struct xa_state *xas);
 void xas_split(struct xa_state *, void *entry, unsigned int order);
 void xas_split_alloc(struct xa_state *, void *entry, unsigned int order, gfp_t);
 #else
@@ -1555,6 +1556,11 @@ static inline int xa_get_order(struct xa
 {
 	return 0;
 }
+
+static inline int xas_get_order(struct xa_state *xas)
+{
+	return 0;
+}
 
 static inline void xas_split(struct xa_state *xas, void *entry,
 		unsigned int order)
--- a/lib/test_xarray.c~lib-xarray-introduce-a-new-helper-xas_get_order
+++ a/lib/test_xarray.c
@@ -1984,6 +1984,39 @@ static noinline void check_get_order(str
 	}
 }
 
+static noinline void check_xas_get_order(struct xarray *xa)
+{
+	XA_STATE(xas, xa, 0);
+
+	unsigned int max_order = IS_ENABLED(CONFIG_XARRAY_MULTI) ? 20 : 1;
+	unsigned int order;
+	unsigned long i, j;
+
+	for (order = 0; order < max_order; order++) {
+		for (i = 0; i < 10; i++) {
+			xas_set_order(&xas, i << order, order);
+			do {
+				xas_lock(&xas);
+				xas_store(&xas, xa_mk_value(i));
+				xas_unlock(&xas);
+			} while (xas_nomem(&xas, GFP_KERNEL));
+
+			for (j = i << order; j < (i + 1) << order; j++) {
+				xas_set_order(&xas, j, 0);
+				rcu_read_lock();
+				xas_load(&xas);
+				XA_BUG_ON(xa, xas_get_order(&xas) != order);
+				rcu_read_unlock();
+			}
+
+			xas_lock(&xas);
+			xas_set_order(&xas, i << order, order);
+			xas_store(&xas, NULL);
+			xas_unlock(&xas);
+		}
+	}
+}
+
 static noinline void check_destroy(struct xarray *xa)
 {
 	unsigned long index;
@@ -2035,6 +2068,7 @@ static int xarray_checks(void)
 	check_multi_store(&array);
 	check_multi_store_advanced(&array);
 	check_get_order(&array);
+	check_xas_get_order(&array);
 	check_xa_alloc();
 	check_find(&array);
 	check_find_entry(&array);
--- a/lib/xarray.c~lib-xarray-introduce-a-new-helper-xas_get_order
+++ a/lib/xarray.c
@@ -1750,39 +1750,52 @@ unlock:
 EXPORT_SYMBOL(xa_store_range);
 
 /**
- * xa_get_order() - Get the order of an entry.
- * @xa: XArray.
- * @index: Index of the entry.
+ * xas_get_order() - Get the order of an loaded entry after xas_load.
+ * @xas: XArray operation state.
+ *
+ * Called after xas_load, the xas should not be in an error state.
  *
  * Return: A number between 0 and 63 indicating the order of the entry.
  */
-int xa_get_order(struct xarray *xa, unsigned long index)
+int xas_get_order(struct xa_state *xas)
 {
-	XA_STATE(xas, xa, index);
-	void *entry;
 	int order = 0;
 
-	rcu_read_lock();
-	entry = xas_load(&xas);
-
-	if (!entry)
-		goto unlock;
-
-	if (!xas.xa_node)
-		goto unlock;
+	if (!xas->xa_node)
+		return 0;
 
 	for (;;) {
-		unsigned int slot = xas.xa_offset + (1 << order);
+		unsigned int slot = xas->xa_offset + (1 << order);
 
 		if (slot >= XA_CHUNK_SIZE)
 			break;
-		if (!xa_is_sibling(xas.xa_node->slots[slot]))
+		if (!xa_is_sibling(xas->xa_node->slots[slot]))
 			break;
 		order++;
 	}
 
-	order += xas.xa_node->shift;
-unlock:
+	order += xas->xa_node->shift;
+	return order;
+}
+EXPORT_SYMBOL_GPL(xas_get_order);
+
+/**
+ * xa_get_order() - Get the order of an entry.
+ * @xa: XArray.
+ * @index: Index of the entry.
+ *
+ * Return: A number between 0 and 63 indicating the order of the entry.
+ */
+int xa_get_order(struct xarray *xa, unsigned long index)
+{
+	XA_STATE(xas, xa, index);
+	int order = 0;
+	void *entry;
+
+	rcu_read_lock();
+	entry = xas_load(&xas);
+	if (entry)
+		order = xas_get_order(&xas);
 	rcu_read_unlock();
 
 	return order;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-filemap-return-early-if-failed-to-allocate-memory-for-split.patch
mm-filemap-clean-up-hugetlb-exclusion-code.patch
lib-xarray-introduce-a-new-helper-xas_get_order.patch
mm-filemap-optimize-filemap-folio-adding.patch

