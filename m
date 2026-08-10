Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0E03A1A54
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786402476; cv=none; b=lNg84ABWBwfWwcC4b4fhcb2MY13OqQflVVrEjjzkUSjxIQ5qVfLHv+BQFRYSQrC7zEanUfGHvRQ2H9CNxQP4OO3FBjOv3jBNBvf6R77bP/eYMziMjA7NPzYgiNBl+q//klqZqWysRy/afQEmRd5Y+Cknr1XkOe8nJXUcqmE8Q2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786402476; c=relaxed/simple;
	bh=nD1M+aJVhwc8xXoV9/dyh58LnsEjBibRDkxwxNiiqYg=;
	h=Date:To:From:Subject:Message-Id; b=CfHewsHrQn1cbFM7MvH+jHq2jAtRip5SHu4TAFFaYmlpCqQX8phUqrtnFZI4nxzUVTCvRz4PpC2B4TN2VBVsbOZL3dCCZxU/P0Y2xHjFnKzNfa03y9U1Msn4mZf6B3xlVhgxIRZiAPR2NnzPDY2y/qev763SDMduEQVJqMYwVsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ECRFgQmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ECRFgQmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D95F1F000E9;
	Mon, 10 Aug 2026 22:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786402474;
	bh=SgrQVWGbFeVkdBA8DGFt0/2UIHC3sDyp5Cl5DpJblAM=;
	h=Date:To:From:Subject;
	b=ECRFgQmv88BK0GLBiqmhCXLflGpCQjVDJ4QFGDITuXgrehDqkFZ2Fwv11bH3E3498
	 heL5eQKM/NdEflcDQRCWqLp2GJDXro/HrsT1qiBQrKB2/Ii3cwNR6obQXAkFMqhoY4
	 j1EWaHRLU9J0QW07G92rLRb6/eQxLWVWhIa3boR0=
Date: Mon, 10 Aug 2026 15:54:33 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,shikemeng@huaweicloud.com,sfrench@samba.org,ryncsn@gmail.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops.patch added to mm-new branch
Message-Id: <20260810225434.5D95F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: add a new swap_ops.h header to allow for pluggable swap ops
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch
mm-swap-revert-to-single-folio-writes-for-synchronous-swap-devices.patch
mm-swap-add-a-new-swap_opsh-header-to-allow-for-pluggable-swap-ops.patch
mm-swap-move-swap_ops-into-file-systems-for-file-system-based-swap.patch

