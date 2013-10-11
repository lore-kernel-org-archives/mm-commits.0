From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-base-devresc-add-devm_kmalloc.patch
 removed from -mm tree
Date: Fri, 11 Oct 2013 13:27:28 -0700
Message-ID: <52585f30.Z6/3eXD9d1x2nPrb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab3JKU13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Oct 2013 16:27:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, joe@perches.com, greg@kroah.com, akpm@linux-foundation.org

Subject: [alternative-merged] drivers-base-devresc-add-devm_kmalloc.patch removed from -mm tree
To: akpm@linux-foundation.org,greg@kroah.com,joe@perches.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 11 Oct 2013 13:27:28 -0700


The patch titled
     Subject: drivers/base/devres.c: add devm_kmalloc()
has been removed from the -mm tree.  Its filename was
     drivers-base-devresc-add-devm_kmalloc.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/base/devres.c: add devm_kmalloc()

The interface provides only devm_kzalloc(), but devm_kmalloc() is easy.

Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/devres.c  |   16 ++++++++++++++--
 include/linux/device.h |    3 ++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff -puN drivers/base/devres.c~drivers-base-devresc-add-devm_kmalloc drivers/base/devres.c
--- a/drivers/base/devres.c~drivers-base-devresc-add-devm_kmalloc
+++ a/drivers/base/devres.c
@@ -91,7 +91,8 @@ static __always_inline struct devres * a
 	if (unlikely(!dr))
 		return NULL;
 
-	memset(dr, 0, tot_size);
+	if (gfp & __GFP_ZERO)
+		memset(dr, 0, tot_size);
 	INIT_LIST_HEAD(&dr->node.entry);
 	dr->node.release = release;
 	return dr;
@@ -770,7 +771,7 @@ static int devm_kzalloc_match(struct dev
  * RETURNS:
  * Pointer to allocated memory on success, NULL on failure.
  */
-void * devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
+static void *__devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
 {
 	struct devres *dr;
 
@@ -783,8 +784,19 @@ void * devm_kzalloc(struct device *dev,
 	devres_add(dev, dr->data);
 	return dr->data;
 }
+
+void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
+{
+	return __devm_kzalloc(dev, size, gfp | __GFP_ZERO);
+}
 EXPORT_SYMBOL_GPL(devm_kzalloc);
 
+void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp)
+{
+	return __devm_kzalloc(dev, size, gfp);
+}
+EXPORT_SYMBOL_GPL(devm_kmalloc);
+
 /**
  * devm_kfree - Resource-managed kfree
  * @dev: Device this memory belongs to
diff -puN include/linux/device.h~drivers-base-devresc-add-devm_kmalloc include/linux/device.h
--- a/include/linux/device.h~drivers-base-devresc-add-devm_kmalloc
+++ a/include/linux/device.h
@@ -602,8 +602,9 @@ extern void devres_close_group(struct de
 extern void devres_remove_group(struct device *dev, void *id);
 extern int devres_release_group(struct device *dev, void *id);
 
-/* managed kzalloc/kfree for device drivers, no kmalloc, always use kzalloc */
+/* managed kmalloc/kzalloc/kfree for device drivers */
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
+extern void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments-fix.patch
mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch
mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

