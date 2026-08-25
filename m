Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E365376475
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622924; cv=none; b=X+lkq03FNMkXOPWIq1M/4qhOlApoZ+Ag12W5WeWWOZEAAGxIj45ur8WnsaJqcus9pYMROeYmHwc4mnoPfeSWXhlsZDpOwAlKh9Tg1nw+zLryNavHhYNHMdZXV1eRhZ/UMGwb/yUdWim1MuYIHVMjrTfM42HzaARo97ctqq2IFkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622924; c=relaxed/simple;
	bh=Nik7fqoHJPg0J1T3ES3CB22n0caqPEr6729MTlo0ocY=;
	h=Date:To:From:Subject:Message-Id; b=bH2qAI1FbbCsYjMyiI4atHCxy82hghRH3l+aFa6N1JnhlAyiwyqKNMOKojqy4zB9Mzm6uo0p0x9+x+E5LzVuxXkNtoY9rb0Q/G7SJiWZsQuA748txq1628XhPw9Qn9cSwhIt9UiuPPfL03gzXJlKq/OWr3AoTnCSOqylb4p37EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v7jgy9cn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v7jgy9cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1FF1F00A3A;
	Tue, 25 Aug 2026 01:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622917;
	bh=wEY5P9URP7gZW3lQDBzajDNr20pEjaIqk04KyAkwDxQ=;
	h=Date:To:From:Subject;
	b=v7jgy9cnqpGHwVsCn/i9eViOQiuLYqvihC23TF2NVEqWzOo13BL+1NRPhC6hDzObP
	 BuaKosZ9xLUhq0Lp/Cgy6oz1i8zpyj7JTkU2vL/qSw+6Cr4tgnzcxREUC9f99VYNJz
	 2JIzZhc5gx+SZ29b18aBhcXGxgmqJo0rcoR0qajM=
Date: Mon, 24 Aug 2026 18:55:17 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,shikemeng@huaweicloud.com,sfrench@samba.org,ryncsn@gmail.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops.patch removed from -mm tree
Message-Id: <20260825015517.9C1FF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: add a new swap_ops.h header to allow for pluggable swap ops
has been removed from the -mm tree.  Its filename was
     mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm/swap: add a new swap_ops.h header to allow for pluggable swap ops
Date: Thu, 23 Jul 2026 07:46:05 +0200

Add a new header to declare the swap_iocb, swap_ops and swap_ctx to allow
for swap_ops implementations outside of mm/page_io.c.  This will be used
to remove the double indirection for file system-based swap.  There is no
functional change, just a move of the declarations.

Note that there already is a swapops.h header, which is totally unrelated
to struct swap_ops.  The close naming is a bit unfortunate, but I could
not think of a better name for this header.

Link: https://lore.kernel.org/20260723054622.3460249-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Steve French <sfrench@samba.org>
Cc: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS              |    1 
 include/linux/swap_ops.h |   39 +++++++++++++++++++++++++++++++++++++
 mm/madvise.c             |    1 
 mm/page_io.c             |   10 ---------
 mm/shmem.c               |    1 
 mm/swap.h                |   23 ---------------------
 mm/swap_state.c          |    1 
 mm/vmscan.c              |    1 
 mm/zswap.c               |    2 -
 9 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/include/linux/swap_ops.h a/include/linux/swap_ops.h
new file mode 100644
--- /dev/null
+++ a/include/linux/swap_ops.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_SWAP_OPS_H
+#define _MM_SWAP_OPS_H
+
+#include <linux/swap.h> /* for SWAP_CLUSTER_MAX */
+
+struct swap_iocb {
+	union {
+		struct kiocb	iocb;
+		struct bio	bio;
+	};
+	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
+	int			nr_bvecs;
+	int			len;
+};
+
+struct swap_io_ctx {
+	struct swap_iocb	*sio;
+	struct swap_info_struct	*sis;
+};
+
+/*
+ * SWAP_OPS_F_REQUIRE_NOFS:
+ *	When set, all reclaim operations must operated as GFS_NOFS and not
+ *	just GFP_NOIO, as GFP_NOIO allocations could recourse into the
+ *	file system backing this swap file.
+ */
+#define SWAP_OPS_F_REQUIRE_NOFS		(1U << 0)
+
+struct swap_ops {
+	unsigned int		flags;
+
+	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
+			size_t prev_folio_size, int rw);
+	void (*submit_write)(struct swap_io_ctx *ctx);
+	void (*submit_read)(struct swap_io_ctx *ctx);
+};
+
+#endif /* _MM_SWAP_OPS_H */
--- a/MAINTAINERS~mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops
+++ a/MAINTAINERS
@@ -17242,6 +17242,7 @@ S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
 F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
+F:	include/linux/swap_ops.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
--- a/mm/madvise.c~mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops
+++ a/mm/madvise.c
@@ -32,6 +32,7 @@
 #include <linux/leafops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/swap_ops.h>
 
 #include <asm/tlb.h>
 
--- a/mm/page_io.c~mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops
+++ a/mm/page_io.c
@@ -25,6 +25,7 @@
 #include <linux/sched/task.h>
 #include <linux/delayacct.h>
 #include <linux/zswap.h>
+#include <linux/swap_ops.h>
 #include "swap.h"
 #include "swap_table.h"
 
@@ -300,15 +301,6 @@ static bool folio_blkg_can_merge(struct
 #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
-struct swap_iocb {
-	union {
-		struct kiocb	iocb;
-		struct bio	bio;
-	};
-	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
-	int			nr_bvecs;
-	int			len;
-};
 static mempool_t *sio_pool;
 
 int sio_pool_init(void)
--- a/mm/shmem.c~mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops
+++ a/mm/shmem.c
@@ -41,6 +41,7 @@
 #include <linux/swapfile.h>
 #include <linux/iversion.h>
 #include <linux/unicode.h>
+#include <linux/swap_ops.h>
 #include "swap.h"
 
 static struct vfsmount *shm_mnt __ro_after_init;
--- a/mm/swap.h~mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops
+++ a/mm/swap.h
@@ -10,6 +10,7 @@
 struct mempolicy;
 struct swap_iocb;
 struct swap_memcg_table;
+struct swap_io_ctx;
 
 #if defined(MAX_POSSIBLE_PHYSMEM_BITS)
 #define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
@@ -91,28 +92,6 @@ static inline int mem_cgroup_swappiness(
 	return READ_ONCE(vm_swappiness);
 }
 
-struct swap_io_ctx {
-	struct swap_iocb	*sio;
-	struct swap_info_struct	*sis;
-};
-
-/*
- * SWAP_OPS_F_REQUIRE_NOFS:
- *	When set, all reclaim operations must operated as GFS_NOFS and not
- *	just GFP_NOIO, as GFP_NOIO allocations could recourse into the
- *	file system backing this swap file.
- */
-#define SWAP_OPS_F_REQUIRE_NOFS		(1U << 0)
-
-struct swap_ops {
-	unsigned int		flags;
-
-	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
-			size_t prev_folio_size, int rw);
-	void (*submit_write)(struct swap_io_ctx *ctx);
-	void (*submit_read)(struct swap_io_ctx *ctx);
-};
-
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
--- a/mm/swap_state.c~mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops
+++ a/mm/swap_state.c
@@ -23,6 +23,7 @@
 #include <linux/huge_mm.h>
 #include <linux/shmem_fs.h>
 #include <linux/sysctl.h>
+#include <linux/swap_ops.h>
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
--- a/mm/vmscan.c~mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops
+++ a/mm/vmscan.c
@@ -58,6 +58,7 @@
 #include <linux/random.h>
 #include <linux/mmu_notifier.h>
 #include <linux/parser.h>
+#include <linux/swap_ops.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
--- a/mm/zswap.c~mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops
+++ a/mm/zswap.c
@@ -20,7 +20,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/atomic.h>
-#include <linux/swap.h>
+#include <linux/swap_ops.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
 #include <linux/mempolicy.h>
_

Patches currently in -mm which might be from hch@lst.de are


