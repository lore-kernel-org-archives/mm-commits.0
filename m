From: akpm@linux-foundation.org
Subject: [merged] ida-simplified-functions-for-id-allocation.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:50:33 -0700
Message-ID: <201108161847.p7GIlehh015119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231Ab1HPSyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, jic23@cam.ac.uk, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ida: simplified functions for id allocation
has been removed from the -mm tree.  Its filename was
     ida-simplified-functions-for-id-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ida: simplified functions for id allocation
From: Rusty Russell <rusty@rustcorp.com.au>

The current hyper-optimized functions are overkill if you simply want to
allocate an id for a device.  Create versions which use an internal lock.

In followup patches, numerous drivers are converted to use this interface.

Thanks to Tejun for feedback.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    4 ++
 lib/idr.c           |   67 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff -puN include/linux/idr.h~ida-simplified-functions-for-id-allocation include/linux/idr.h
--- a/include/linux/idr.h~ida-simplified-functions-for-id-allocation
+++ a/include/linux/idr.h
@@ -146,6 +146,10 @@ void ida_remove(struct ida *ida, int id)
 void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
+int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+		   gfp_t gfp_mask);
+void ida_simple_remove(struct ida *ida, unsigned int id);
+
 void __init idr_init_cache(void);
 
 #endif /* __IDR_H__ */
diff -puN lib/idr.c~ida-simplified-functions-for-id-allocation lib/idr.c
--- a/lib/idr.c~ida-simplified-functions-for-id-allocation
+++ a/lib/idr.c
@@ -34,8 +34,10 @@
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/idr.h>
+#include <linux/spinlock.h>
 
 static struct kmem_cache *idr_layer_cache;
+static DEFINE_SPINLOCK(simple_ida_lock);
 
 static struct idr_layer *get_from_free_list(struct idr *idp)
 {
@@ -926,6 +928,71 @@ void ida_destroy(struct ida *ida)
 EXPORT_SYMBOL(ida_destroy);
 
 /**
+ * ida_simple_get - get a new id.
+ * @ida: the (initialized) ida.
+ * @start: the minimum id (inclusive, < 0x8000000)
+ * @end: the maximum id (exclusive, < 0x8000000 or 0)
+ * @gfp_mask: memory allocation flags
+ *
+ * Allocates an id in the range start <= id < end, or returns -ENOSPC.
+ * On memory allocation failure, returns -ENOMEM.
+ *
+ * Use ida_simple_remove() to get rid of an id.
+ */
+int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+		   gfp_t gfp_mask)
+{
+	int ret, id;
+	unsigned int max;
+
+	BUG_ON((int)start < 0);
+	BUG_ON((int)end < 0);
+
+	if (end == 0)
+		max = 0x80000000;
+	else {
+		BUG_ON(end < start);
+		max = end - 1;
+	}
+
+again:
+	if (!ida_pre_get(ida, gfp_mask))
+		return -ENOMEM;
+
+	spin_lock(&simple_ida_lock);
+	ret = ida_get_new_above(ida, start, &id);
+	if (!ret) {
+		if (id > max) {
+			ida_remove(ida, id);
+			ret = -ENOSPC;
+		} else {
+			ret = id;
+		}
+	}
+	spin_unlock(&simple_ida_lock);
+
+	if (unlikely(ret == -EAGAIN))
+		goto again;
+
+	return ret;
+}
+EXPORT_SYMBOL(ida_simple_get);
+
+/**
+ * ida_simple_remove - remove an allocated id.
+ * @ida: the (initialized) ida.
+ * @id: the id returned by ida_simple_get.
+ */
+void ida_simple_remove(struct ida *ida, unsigned int id)
+{
+	BUG_ON((int)id < 0);
+	spin_lock(&simple_ida_lock);
+	ida_remove(ida, id);
+	spin_unlock(&simple_ida_lock);
+}
+EXPORT_SYMBOL(ida_simple_remove);
+
+/**
  * ida_init - initialize ida handle
  * @ida:	ida handle
  *
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
linux-next.patch
drm-vmwgfx-use-ida_simple_get-for-id-allocation.patch
hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch
drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch
drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch

