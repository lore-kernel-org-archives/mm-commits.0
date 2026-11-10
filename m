Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293108;
	b=l/FadmYFxXWCJa0z1gFd4VMBBtdXfCba81pC5sznqzaL8hpWbtAvwLWJ8GK02G+wxsav
	 JwN+dWN/SDQFLV/iBssGH1pPJlntBBIjhhvYWWaZMFdS+c7U1GpZy6sBJpI75RPX7awhr
	 iiK8we95mcpd7MUIipGKMh/KI0qREvRL61P0LOY6agNTnhlaYDvHJyPRBLbPpiEDY6ytV
	 17XKtYxeLVF8kDr11tacLgf6ca89UT7UOe1F9+AFd0B6v6M3RCmsjzOBXvU3nbxc9i85d
	 vN4vPF+PM1AxjXBB1Rmq+FJ/sQ+5JGYKs/morXP9i+CckqeYlmurTO0ZWg3QBwCgtQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293108;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1+EWMG1s4PtNLGMTM7gtsLhW6vrqjRkE1/MQE+IymZA=;
	b=Gg6jUWBS+o3wBfmZidfT0N6PCKRwKb9gc3ZiL49rG0UeO92wFTt/FPUMjb6L2hylzYjU
	 EBKuTVsReoxbqgnLwEogxat8eeBXSZ2J6iMnm7482naVpZFTviSkbU/Hm+Notr2CI3sXk
	 Db57UO79qK/9WFopnyEjzvxR9sJRBh9RONz2WVEzYtrUvuxjf2MEv03B5BF9VLtccKRWP
	 tLdXqb2//WFCagAUzXzyla/xivR8TgTYJ/l/l1zWY/RP0iOEzszSJgls8OSCsQbV+Wdhn
	 r+SldzOi9WscsjaDMANEsWpuBdyNWYa0QACL4VReHRZZKZgRV1aoipjzDQuHSUFo7cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0ss6A5T5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FAE606CB02;
	Tue, 10 Nov 2026 06:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0ss6A5T5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32C61F008A3;
	Tue, 10 Nov 2026 06:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293107;
	bh=1+EWMG1s4PtNLGMTM7gtsLhW6vrqjRkE1/MQE+IymZA=;
	h=Date:To:From:Subject;
	b=0ss6A5T5OJa/842uN05Dof3gh2G0GChIP+yvamq8rOzY4lRAvoCJS4Lx+V8TPpgJA
	 7cy31gwUe+o82gawlNsVsXiHojKb2HG5eCaRg938aGGd1V9VVKQ95jlrQtknEWPPmW
	 FXGzvIPya4Wai05kw44377yrtB/92kWwP6BBFwy4=
Date: Mon, 09 Nov 2026 22:45:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	stable@vger.kernel.org,shivankg@amd.com,shakeel.butt@linux.dev,
	matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,
	david@kernel.org,byungchul@sk.com,boris@bur.io,apopple@nvidia.com,
	chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch removed from -mm tree
Message-Id: <20261110064507.C32C61F008A3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/migrate: move NR_KERNEL_FILE_PAGES on cross-node migration
has been removed from the -mm tree.  Its filename was
     mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/migrate: move NR_KERNEL_FILE_PAGES on cross-node migration
Date: Tue, 27 Oct 2026 12:32:14 +0800

NR_KERNEL_FILE_PAGES counts page cache folios of mappings flagged
AS_KERNEL_FILE (currently the btrfs btree inode).  It is a per-node
counter: filemap_add_folio() adds to folio_pgdat() of the new folio and
filemap_unaccount_folio() subtracts from folio_pgdat() of the folio
being removed.

__folio_migrate_mapping() does not move it when such a folio is
migrated to another node, so the source node keeps the count forever
and the destination node underflows once the folio is freed.  btree
folios are migratable through btree_migrate_folio(), so demotion,
DAMON-based migration (DAMOS_MIGRATE_{HOT,COLD}) or memory offlining
all hit this.

Reproducer, on a QEMU guest with two memory tiers (node0 is DRAM with
all CPUs, node1 is a CPU-less slower node described via HMAT) and
/sys/kernel/mm/numa/demotion_enabled set:

  1. mount a btrfs and create 20000 empty files, so that btree folios
     are cached on node0;
  2. echo 2G > /sys/devices/system/node/node0/reclaim, which demotes
     them to node1;
  3. umount and drop caches.

nr_kernel_file_pages in /sys/devices/system/node/nodeN/vmstat after
each step:

                  without this patch     with this patch
                   node0     node1       node0     node1
  1. cached         1868         0        1868         0
  2. demoted        1868         0          36      1832
  3. dropped        1832         0 (*)       0         0

  (*) the counter has underflowed to -1832; negative values read as 0.

The global value in /proc/vmstat is 0 after step 3 in both cases.

Move it together with the other node-keyed page cache counters.  It is
a node-only counter, so use the node accessor, matching how it is
accounted elsewhere.  Interrupts are disabled here, as for the zone
counters below.

This was pointed out by Shivank while reviewing the NR_FILE_THPS fix
for the same function.

Link: https://lore.kernel.org/20261027043214.2248986-1-ridong.chen@linux.dev
Fixes: e3a9ac4e866e ("mm: add vmstat for kernel_file pages")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Boris Burkov <boris@bur.io>
Cc: <stable@vger.kernel.org>
---

 mm/migrate.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/migrate.c~mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration
+++ a/mm/migrate.c
@@ -705,6 +705,12 @@ static int __folio_migrate_mapping(struc
 			mod_lruvec_state(old_lruvec, NR_FILE_THPS, -nr);
 			mod_lruvec_state(new_lruvec, NR_FILE_THPS, nr);
 		}
+		if (test_bit(AS_KERNEL_FILE, &mapping->flags)) {
+			__mod_node_page_state(oldzone->zone_pgdat,
+					      NR_KERNEL_FILE_PAGES, -nr);
+			__mod_node_page_state(newzone->zone_pgdat,
+					      NR_KERNEL_FILE_PAGES, nr);
+		}
 #ifdef CONFIG_SWAP
 		if (folio_test_swapcache(folio)) {
 			mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch
mm-vmscan-move-vmscan-tracepoints-to-a-local-header.patch
mm-vmscan-move-struct-scan_control-to-a-dedicated-header.patch
mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch
mm-mglru-add-tracepoint-for-scan_folios.patch
mm-mglru-add-lruvec_gen_size-helper.patch
mm-mglru-add-tracepoint-for-aging.patch
mailmap-add-entries-for-ridong-chen.patch

