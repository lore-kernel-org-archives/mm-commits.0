From: akpm@linux-foundation.org
Subject: - fbdefio-add-set_page_dirty-handler-to-deferred-io-fb.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:59 -0700
Message-ID: <200808210349.m7L3nxkN015677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755189AbYHUDvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ijc@hellion.org.uk, a.p.zijlstra@chello.nl, armbru@redhat.com, hannes@saeurebad.de, hugh@veritas.com, jayakumar.lkml@gmail.com, jeremy@goop.org, kel@otaku42.de, krzysztof.h1@poczta.fm


The patch titled
     fbdefio: add set_page_dirty handler to deferred IO FB
has been removed from the -mm tree.  Its filename was
     fbdefio-add-set_page_dirty-handler-to-deferred-io-fb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdefio: add set_page_dirty handler to deferred IO FB
From: Ian Campbell <ijc@hellion.org.uk>

Fixes kernel BUG at lib/radix-tree.c:473.

Previously the handler was incidentally provided by tmpfs but this was
removed with:

  commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
  Author: Hugh Dickins <hugh@veritas.com>
  Date:   Mon Jul 28 15:46:19 2008 -0700

    tmpfs: fix kernel BUG in shmem_delete_inode

relying on this behaviour was incorrect in any case and the BUG also
appeared when the device node was on an ext3 filesystem.

v2: override a_ops at open() time rather than mmap() time to minimise
races per AKPM's concerns.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kel Modderman <kel@otaku42.de>
Cc: Markus Armbruster <armbru@redhat.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: <stable@kernel.org> [14fcc23fd is in 2.6.25.14 and 2.6.26.1]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fb_defio.c |   19 +++++++++++++++++++
 drivers/video/fbmem.c    |    4 ++++
 include/linux/fb.h       |    3 +++
 3 files changed, 26 insertions(+)

diff -puN drivers/video/fb_defio.c~fbdefio-add-set_page_dirty-handler-to-deferred-io-fb drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~fbdefio-add-set_page_dirty-handler-to-deferred-io-fb
+++ a/drivers/video/fb_defio.c
@@ -114,6 +114,17 @@ static struct vm_operations_struct fb_de
 	.page_mkwrite	= fb_deferred_io_mkwrite,
 };
 
+static int fb_deferred_io_set_page_dirty(struct page *page)
+{
+	if (!PageDirty(page))
+		SetPageDirty(page);
+	return 0;
+}
+
+static const struct address_space_operations fb_deferred_io_aops = {
+	.set_page_dirty = fb_deferred_io_set_page_dirty,
+};
+
 static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	vma->vm_ops = &fb_deferred_io_vm_ops;
@@ -163,6 +174,14 @@ void fb_deferred_io_init(struct fb_info 
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_init);
 
+void fb_deferred_io_open(struct fb_info *info,
+			 struct inode *inode,
+			 struct file *file)
+{
+	file->f_mapping->a_ops = &fb_deferred_io_aops;
+}
+EXPORT_SYMBOL_GPL(fb_deferred_io_open);
+
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
 	void *screen_base = (void __force *) info->screen_base;
diff -puN drivers/video/fbmem.c~fbdefio-add-set_page_dirty-handler-to-deferred-io-fb drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdefio-add-set_page_dirty-handler-to-deferred-io-fb
+++ a/drivers/video/fbmem.c
@@ -1344,6 +1344,10 @@ fb_open(struct inode *inode, struct file
 		if (res)
 			module_put(info->fbops->owner);
 	}
+#ifdef CONFIG_FB_DEFERRED_IO
+	if (info->fbdefio)
+		fb_deferred_io_open(info, inode, file);
+#endif
 out:
 	unlock_kernel();
 	return res;
diff -puN include/linux/fb.h~fbdefio-add-set_page_dirty-handler-to-deferred-io-fb include/linux/fb.h
--- a/include/linux/fb.h~fbdefio-add-set_page_dirty-handler-to-deferred-io-fb
+++ a/include/linux/fb.h
@@ -976,6 +976,9 @@ static inline void __fb_pad_aligned_buff
 
 /* drivers/video/fb_defio.c */
 extern void fb_deferred_io_init(struct fb_info *info);
+extern void fb_deferred_io_open(struct fb_info *info,
+				struct inode *inode,
+				struct file *file);
 extern void fb_deferred_io_cleanup(struct fb_info *info);
 extern int fb_deferred_io_fsync(struct file *file, struct dentry *dentry,
 				int datasync);
_

Patches currently in -mm which might be from ijc@hellion.org.uk are


