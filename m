Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052114;
	b=J9W2yl/7f867wgP/3foMG5JlFFk8kkKggFBIQ1jg5myxSBwtvBhuP/B84NkhvvM//LqJ
	 eBY5jvDFlMM0ZzzeZn2NcT7NsjK+hPp/1l8BU0XF5A6iNnrqDFUHjq5gWmeovGALH1EsC
	 oiQpa0AAS2lHaM7TeZcSJrFqVR5z3nwpI1ZQmxSCQUMLLbdN/WYmVRuKJas5843noFWMj
	 LE1kUHB4a+nx6nHJA5snjespqZ7hEAtcVqXDEWA1lHmgtFa2a36ulUypQqFjYsZei05a0
	 ui2u2pIjmgszPjqbOMVvMlkpP0orLvAbdOKEwJ4urYbPvR4J0jPMtmYQOjTi2WoC13Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052114;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rqrHxi7XoPczyB4AGHT5DUy0RgNTVRZuUR0NJCOVwKc=;
	b=WQg/k/2o4AtN75/S79bFarKMl4IvGoNfVkmMhrYaS5pZ8ZB4Fc0yBd2oP91J0y1a4aPG
	 uZCBXcZBu345hOUQIIS4M8DMrvX5kt+NRr6AdY5bnijoPm4rW6RYXKWdCGwM3GZi59Chk
	 fJdTtWrZdggjxrEV2t2Rnl5L92DRkz4sxiUnZYyL+zk0NadDk5hP4QXyIsBZ3tuJtBCea
	 GjJZUzAwLsTtZHHCcdWxN80Nx5GH8h8yQQAaUmGFDUMF0XCNfqSUHAE0RYnJbqOV1p8A6
	 6+aa46PCMnXDXimi+spTU9TfKF3fnJ5wr8pSUPf0bY1F2rmnbnKsUz0dYPW1lYmCGeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JtZvomsG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF34D606A31A
	for <mm-commits@vger.kernel.org>; Mon, 26 Oct 2026 22:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JtZvomsG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B2A1F01825;
	Mon, 26 Oct 2026 22:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793052113;
	bh=rqrHxi7XoPczyB4AGHT5DUy0RgNTVRZuUR0NJCOVwKc=;
	h=Date:To:From:Subject;
	b=JtZvomsGtFm4O/9G9k/hvlAR/WVAl+GYZE9sBDwnpJJsx8RBkiUtcyR0RoCZN78p7
	 jZoHxXhqYYhPlIqU6rvP5zJ6eHbsnelstCZvTbmQC4YXcQ33c1glZjTE9g3FBCkCSa
	 z+7uTsrp77gaEhSfv03A9gM940quKTsBIDXhUBw4=
Date: Mon, 26 Oct 2026 15:01:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,matthew.brost@intel.com,joshua.hahnjy@gmail.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,
	chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-move-nr_file_thps-on-cross-node-migration.patch added to mm-new branch
Message-Id: <20261026220153.98B2A1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/migrate: move NR_FILE_THPS on cross-node migration
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-move-nr_file_thps-on-cross-node-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-move-nr_file_thps-on-cross-node-migration.patch

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
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/migrate: move NR_FILE_THPS on cross-node migration
Date: Sun, 25 Oct 2026 19:02:09 +0800

When a page cache folio is migrated to another node,
__folio_migrate_mapping() moves the per-node and per-memcg counters
that are keyed off the folio's node: NR_FILE_PAGES, NR_SHMEM,
NR_SHMEM_THPS, NR_SWAPCACHE and NR_FILE_DIRTY.  NR_FILE_THPS is not
moved, although __filemap_add_folio() charges it to the source node and
filemap_unaccount_folio() takes it off whatever node the folio lives on
when it is removed.

Commit 0b52c420350e ("mm: fix shmem THP counters on migration") added
the NR_SHMEM_THPS case but not its file-backed counterpart.  Now that
ext4, xfs, btrfs and erofs can all have PMD-sized page cache folios,
migrating them via NUMA balancing, mbind(), migratepages, demotion or
memory offlining leaks FileHugePages on the source node and underflows
it on the destination, in both /sys/devices/system/node/nodeN/meminfo
and memory.numa_stat.  The global value is unaffected, which is why this
went unnoticed.

Reproducer, on a 2-node QEMU guest with THP set to "always":

  1. read a 256M ext4 file through a MADV_HUGEPAGE mapping while bound
     to node 0, so its page cache is 128 PMD-sized folios on node 0;
  2. move the mapping to node 1 with mbind(MPOL_MF_MOVE);
  3. unmap the file and drop its page cache.

nr_file_hugepages in /sys/devices/system/node/nodeN/vmstat after each
step (in units of PMD-sized folios):

                    without this patch     with this patch
                     node0     node1       node0     node1
  1. cached           128         0         128         0
  2. migrated         128         0           0       128
  3. dropped          128         0 (*)       0         0

  (*) the counter has underflowed to -128; negative values read as 0.

Without the patch the 128 folios stay accounted to node 0 forever, and
every further round adds another 128.  The same happens to the per-memcg
per-node counter: after step 3, memory.stat of the cgroup shows
"file_thp 0", while memory.numa_stat still shows
"file_thp N0=268435456 N1=0".  With the patch both are 0.

Move NR_FILE_THPS together with NR_FILE_PAGES, using the same condition
filemap_unaccount_folio() uses to take it off, so that THPs in the swap
cache are left alone.

Link: https://lore.kernel.org/20261025110209.4105994-1-ridong.chen@linux.dev
Fixes: d68eccad3706 ("mm/filemap: Allow large folios to be added to the page cache")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 mm/migrate.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/migrate.c~mm-migrate-move-nr_file_thps-on-cross-node-migration
+++ a/mm/migrate.c
@@ -700,6 +700,10 @@ static int __folio_migrate_mapping(struc
 				mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
 				mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
 			}
+		} else if (!folio_test_swapbacked(folio) &&
+			   folio_test_pmd_mappable(folio)) {
+			mod_lruvec_state(old_lruvec, NR_FILE_THPS, -nr);
+			mod_lruvec_state(new_lruvec, NR_FILE_THPS, nr);
 		}
 #ifdef CONFIG_SWAP
 		if (folio_test_swapcache(folio)) {
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-migrate-move-nr_file_thps-on-cross-node-migration.patch

