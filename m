Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293107;
	b=qwHVHkOCa4xuc38c5eNlZi6V3ZoUvAoxv7D14G1CHe13kjQnd7dkhJlcTK269/R3gkO2
	 QRZmToAQLfNTE7LseF39nAeLA8CrU8qmV4+VUh81iHH5LYWfnXI/Y9fJdYjySTR3LRtfV
	 xbTKAR9JLC1Z84SZULoc6BTFDffGD0h1hqqPA8CL4naVKxO8BeNnywETfHPsPLZFY1VYb
	 NYCrrQb0qBhAkHYtlWdxZR9e2jxSsddJk6NpkN7FxUq8v16MP31NdTcJJuK0DQ5sxdv5d
	 lOV3GGk9ASSXdpB4nXejFOZRlrUfs+DJHrsUtPY9pOS47xPfWJ14J0I+u3+n3UWE/MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293107;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=8SPIuC7JNmyFrwJK+NGl1yIa0CNge/s333PngePxXaQ=;
	b=VYkn3LyC5AxLOwGb4X9LXveN85xd4gY0SZss4OElnq2doX1FtDkRXwXxvu6/ZHL1wYfb
	 T35rNGVznPGzH7nITi38fWF4KNFPgHLFGm89lyIQez/r25kBobZeCbKEzzdh5Z5wRG3/S
	 av1snZkfnj+tlrSgJHytBK4OfYKzIMBN7dLv4cpgDoO9Q/0qrlBF3mW7cdj9CkBwEqC4N
	 VuE+/qQa10umqkP+ciWG1KhBth0QTSDbWlVqDaMu3fpJ4+goNUkCJUlgj9zdwFYIlgCDg
	 NY1m/oHmmJ806EodCB/c7+NCmNRndQ9TWtkMij0OLFr0HwmtFi9ZrEi/WWBUaTCKRIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Cc6ONljU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13E8606BD72;
	Tue, 10 Nov 2026 06:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Cc6ONljU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B75A1F00A05;
	Tue, 10 Nov 2026 06:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293106;
	bh=8SPIuC7JNmyFrwJK+NGl1yIa0CNge/s333PngePxXaQ=;
	h=Date:To:From:Subject;
	b=Cc6ONljUz422Wy0yqXGlK58i5LVQeossdco8Bt5zbiY1kXaIf0T0sdptAEcfsLx5R
	 YzPtwLlBFZuEfzbnoc/4+7kU07CkDAoVzV4g93rYDWCX+5KsPekbUykF9UolTRm8g9
	 iQidPg4HGjFWOq0NvxzL29OOOJRgDAVX/JUQj6RE=
Date: Mon, 09 Nov 2026 22:45:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,stable@vger.kernel.org,shivankg@amd.com,
	matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,
	david@kernel.org,byungchul@sk.com,apopple@nvidia.com,chenridong@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-move-nr_file_thps-on-cross-node-migration.patch removed from -mm tree
Message-Id: <20261110064506.8B75A1F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/migrate: move NR_FILE_THPS on cross-node migration
has been removed from the -mm tree.  Its filename was
     mm-migrate-move-nr_file_thps-on-cross-node-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: "Garg, Shivank" <shivankg@amd.com>
Cc: <stable@vger.kernel.org>
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

mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch
mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch
mm-vmscan-move-vmscan-tracepoints-to-a-local-header.patch
mm-vmscan-move-struct-scan_control-to-a-dedicated-header.patch
mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch
mm-mglru-add-tracepoint-for-scan_folios.patch
mm-mglru-add-lruvec_gen_size-helper.patch
mm-mglru-add-tracepoint-for-aging.patch
mailmap-add-entries-for-ridong-chen.patch

