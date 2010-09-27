From: akpm@linux-foundation.org
Subject: + drm-prune-gem-vma-entries.patch added to -mm tree
Date: Mon, 27 Sep 2010 13:37:57 -0700
Message-ID: <201009272037.o8RKbvRC015232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328Ab0I0UiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 16:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chris@chris-wilson.co.uk, airlied@redhat.com, jbarnes@virtuousgeek.org, mpm@selenic.com, stable@kernel.org


The patch titled
     drm: prune GEM vma entries
has been added to the -mm tree.  Its filename is
     drm-prune-gem-vma-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: prune GEM vma entries
From: Chris Wilson <chris@chris-wilson.co.uk>

Hook the GEM vm open/close ops into the generic drm vm open/close so that
the private vma entries are created and destroy appropriately.  Fixes the
leak of the drm_vma_entries during the lifetime of the filp.

Reported-by: Matt Mackall <mpm@selenic.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c |    9 ++++++++-
 drivers/gpu/drm/drm_vm.c  |   28 ++++++++++++++++++----------
 include/drm/drmP.h        |    1 +
 3 files changed, 27 insertions(+), 11 deletions(-)

diff -puN drivers/gpu/drm/drm_gem.c~drm-prune-gem-vma-entries drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-prune-gem-vma-entries
+++ a/drivers/gpu/drm/drm_gem.c
@@ -526,6 +526,10 @@ void drm_gem_vm_open(struct vm_area_stru
 	struct drm_gem_object *obj = vma->vm_private_data;
 
 	drm_gem_object_reference(obj);
+
+	mutex_lock(&obj->dev->struct_mutex);
+	drm_vm_open_locked(vma);
+	mutex_unlock(&obj->dev->struct_mutex);
 }
 EXPORT_SYMBOL(drm_gem_vm_open);
 
@@ -533,7 +537,10 @@ void drm_gem_vm_close(struct vm_area_str
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 
-	drm_gem_object_unreference_unlocked(obj);
+	mutex_lock(&obj->dev->struct_mutex);
+	drm_vm_close_locked(vma);
+	drm_gem_object_unreference(obj);
+	mutex_unlock(&obj->dev->struct_mutex);
 }
 EXPORT_SYMBOL(drm_gem_vm_close);
 
diff -puN drivers/gpu/drm/drm_vm.c~drm-prune-gem-vma-entries drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c~drm-prune-gem-vma-entries
+++ a/drivers/gpu/drm/drm_vm.c
@@ -433,15 +433,7 @@ static void drm_vm_open(struct vm_area_s
 	mutex_unlock(&dev->struct_mutex);
 }
 
-/**
- * \c close method for all virtual memory types.
- *
- * \param vma virtual memory area.
- *
- * Search the \p vma private data entry in drm_device::vmalist, unlink it, and
- * free it.
- */
-static void drm_vm_close(struct vm_area_struct *vma)
+void drm_vm_close_locked(struct vm_area_struct *vma)
 {
 	struct drm_file *priv = vma->vm_file->private_data;
 	struct drm_device *dev = priv->minor->dev;
@@ -451,7 +443,6 @@ static void drm_vm_close(struct vm_area_
 		  vma->vm_start, vma->vm_end - vma->vm_start);
 	atomic_dec(&dev->vma_count);
 
-	mutex_lock(&dev->struct_mutex);
 	list_for_each_entry_safe(pt, temp, &dev->vmalist, head) {
 		if (pt->vma == vma) {
 			list_del(&pt->head);
@@ -459,6 +450,23 @@ static void drm_vm_close(struct vm_area_
 			break;
 		}
 	}
+}
+
+/**
+ * \c close method for all virtual memory types.
+ *
+ * \param vma virtual memory area.
+ *
+ * Search the \p vma private data entry in drm_device::vmalist, unlink it, and
+ * free it.
+ */
+static void drm_vm_close(struct vm_area_struct *vma)
+{
+	struct drm_file *priv = vma->vm_file->private_data;
+	struct drm_device *dev = priv->minor->dev;
+
+	mutex_lock(&dev->struct_mutex);
+	drm_vm_close_locked(vma);
 	mutex_unlock(&dev->struct_mutex);
 }
 
diff -puN include/drm/drmP.h~drm-prune-gem-vma-entries include/drm/drmP.h
--- a/include/drm/drmP.h~drm-prune-gem-vma-entries
+++ a/include/drm/drmP.h
@@ -1158,6 +1158,7 @@ extern int drm_release(struct inode *ino
 extern int drm_mmap(struct file *filp, struct vm_area_struct *vma);
 extern int drm_mmap_locked(struct file *filp, struct vm_area_struct *vma);
 extern void drm_vm_open_locked(struct vm_area_struct *vma);
+extern void drm_vm_close_locked(struct vm_area_struct *vma);
 extern unsigned int drm_poll(struct file *filp, struct poll_table_struct *wait);
 
 				/* Memory management support (drm_memory.h) */
_

Patches currently in -mm which might be from chris@chris-wilson.co.uk are

origin.patch
drm-prune-gem-vma-entries.patch

