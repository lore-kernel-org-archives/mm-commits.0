From: akpm@linux-foundation.org
Subject: + devres-add-kernel-standard-devm_kalloc-functions.patch added to -mm tree
Date: Fri, 11 Oct 2013 13:11:48 -0700
Message-ID: <52585b84.TjlMPe1EfqjTyv9j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab3JKULt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Oct 2013 16:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, sangjung.woo@samsung.com, gregkh@linuxfoundation.org, joe@perches.com

Subject: + devres-add-kernel-standard-devm_kalloc-functions.patch added to -mm tree
To: joe@perches.com,gregkh@linuxfoundation.org,sangjung.woo@samsung.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 11 Oct 2013 13:11:48 -0700


The patch titled
     Subject: devres: add kernel standard devm_k.alloc functions
has been added to the -mm tree.  Its filename is
     devres-add-kernel-standard-devm_kalloc-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/devres-add-kernel-standard-devm_kalloc-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/devres-add-kernel-standard-devm_kalloc-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: devres: add kernel standard devm_k.alloc functions

Currently, devm_ managed memory only supports kzalloc.

Convert the devm_kzalloc implementation to devm_kmalloc and remove the
complete memset to 0 but still set the initial struct devres header and
whatever padding before data to 0.

Add the other normal alloc variants as static inlines with __GFP_ZERO
added to the gfp flag where appropriate:

	devm_kzalloc
	devm_kcalloc
	devm_kmalloc_array

Add gfp.h to device.h for the newly added static inlines.

akpm: the current API forces us to replace kmalloc() with kzalloc() when
performing devm_ conversions.  This adds a relatively minor overhead. 
More significantly, it will defeat kmemcheck used-uninitialized checking,
and for a particular driver, losing used-uninitialised checking for their
core controlling data structures will significantly degrade kmemcheck
usefulness.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Sangjung Woo <sangjung.woo@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/devres.c  |   27 ++++++++++++++++-----------
 include/linux/device.h |   21 +++++++++++++++++++--
 2 files changed, 35 insertions(+), 13 deletions(-)

diff -puN drivers/base/devres.c~devres-add-kernel-standard-devm_kalloc-functions drivers/base/devres.c
--- a/drivers/base/devres.c~devres-add-kernel-standard-devm_kalloc-functions
+++ a/drivers/base/devres.c
@@ -91,7 +91,8 @@ static __always_inline struct devres * a
 	if (unlikely(!dr))
 		return NULL;
 
-	memset(dr, 0, tot_size);
+	memset(dr, 0, offsetof(struct devres, data));
+
 	INIT_LIST_HEAD(&dr->node.entry);
 	dr->node.release = release;
 	return dr;
@@ -745,58 +746,62 @@ void devm_remove_action(struct device *d
 EXPORT_SYMBOL_GPL(devm_remove_action);
 
 /*
- * Managed kzalloc/kfree
+ * Managed kmalloc/kfree
  */
-static void devm_kzalloc_release(struct device *dev, void *res)
+static void devm_kmalloc_release(struct device *dev, void *res)
 {
 	/* noop */
 }
 
-static int devm_kzalloc_match(struct device *dev, void *res, void *data)
+static int devm_kmalloc_match(struct device *dev, void *res, void *data)
 {
 	return res == data;
 }
 
 /**
- * devm_kzalloc - Resource-managed kzalloc
+ * devm_kmalloc - Resource-managed kmalloc
  * @dev: Device to allocate memory for
  * @size: Allocation size
  * @gfp: Allocation gfp flags
  *
- * Managed kzalloc.  Memory allocated with this function is
+ * Managed kmalloc.  Memory allocated with this function is
  * automatically freed on driver detach.  Like all other devres
  * resources, guaranteed alignment is unsigned long long.
  *
  * RETURNS:
  * Pointer to allocated memory on success, NULL on failure.
  */
-void * devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
+void * devm_kmalloc(struct device *dev, size_t size, gfp_t gfp)
 {
 	struct devres *dr;
 
 	/* use raw alloc_dr for kmalloc caller tracing */
-	dr = alloc_dr(devm_kzalloc_release, size, gfp);
+	dr = alloc_dr(devm_kmalloc_release, size, gfp);
 	if (unlikely(!dr))
 		return NULL;
 
+	/*
+	 * This is named devm_kzalloc_release for historical reasons
+	 * The initial implementation did not support kmalloc, only kzalloc
+	 */
 	set_node_dbginfo(&dr->node, "devm_kzalloc_release", size);
 	devres_add(dev, dr->data);
 	return dr->data;
 }
-EXPORT_SYMBOL_GPL(devm_kzalloc);
+EXPORT_SYMBOL_GPL(devm_kmalloc);
 
 /**
  * devm_kfree - Resource-managed kfree
  * @dev: Device this memory belongs to
  * @p: Memory to free
  *
- * Free memory allocated with devm_kzalloc().
+ * Free memory allocated with devm_kmalloc().
  */
 void devm_kfree(struct device *dev, void *p)
 {
 	int rc;
 
-	rc = devres_destroy(dev, devm_kzalloc_release, devm_kzalloc_match, p);
+	rc = devres_destroy(dev, devm_kmalloc_release, devm_kmalloc_match, p);
 	WARN_ON(rc);
 }
 EXPORT_SYMBOL_GPL(devm_kfree);
diff -puN include/linux/device.h~devres-add-kernel-standard-devm_kalloc-functions include/linux/device.h
--- a/include/linux/device.h~devres-add-kernel-standard-devm_kalloc-functions
+++ a/include/linux/device.h
@@ -26,6 +26,7 @@
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
 #include <linux/uidgid.h>
+#include <linux/gfp.h>
 #include <asm/device.h>
 
 struct device;
@@ -602,8 +603,24 @@ extern void devres_close_group(struct de
 extern void devres_remove_group(struct device *dev, void *id);
 extern int devres_release_group(struct device *dev, void *id);
 
-/* managed kzalloc/kfree for device drivers, no kmalloc, always use kzalloc */
-extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
+/* managed devm_k.alloc/kfree for device drivers */
+extern void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp);
+static inline void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
+{
+	return devm_kmalloc(dev, size, gfp | __GFP_ZERO);
+}
+static inline void *devm_kmalloc_array(struct device *dev,
+				       size_t n, size_t size, gfp_t flags)
+{
+	if (size != 0 && n > SIZE_MAX / size)
+		return NULL;
+	return devm_kmalloc(dev, n * size, flags);
+}
+static inline void *devm_kcalloc(struct device *dev,
+				 size_t n, size_t size, gfp_t flags)
+{
+	return devm_kmalloc_array(dev, n, size, flags | __GFP_ZERO);
+}
 extern void devm_kfree(struct device *dev, void *p);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
_

Patches currently in -mm which might be from joe@perches.com are

devres-add-kernel-standard-devm_kalloc-functions.patch
drivers-base-devresc-add-devm_kmalloc.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
printk-mark-printk_once-test-variable-__read_mostly.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
checkpatch-add-check-for-sscanf-without-return-use-v2.patch
drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch

