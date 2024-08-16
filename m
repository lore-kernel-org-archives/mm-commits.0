Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825FB383A5
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 05:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723786040; cv=none; b=ZuIleM9YjbXeaGgQa5n9TtpbIB5NXJ+tBVPZMnjHgPA9SpqChy74SzdBxNENivp+tgOxcZF9OMt5UWBMpDh3DMU2gEicRXonl5aiQWctHgZG425F/OChd6e81yU/oXJgN3Mc7Y1AGlrQrhE7UiOV7Oy7OeSZuJZAOPhe1CHHP98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723786040; c=relaxed/simple;
	bh=1Km1NQDlIZI8mkLoWdLUP4bNnzdFxJfxKxkjFRjA4zU=;
	h=Date:To:From:Subject:Message-Id; b=oXs50oNZoW/ZIHUR9Sq3BHYryjaoSA+IHJI3/UGsF1ZYDzeCXEv6WgpMpCHCHUHwsmxwCvN/n3fR/G7284mSgw5li4GHIGK8PXrpV6CjLLnbIUgpdQeICuvj1jhz3EJPB8VxrVqnAezyzHxZtyUzVEhvONrZf4ehkwcCbA5k3SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CgAjARX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CgAjARX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF42C32782;
	Fri, 16 Aug 2024 05:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723786040;
	bh=1Km1NQDlIZI8mkLoWdLUP4bNnzdFxJfxKxkjFRjA4zU=;
	h=Date:To:From:Subject:From;
	b=CgAjARX1Qs5liQTFbIeOo92OR/c2bvJxgH4HSSc4FtCkmbCk6teJWxHIMiJDb9eBL
	 iV2idqXjNzrv6FNlbQ4dDL9bzwWJLEEOHnTlIkjWyWWiByH0QiGGzR4BTTihReDltv
	 VLOPxZ/IrM4W8p+BD/ZsOuMBB5FmAEhAmRvSZqJ8=
Date: Thu, 15 Aug 2024 22:27:19 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,david@redhat.com,hsiangkao@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios.patch removed from -mm tree
Message-Id: <20240816052720.3DF42C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: fix deadlock in migrate_pages_batch() on large folios
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: mm/migrate: fix deadlock in migrate_pages_batch() on large folios
Date: Mon, 29 Jul 2024 10:13:06 +0800

Currently, migrate_pages_batch() can lock multiple locked folios with an
arbitrary order.  Although folio_trylock() is used to avoid deadlock as
commit 2ef7dbb26990 ("migrate_pages: try migrate in batch asynchronously
firstly") mentioned, it seems try_split_folio() is still missing.

It was found by compaction stress test when I explicitly enable EROFS
compressed files to use large folios, which case I cannot reproduce with
the same workload if large folio support is off (current mainline). 
Typically, filesystem reads (with locked file-backed folios) could use
another bdev/meta inode to load some other I/Os (e.g.  inode extent
metadata or caching compressed data), so the locking order will be:

  file-backed folios  (A)
     bdev/meta folios (B)

The following calltrace shows the deadlock:
   Thread 1 takes (B) lock and tries to take folio (A) lock
   Thread 2 takes (A) lock and tries to take folio (B) lock

[Thread 1]
INFO: task stress:1824 blocked for more than 30 seconds.
      Tainted: G           OE      6.10.0-rc7+ #6
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:stress          state:D stack:0     pid:1824  tgid:1824  ppid:1822   flags:0x0000000c
Call trace:
 __switch_to+0xec/0x138
 __schedule+0x43c/0xcb0
 schedule+0x54/0x198
 io_schedule+0x44/0x70
 folio_wait_bit_common+0x184/0x3f8
			<-- folio mapping ffff00036d69cb18 index 996  (**)
 __folio_lock+0x24/0x38
 migrate_pages_batch+0x77c/0xea0	// try_split_folio (mm/migrate.c:1486:2)
					// migrate_pages_batch (mm/migrate.c:1734:16)
		<--- LIST_HEAD(unmap_folios) has
			..
			folio mapping 0xffff0000d184f1d8 index 1711;   (*)
			folio mapping 0xffff0000d184f1d8 index 1712;
			..
 migrate_pages+0xb28/0xe90
 compact_zone+0xa08/0x10f0
 compact_node+0x9c/0x180
 sysctl_compaction_handler+0x8c/0x118
 proc_sys_call_handler+0x1a8/0x280
 proc_sys_write+0x1c/0x30
 vfs_write+0x240/0x380
 ksys_write+0x78/0x118
 __arm64_sys_write+0x24/0x38
 invoke_syscall+0x78/0x108
 el0_svc_common.constprop.0+0x48/0xf0
 do_el0_svc+0x24/0x38
 el0_svc+0x3c/0x148
 el0t_64_sync_handler+0x100/0x130
 el0t_64_sync+0x190/0x198

[Thread 2]
INFO: task stress:1825 blocked for more than 30 seconds.
      Tainted: G           OE      6.10.0-rc7+ #6
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:stress          state:D stack:0     pid:1825  tgid:1825  ppid:1822   flags:0x0000000c
Call trace:
 __switch_to+0xec/0x138
 __schedule+0x43c/0xcb0
 schedule+0x54/0x198
 io_schedule+0x44/0x70
 folio_wait_bit_common+0x184/0x3f8
			<-- folio = 0xfffffdffc6b503c0 (mapping == 0xffff0000d184f1d8 index == 1711) (*)
 __folio_lock+0x24/0x38
 z_erofs_runqueue+0x384/0x9c0 [erofs]
 z_erofs_readahead+0x21c/0x350 [erofs]       <-- folio mapping 0xffff00036d69cb18 range from [992, 1024] (**)
 read_pages+0x74/0x328
 page_cache_ra_order+0x26c/0x348
 ondemand_readahead+0x1c0/0x3a0
 page_cache_sync_ra+0x9c/0xc0
 filemap_get_pages+0xc4/0x708
 filemap_read+0x104/0x3a8
 generic_file_read_iter+0x4c/0x150
 vfs_read+0x27c/0x330
 ksys_pread64+0x84/0xd0
 __arm64_sys_pread64+0x28/0x40
 invoke_syscall+0x78/0x108
 el0_svc_common.constprop.0+0x48/0xf0
 do_el0_svc+0x24/0x38
 el0_svc+0x3c/0x148
 el0t_64_sync_handler+0x100/0x130
 el0t_64_sync+0x190/0x198

Link: https://lkml.kernel.org/r/20240729021306.398286-1-hsiangkao@linux.alibaba.com
Fixes: 5dfab109d519 ("migrate_pages: batch _unmap and _move")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios
+++ a/mm/migrate.c
@@ -1479,11 +1479,17 @@ out:
 	return rc;
 }
 
-static inline int try_split_folio(struct folio *folio, struct list_head *split_folios)
+static inline int try_split_folio(struct folio *folio, struct list_head *split_folios,
+				  enum migrate_mode mode)
 {
 	int rc;
 
-	folio_lock(folio);
+	if (mode == MIGRATE_ASYNC) {
+		if (!folio_trylock(folio))
+			return -EAGAIN;
+	} else {
+		folio_lock(folio);
+	}
 	rc = split_folio_to_list(folio, split_folios);
 	folio_unlock(folio);
 	if (!rc)
@@ -1677,7 +1683,7 @@ static int migrate_pages_batch(struct li
 			 */
 			if (nr_pages > 2 &&
 			   !list_empty(&folio->_deferred_list)) {
-				if (try_split_folio(folio, split_folios) == 0) {
+				if (!try_split_folio(folio, split_folios, mode)) {
 					nr_failed++;
 					stats->nr_thp_failed += is_thp;
 					stats->nr_thp_split += is_thp;
@@ -1699,7 +1705,7 @@ static int migrate_pages_batch(struct li
 			if (!thp_migration_supported() && is_thp) {
 				nr_failed++;
 				stats->nr_thp_failed++;
-				if (!try_split_folio(folio, split_folios)) {
+				if (!try_split_folio(folio, split_folios, mode)) {
 					stats->nr_thp_split++;
 					stats->nr_split++;
 					continue;
@@ -1731,7 +1737,7 @@ static int migrate_pages_batch(struct li
 				stats->nr_thp_failed += is_thp;
 				/* Large folio NUMA faulting doesn't split to retry. */
 				if (is_large && !nosplit) {
-					int ret = try_split_folio(folio, split_folios);
+					int ret = try_split_folio(folio, split_folios, mode);
 
 					if (!ret) {
 						stats->nr_thp_split += is_thp;
_

Patches currently in -mm which might be from hsiangkao@linux.alibaba.com are


