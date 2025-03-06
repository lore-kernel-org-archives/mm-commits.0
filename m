Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1466029CF0;
	Thu,  6 Mar 2025 05:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239455; cv=none; b=DCwptZTA5EzguxtcZlWZYnJuh7BIFMYmKL1wAwVw1sh1VrW0ImywkRkvAVa0rflAlNyDS+gjHVTvfm3mXoRqqQP9rjyB8lf8MZdwgtVDgAOUsQwU+83qiASYXXRr9lcTi177p15Lt42lkPSaXeVYdyj4hQ05iCZGqEq0IWTUN9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239455; c=relaxed/simple;
	bh=1jg6giIZcpOQ54WNpMzlcKpBDWP/7S85MFGyS0t6Etc=;
	h=Date:To:From:Subject:Message-Id; b=QyF97QCDUNzMr1wm8ymY+aiMAp237zhwe+56EUe5nqhduEvUrr06iyvBAaqdzd22lob9pxFHzxiVqIBX0lvDy1pkYk7LAwTT763AHJrRaut15jSwwrxv2+WItxh7ZzO7oozj7oNBfXM1tisUeVu0dntles3p6ZZoM77EFYmlvq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HGyY/ucn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HGyY/ucn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED46C4CEE4;
	Thu,  6 Mar 2025 05:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239455;
	bh=1jg6giIZcpOQ54WNpMzlcKpBDWP/7S85MFGyS0t6Etc=;
	h=Date:To:From:Subject:From;
	b=HGyY/ucnWMZ2DMD6/gqLRnekKNTOnC95QDzu3CyxsDvKoFwJ2VtHtNyygUbCwYarA
	 v8YIieD5MwCZVM/4NS0cUc8RZUZDfSATki1PkL68KNqitEaXuO8Dp/8BTqjHuTJEqM
	 lPfXtbyH+6TupHvZIasRMBc7hecveicAXjmR+L5s=
Date: Wed, 05 Mar 2025 21:37:34 -0800
To: mm-commits@vger.kernel.org,trond.myklebust@hammerspace.com,stable@vger.kernel.org,anna.schumaker@oracle.com,snitzer@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback.patch removed from -mm tree
Message-Id: <20250306053734.DED46C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: NFS: fix nfs_release_folio() to not deadlock via kcompactd writeback
has been removed from the -mm tree.  Its filename was
     nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Snitzer <snitzer@kernel.org>
Subject: NFS: fix nfs_release_folio() to not deadlock via kcompactd writeback
Date: Mon, 24 Feb 2025 21:20:02 -0500

Add PF_KCOMPACTD flag and current_is_kcompactd() helper to check for it so
nfs_release_folio() can skip calling nfs_wb_folio() from kcompactd.

Otherwise NFS can deadlock waiting for kcompactd enduced writeback which
recurses back to NFS (which triggers writeback to NFSD via NFS loopback
mount on the same host, NFSD blocks waiting for XFS's call to
__filemap_get_folio):

6070.550357] INFO: task kcompactd0:58 blocked for more than 4435 seconds.

{---
[58] "kcompactd0"
[<0>] folio_wait_bit+0xe8/0x200
[<0>] folio_wait_writeback+0x2b/0x80
[<0>] nfs_wb_folio+0x80/0x1b0 [nfs]
[<0>] nfs_release_folio+0x68/0x130 [nfs]
[<0>] split_huge_page_to_list_to_order+0x362/0x840
[<0>] migrate_pages_batch+0x43d/0xb90
[<0>] migrate_pages_sync+0x9a/0x240
[<0>] migrate_pages+0x93c/0x9f0
[<0>] compact_zone+0x8e2/0x1030
[<0>] compact_node+0xdb/0x120
[<0>] kcompactd+0x121/0x2e0
[<0>] kthread+0xcf/0x100
[<0>] ret_from_fork+0x31/0x40
[<0>] ret_from_fork_asm+0x1a/0x30
---}

[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/20250225022002.26141-1-snitzer@kernel.org
Fixes: 96780ca55e3c ("NFS: fix up nfs_release_folio() to try to release the page")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/file.c              |    3 ++-
 include/linux/compaction.h |    5 +++++
 include/linux/sched.h      |    2 +-
 mm/compaction.c            |    3 +++
 4 files changed, 11 insertions(+), 2 deletions(-)

--- a/fs/nfs/file.c~nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback
+++ a/fs/nfs/file.c
@@ -29,6 +29,7 @@
 #include <linux/pagemap.h>
 #include <linux/gfp.h>
 #include <linux/swap.h>
+#include <linux/compaction.h>
 
 #include <linux/uaccess.h>
 #include <linux/filelock.h>
@@ -457,7 +458,7 @@ static bool nfs_release_folio(struct fol
 	/* If the private flag is set, then the folio is not freeable */
 	if (folio_test_private(folio)) {
 		if ((current_gfp_context(gfp) & GFP_KERNEL) != GFP_KERNEL ||
-		    current_is_kswapd())
+		    current_is_kswapd() || current_is_kcompactd())
 			return false;
 		if (nfs_wb_folio(folio->mapping->host, folio) < 0)
 			return false;
--- a/include/linux/compaction.h~nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback
+++ a/include/linux/compaction.h
@@ -80,6 +80,11 @@ static inline unsigned long compact_gap(
 	return 2UL << order;
 }
 
+static inline int current_is_kcompactd(void)
+{
+	return current->flags & PF_KCOMPACTD;
+}
+
 #ifdef CONFIG_COMPACTION
 
 extern unsigned int extfrag_for_order(struct zone *zone, unsigned int order);
--- a/include/linux/sched.h~nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback
+++ a/include/linux/sched.h
@@ -1701,7 +1701,7 @@ extern struct pid *cad_pid;
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
-#define PF__HOLE__00010000	0x00010000
+#define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
--- a/mm/compaction.c~nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback
+++ a/mm/compaction.c
@@ -3181,6 +3181,7 @@ static int kcompactd(void *p)
 	long default_timeout = msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC);
 	long timeout = default_timeout;
 
+	current->flags |= PF_KCOMPACTD;
 	set_freezable();
 
 	pgdat->kcompactd_max_order = 0;
@@ -3237,6 +3238,8 @@ static int kcompactd(void *p)
 			pgdat->proactive_compact_trigger = false;
 	}
 
+	current->flags &= ~PF_KCOMPACTD;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from snitzer@kernel.org are


