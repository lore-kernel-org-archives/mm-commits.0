Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D841662E7;
	Tue, 25 Feb 2025 05:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740460840; cv=none; b=PvOGxP0v+2pIajKegda9PfKkxqVZrJq5qmVcYpnyHCQO0enMGO9DZHQF6eHpJd2uwLK899TtthwgZxsoDddHmW96a/DaAcplxMDRflXnUw0SorOlZzAhmOoQB8KNYRWL85XFj6zlCLeeEaQoU/MVifDKZNUIrLEVf48oU+esN9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740460840; c=relaxed/simple;
	bh=+pdVw3nVCnP1BBHqxKg0W+TmqmyuT8v/Z8Xh3MhgkhM=;
	h=Date:To:From:Subject:Message-Id; b=qb+j5lVe3N9/oP1T23b/X951/oTkakiuVDnGerGo8nQbvJCF1nrwPjWFwsI8aVF4hh7iBWj7kZu0fhH40oeK2vp6cNsKkzUOo93LmFjlR4lwyH2sGjK34w4MSiHCfy3dhlCT9rTuUXC6xqrzZeL6J6BvX3WB1c7ubG08UPdEfJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tsjnC8eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tsjnC8eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C1FC4CEDD;
	Tue, 25 Feb 2025 05:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740460840;
	bh=+pdVw3nVCnP1BBHqxKg0W+TmqmyuT8v/Z8Xh3MhgkhM=;
	h=Date:To:From:Subject:From;
	b=tsjnC8eu1WVX4p8gMh1D2+F3pxuK+JpLdEKFSORnm919zveZycI77lIN+FjZdjwtf
	 ddNNSc1Ep0ra0L4On6iV649vK3sE6Az8r9qUUEPlmqcO7viFqS1r0s8dKuSSldczqK
	 oZ6wjFCXtBAOleI4R2tw0j2igxcwuipgelUXev9g=
Date: Mon, 24 Feb 2025 21:20:39 -0800
To: mm-commits@vger.kernel.org,trond.myklebust@hammerspace.com,stable@vger.kernel.org,anna.schumaker@oracle.com,snitzer@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback.patch added to mm-hotfixes-unstable branch
Message-Id: <20250225052039.E2C1FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: NFS: fix nfs_release_folio() to not deadlock via kcompactd writeback
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

Link: https://lkml.kernel.org/r/20250225022002.26141-1-snitzer@kernel.org
Fixes: 96780ca55e3cb ("NFS: fix up nfs_release_folio() to try to release the page")
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
 
+	tsk->flags |= PF_KCOMPACTD;
 	set_freezable();
 
 	pgdat->kcompactd_max_order = 0;
@@ -3237,6 +3238,8 @@ static int kcompactd(void *p)
 			pgdat->proactive_compact_trigger = false;
 	}
 
+	tsk->flags &= ~PF_KCOMPACTD;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from snitzer@kernel.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback.patch

