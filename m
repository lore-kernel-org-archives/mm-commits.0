Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D709036DA0A
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388623; cv=none; b=OSRlUcuPfZ4mCIBNWZZca9HogXuY8jfwBm3IS0F8ItlFRkUO6UrkRsSZXHPLTlfOdwvDOSLfH2aoIP/F+Oh0IrN3+/bTD7ZGY6YbodR6Jp7InaXFjzD/rglDG+qES5f0ht5yXg31dhP0PlSNUzaS6MhQ9hLeWxs6Lj+5IkrjLjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388623; c=relaxed/simple;
	bh=GjBwIA7FgEkJuAISsZtmz/2E2zj4pT38GLtOqjWh8EE=;
	h=Date:To:From:Subject:Message-Id; b=gDQq9/QWl9EI/da/Q00g+RTiHASOgzM4DLDB0avhfs3+McluLk1IWj+8qZ6oDVLLBpR7eJV07k6YjPXzyDM7pWBK4MKD2gY+ufy1AFZtmm7YofbNzEbtA5oQWdPEiJbI11rLJcfOcJ1cNjsdMeJukygdUDx7tf6iuOn7q5R+n3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D0R/L709; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D0R/L709"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD225C19424;
	Tue, 24 Mar 2026 21:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388623;
	bh=GjBwIA7FgEkJuAISsZtmz/2E2zj4pT38GLtOqjWh8EE=;
	h=Date:To:From:Subject:From;
	b=D0R/L709RsmMUfZ2DUtSomsh6FCwaOuklvI/YSGQ2pr6gcYD9xaYh0qsji33hJiPn
	 PIrHozy0L2KZQDzhlBNsO4Gw8FabsO4afitWLqbYBXNTlmZZh3qaSDDKLqQJt6E3Im
	 LDYLwmkIjxVYb9Zz5SU4RBWZy7cHheAIqDmDa6YU=
Date: Tue, 24 Mar 2026 14:43:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ljs@kernel.org,jack@suse.cz,david@kernel.org,chrisl@kernel.org,brauner@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] folio_batch-rename-pagevech-to-folio_batchh.patch removed from -mm tree
Message-Id: <20260324214343.AD225C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: folio_batch: rename pagevec.h to folio_batch.h
has been removed from the -mm tree.  Its filename was
     folio_batch-rename-pagevech-to-folio_batchh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: folio_batch: rename pagevec.h to folio_batch.h
Date: Wed, 25 Feb 2026 18:44:27 -0500

struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
pagevec").  Rename include/linux/pagevec.h to reflect reality and update
includes tree-wide.  Add the new filename to MAINTAINERS explicitly, as it
no longer matches the "include/linux/page[-_]*" pattern in MEMORY
MANAGEMENT - CORE.

Link: https://lkml.kernel.org/r/20260225-pagevec_cleanup-v2-3-716868cc2d11@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                               |    1 
 drivers/gpu/drm/drm_gem.c                 |    2 
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 
 drivers/gpu/drm/i915/gt/intel_gtt.h       |    2 
 drivers/gpu/drm/i915/i915_gpu_error.c     |    2 
 fs/btrfs/compression.c                    |    2 
 fs/btrfs/extent_io.c                      |    2 
 fs/btrfs/tests/extent-io-tests.c          |    2 
 fs/buffer.c                               |    2 
 fs/ceph/addr.c                            |    2 
 fs/ext4/inode.c                           |    2 
 fs/f2fs/checkpoint.c                      |    2 
 fs/f2fs/compress.c                        |    2 
 fs/f2fs/data.c                            |    2 
 fs/f2fs/node.c                            |    2 
 fs/gfs2/aops.c                            |    2 
 fs/hugetlbfs/inode.c                      |    2 
 fs/nilfs2/btree.c                         |    2 
 fs/nilfs2/page.c                          |    2 
 fs/nilfs2/segment.c                       |    2 
 fs/ramfs/file-nommu.c                     |    2 
 include/linux/folio_batch.h               |  105 ++++++++++++++++++++
 include/linux/folio_queue.h               |    2 
 include/linux/iomap.h                     |    2 
 include/linux/pagevec.h                   |  105 --------------------
 include/linux/sunrpc/svc.h                |    2 
 include/linux/writeback.h                 |    2 
 mm/filemap.c                              |    2 
 mm/gup.c                                  |    2 
 mm/memcontrol.c                           |    2 
 mm/mlock.c                                |    2 
 mm/page-writeback.c                       |    2 
 mm/page_alloc.c                           |    2 
 mm/shmem.c                                |    2 
 mm/swap.c                                 |    2 
 mm/swap_state.c                           |    2 
 mm/truncate.c                             |    2 
 mm/vmscan.c                               |    2 
 38 files changed, 141 insertions(+), 140 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/drivers/gpu/drm/drm_gem.c
@@ -38,7 +38,7 @@
 #include <linux/mman.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -3,7 +3,7 @@
  * Copyright © 2014-2016 Intel Corporation
  */
 
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/shmem_fs.h>
 #include <linux/swap.h>
 #include <linux/uio.h>
--- a/drivers/gpu/drm/i915/gt/intel_gtt.h~folio_batch-rename-pagevech-to-folio_batchh
+++ a/drivers/gpu/drm/i915/gt/intel_gtt.h
@@ -19,7 +19,7 @@
 #include <linux/io-mapping.h>
 #include <linux/kref.h>
 #include <linux/mm.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 
--- a/drivers/gpu/drm/i915/i915_gpu_error.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -31,7 +31,7 @@
 #include <linux/debugfs.h>
 #include <linux/highmem.h>
 #include <linux/nmi.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
 #include <linux/utsname.h>
--- a/fs/btrfs/compression.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/btrfs/compression.c
@@ -8,7 +8,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
 #include <linux/time.h>
--- a/fs/btrfs/extent_io.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/btrfs/extent_io.c
@@ -11,7 +11,7 @@
 #include <linux/blkdev.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/prefetch.h>
 #include <linux/fsverity.h>
 #include "extent_io.h"
--- a/fs/btrfs/tests/extent-io-tests.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/btrfs/tests/extent-io-tests.c
@@ -4,7 +4,7 @@
  */
 
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sizes.h>
--- a/fs/buffer.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/buffer.c
@@ -45,7 +45,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched/mm.h>
 #include <trace/events/block.h>
 #include <linux/fscrypt.h>
--- a/fs/ceph/addr.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/ceph/addr.c
@@ -7,7 +7,7 @@
 #include <linux/swap.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/signal.h>
 #include <linux/iversion.h>
--- a/fs/ext4/inode.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/ext4/inode.c
@@ -29,7 +29,7 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mpage.h>
 #include <linux/rmap.h>
 #include <linux/namei.h>
--- a/fs/f2fs/checkpoint.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/f2fs/checkpoint.c
@@ -11,7 +11,7 @@
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/f2fs_fs.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/swap.h>
 #include <linux/kthread.h>
 #include <linux/delayacct.h>
--- a/fs/f2fs/compress.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/f2fs/compress.c
@@ -13,7 +13,7 @@
 #include <linux/lzo.h>
 #include <linux/lz4.h>
 #include <linux/zstd.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 
 #include "f2fs.h"
 #include "node.h"
--- a/fs/f2fs/data.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/f2fs/data.c
@@ -10,7 +10,7 @@
 #include <linux/sched/mm.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
 #include <linux/blk-crypto.h>
--- a/fs/f2fs/node.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/f2fs/node.c
@@ -10,7 +10,7 @@
 #include <linux/mpage.h>
 #include <linux/sched/mm.h>
 #include <linux/blkdev.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/swap.h>
 
 #include "f2fs.h"
--- a/fs/gfs2/aops.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/gfs2/aops.c
@@ -10,7 +10,7 @@
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mpage.h>
 #include <linux/fs.h>
 #include <linux/writeback.h>
--- a/fs/hugetlbfs/inode.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/hugetlbfs/inode.c
@@ -25,7 +25,7 @@
 #include <linux/ctype.h>
 #include <linux/backing-dev.h>
 #include <linux/hugetlb.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/fs_parser.h>
 #include <linux/mman.h>
 #include <linux/slab.h>
--- a/fs/nilfs2/btree.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/nilfs2/btree.c
@@ -10,7 +10,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/errno.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include "nilfs.h"
 #include "page.h"
 #include "btnode.h"
--- a/fs/nilfs2/page.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/nilfs2/page.c
@@ -14,7 +14,7 @@
 #include <linux/page-flags.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/gfp.h>
 #include "nilfs.h"
 #include "page.h"
--- a/fs/nilfs2/segment.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/nilfs2/segment.c
@@ -19,7 +19,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/crc32.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/slab.h>
 #include <linux/sched/signal.h>
 
--- a/fs/ramfs/file-nommu.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/fs/ramfs/file-nommu.c
@@ -14,7 +14,7 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/ramfs.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/include/linux/folio_batch.h a/include/linux/folio_batch.h
new file mode 100664
--- /dev/null
+++ a/include/linux/folio_batch.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * include/linux/folio_batch.h
+ *
+ * In many places it is efficient to batch an operation up against multiple
+ * folios.  A folio_batch is a container which is used for that.
+ */
+
+#ifndef _LINUX_FOLIO_BATCH_H
+#define _LINUX_FOLIO_BATCH_H
+
+#include <linux/types.h>
+
+/* 31 pointers + header align the folio_batch structure to a power of two */
+#define PAGEVEC_SIZE	31
+
+struct folio;
+
+/**
+ * struct folio_batch - A collection of folios.
+ *
+ * The folio_batch is used to amortise the cost of retrieving and
+ * operating on a set of folios.  The order of folios in the batch may be
+ * significant (eg delete_from_page_cache_batch()).  Some users of the
+ * folio_batch store "exceptional" entries in it which can be removed
+ * by calling folio_batch_remove_exceptionals().
+ */
+struct folio_batch {
+	unsigned char nr;
+	unsigned char i;
+	bool percpu_pvec_drained;
+	struct folio *folios[PAGEVEC_SIZE];
+};
+
+/**
+ * folio_batch_init() - Initialise a batch of folios
+ * @fbatch: The folio batch.
+ *
+ * A freshly initialised folio_batch contains zero folios.
+ */
+static inline void folio_batch_init(struct folio_batch *fbatch)
+{
+	fbatch->nr = 0;
+	fbatch->i = 0;
+	fbatch->percpu_pvec_drained = false;
+}
+
+static inline void folio_batch_reinit(struct folio_batch *fbatch)
+{
+	fbatch->nr = 0;
+	fbatch->i = 0;
+}
+
+static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
+{
+	return fbatch->nr;
+}
+
+static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
+{
+	return PAGEVEC_SIZE - fbatch->nr;
+}
+
+/**
+ * folio_batch_add() - Add a folio to a batch.
+ * @fbatch: The folio batch.
+ * @folio: The folio to add.
+ *
+ * The folio is added to the end of the batch.
+ * The batch must have previously been initialised using folio_batch_init().
+ *
+ * Return: The number of slots still available.
+ */
+static inline unsigned folio_batch_add(struct folio_batch *fbatch,
+		struct folio *folio)
+{
+	fbatch->folios[fbatch->nr++] = folio;
+	return folio_batch_space(fbatch);
+}
+
+/**
+ * folio_batch_next - Return the next folio to process.
+ * @fbatch: The folio batch being processed.
+ *
+ * Use this function to implement a queue of folios.
+ *
+ * Return: The next folio in the queue, or NULL if the queue is empty.
+ */
+static inline struct folio *folio_batch_next(struct folio_batch *fbatch)
+{
+	if (fbatch->i == fbatch->nr)
+		return NULL;
+	return fbatch->folios[fbatch->i++];
+}
+
+void __folio_batch_release(struct folio_batch *fbatch);
+
+static inline void folio_batch_release(struct folio_batch *fbatch)
+{
+	if (folio_batch_count(fbatch))
+		__folio_batch_release(fbatch);
+}
+
+void folio_batch_remove_exceptionals(struct folio_batch *fbatch);
+#endif /* _LINUX_FOLIO_BATCH_H */
--- a/include/linux/folio_queue.h~folio_batch-rename-pagevech-to-folio_batchh
+++ a/include/linux/folio_queue.h
@@ -14,7 +14,7 @@
 #ifndef _LINUX_FOLIO_QUEUE_H
 #define _LINUX_FOLIO_QUEUE_H
 
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mm.h>
 
 /*
--- a/include/linux/iomap.h~folio_batch-rename-pagevech-to-folio_batchh
+++ a/include/linux/iomap.h
@@ -9,7 +9,7 @@
 #include <linux/types.h>
 #include <linux/mm_types.h>
 #include <linux/blkdev.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 
 struct address_space;
 struct fiemap_extent_info;
diff --git a/include/linux/pagevec.h a/include/linux/pagevec.h
deleted file mode 100644
--- a/include/linux/pagevec.h
+++ /dev/null
@@ -1,105 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * include/linux/pagevec.h
- *
- * In many places it is efficient to batch an operation up against multiple
- * folios.  A folio_batch is a container which is used for that.
- */
-
-#ifndef _LINUX_PAGEVEC_H
-#define _LINUX_PAGEVEC_H
-
-#include <linux/types.h>
-
-/* 31 pointers + header align the folio_batch structure to a power of two */
-#define PAGEVEC_SIZE	31
-
-struct folio;
-
-/**
- * struct folio_batch - A collection of folios.
- *
- * The folio_batch is used to amortise the cost of retrieving and
- * operating on a set of folios.  The order of folios in the batch may be
- * significant (eg delete_from_page_cache_batch()).  Some users of the
- * folio_batch store "exceptional" entries in it which can be removed
- * by calling folio_batch_remove_exceptionals().
- */
-struct folio_batch {
-	unsigned char nr;
-	unsigned char i;
-	bool percpu_pvec_drained;
-	struct folio *folios[PAGEVEC_SIZE];
-};
-
-/**
- * folio_batch_init() - Initialise a batch of folios
- * @fbatch: The folio batch.
- *
- * A freshly initialised folio_batch contains zero folios.
- */
-static inline void folio_batch_init(struct folio_batch *fbatch)
-{
-	fbatch->nr = 0;
-	fbatch->i = 0;
-	fbatch->percpu_pvec_drained = false;
-}
-
-static inline void folio_batch_reinit(struct folio_batch *fbatch)
-{
-	fbatch->nr = 0;
-	fbatch->i = 0;
-}
-
-static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
-{
-	return fbatch->nr;
-}
-
-static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
-{
-	return PAGEVEC_SIZE - fbatch->nr;
-}
-
-/**
- * folio_batch_add() - Add a folio to a batch.
- * @fbatch: The folio batch.
- * @folio: The folio to add.
- *
- * The folio is added to the end of the batch.
- * The batch must have previously been initialised using folio_batch_init().
- *
- * Return: The number of slots still available.
- */
-static inline unsigned folio_batch_add(struct folio_batch *fbatch,
-		struct folio *folio)
-{
-	fbatch->folios[fbatch->nr++] = folio;
-	return folio_batch_space(fbatch);
-}
-
-/**
- * folio_batch_next - Return the next folio to process.
- * @fbatch: The folio batch being processed.
- *
- * Use this function to implement a queue of folios.
- *
- * Return: The next folio in the queue, or NULL if the queue is empty.
- */
-static inline struct folio *folio_batch_next(struct folio_batch *fbatch)
-{
-	if (fbatch->i == fbatch->nr)
-		return NULL;
-	return fbatch->folios[fbatch->i++];
-}
-
-void __folio_batch_release(struct folio_batch *fbatch);
-
-static inline void folio_batch_release(struct folio_batch *fbatch)
-{
-	if (folio_batch_count(fbatch))
-		__folio_batch_release(fbatch);
-}
-
-void folio_batch_remove_exceptionals(struct folio_batch *fbatch);
-#endif /* _LINUX_PAGEVEC_H */
--- a/include/linux/sunrpc/svc.h~folio_batch-rename-pagevech-to-folio_batchh
+++ a/include/linux/sunrpc/svc.h
@@ -20,7 +20,7 @@
 #include <linux/lwq.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/kthread.h>
 
 /*
--- a/include/linux/writeback.h~folio_batch-rename-pagevech-to-folio_batchh
+++ a/include/linux/writeback.h
@@ -11,7 +11,7 @@
 #include <linux/flex_proportions.h>
 #include <linux/backing-dev-defs.h>
 #include <linux/blk_types.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 
 struct bio;
 
--- a/MAINTAINERS~folio_batch-rename-pagevech-to-folio_batchh
+++ a/MAINTAINERS
@@ -16653,6 +16653,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
 F:	include/linux/highmem.h
--- a/mm/filemap.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/filemap.c
@@ -31,7 +31,7 @@
 #include <linux/hash.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/security.h>
 #include <linux/cpuset.h>
 #include <linux/hugetlb.h>
--- a/mm/gup.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/gup.c
@@ -18,7 +18,7 @@
 #include <linux/hugetlb.h>
 #include <linux/migrate.h>
 #include <linux/mm_inline.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 
--- a/mm/memcontrol.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/memcontrol.c
@@ -34,7 +34,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/vm_event_item.h>
 #include <linux/smp.h>
 #include <linux/page-flags.h>
--- a/mm/mlock.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/mlock.c
@@ -13,7 +13,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/pagewalk.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
--- a/mm/page_alloc.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/page_alloc.c
@@ -31,7 +31,7 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
--- a/mm/page-writeback.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/page-writeback.c
@@ -33,7 +33,7 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/timer.h>
 #include <linux/sched/rt.h>
 #include <linux/sched/signal.h>
--- a/mm/shmem.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/shmem.c
@@ -61,7 +61,7 @@ static struct vfsmount *shm_mnt __ro_aft
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/percpu_counter.h>
 #include <linux/falloc.h>
 #include <linux/splice.h>
--- a/mm/swap.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/swap.c
@@ -20,7 +20,7 @@
 #include <linux/swap.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/mm_inline.h>
--- a/mm/swap_state.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/swap_state.c
@@ -15,7 +15,7 @@
 #include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 #include <linux/migrate.h>
--- a/mm/truncate.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/truncate.c
@@ -17,7 +17,7 @@
 #include <linux/export.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/shmem_fs.h>
 #include <linux/rmap.h>
--- a/mm/vmscan.c~folio_batch-rename-pagevech-to-folio_batchh
+++ a/mm/vmscan.c
@@ -44,7 +44,7 @@
 #include <linux/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/oom.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/prefetch.h>
 #include <linux/printk.h>
 #include <linux/dax.h>
_

Patches currently in -mm which might be from tz2294@columbia.edu are


