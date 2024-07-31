Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4455A8BE0
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 01:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722388467; cv=none; b=ukbr5ExsBKjfgvCYYSsyN0SY0amdBldRJ7dBpuM1+9B+kyPX1lcAg8cab0XPmsV4g2BGU/p5K/jRJaB/SOcc741kMYBoZLfAC8TmeRAt0C/QdnK8fSxxqO7gfOQ+9pAdHBI2tvwGRtz8KaVhlIcSqwBt2Ez77pzodkbhZhtFT/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722388467; c=relaxed/simple;
	bh=Ns0DSGy+C/yFoHmBRE2EqVfflX3Ofb37wclf7F2NpGA=;
	h=Date:To:From:Subject:Message-Id; b=dwgCflIY8IbBStnj6mxLA+I7QgVfofOCtvglU1epsuyq1u1FQA6d+Z3poSlny8d1ImNqvjsq2gaCbrCV5pzywvNEBucD2aWfqdVT7PTQiFh6KFK5kq6SnzF6gqZlVKZGO4n3Cs+ClUvER/+TITGXM4dZmsCZHE+Uu4zpTbduHGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PJ51pIf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJ51pIf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C43C32782;
	Wed, 31 Jul 2024 01:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722388466;
	bh=Ns0DSGy+C/yFoHmBRE2EqVfflX3Ofb37wclf7F2NpGA=;
	h=Date:To:From:Subject:From;
	b=PJ51pIf/ni5FvUWRKtzQObgOxgV1woUtVWFeX+/qNBM+Uabuq5ayYJ8iPRau/8Nvn
	 eu63LlmTfUojof8JdecCNL81nL4D0XOMSFmxBr6jUJ/9ox38E5hllmIsG3n2NQCu8N
	 2k35gZo3mV4gBSZAJV8AUltt+6F5oVKdtC31r1wo=
Date: Tue, 30 Jul 2024 18:14:26 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,hsiangkao@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20240731011426.D5C43C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: fix deadlock in migrate_pages_batch() on large folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios.patch

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

mm-migrate-fix-deadlock-in-migrate_pages_batch-on-large-folios.patch

