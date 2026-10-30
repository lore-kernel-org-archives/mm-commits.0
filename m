Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793322241;
	b=R+tpd8cs0SHKEuA+PmBKJt6jQLVLQe0MRDQzW6TFvbCBECbQsL1jQqwvQLgvxip63s0X
	 557Fl/soRIAzho6XsKmoFpyILzJ4skl2xBDCBJ497VhWQXcVQMLMzSRIHBFhJfdVZ2R7Q
	 7Rqqe9kyfHIK+t3nLlKPPV9j0UGx1mbGD0oSMSqVjaB6ZPEYWcSgtmLrhCOm3sSp5N3Qp
	 JNqy1a8QIYYOQTjncSBTAx3txV+EM9bsamR3RznSmKvibX7ISHwzka9pxZpnJH79tw5MF
	 canCXbaQyGuZFEF9Ff/kNsw6UOakGuuMrCBdfh2bFzO7qnqeK6+73W/tcE56uCe17uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793322241;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WDb1sxnjkMHfYiPKrBV13efmxBKnMQp6SqHhp8mXO+g=;
	b=v7vvkYXbnUWk+VTxpa3ESWGPbXWqPPGoXVchf1rkCn5OlpgBrV2hYODP55PQInUq38ro
	 kXKdCtkVMpthNLJGpFyMwlKbTUkMMZ0TtVmA+XEeaNBxadSFC62rMLxxCSWdrV+bF/9o6
	 dpsQSpjMyO5hYP2c9bEc2qci+4ZR3Kbl++iN6MUlNYnSzCjF18BUyYAcxukHYvh1RYYcJ
	 hQjxMQIlp77ixRRD4o25JNuWGvqgxwHBoV7Qxg+dSiI5spGdWvP+xFk0Y6odNzP+/JxEL
	 5hJdCA3GiHPSrhuj1zn/Hl4GrxoS4ku4oa1gZgW2K2dBHUZrzYHz9vNpEKgnPtBunYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tTOO1RjF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536BA606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 01:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tTOO1RjF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67901F000C1;
	Fri, 30 Oct 2026 01:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793322240;
	bh=WDb1sxnjkMHfYiPKrBV13efmxBKnMQp6SqHhp8mXO+g=;
	h=Date:To:From:Subject;
	b=tTOO1RjFpr235IrOk4dS/JARRPgDRa/sph6qlTNkolEjX8pynJTfrtFpBEa5F+bxl
	 yMSGOUcKfaSMujucpgPbHBGMt0uTGTD41OpcdvGff+bdbqsm3oTS8/EMD4Q7yHnKkt
	 oMKAVj14FbMwCv2T8mZBswPnJqCM9lDULgakUx+s=
Date: Thu, 29 Oct 2026 18:04:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	shivankg@amd.com,shakeel.butt@linux.dev,matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	boris@bur.io,apopple@nvidia.com,chenridong@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch added to mm-new branch
Message-Id: <20261030010400.C67901F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/migrate: move NR_KERNEL_FILE_PAGES on cross-node migration
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch

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
Assisted-by: LLM
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Boris Burkov <boris@bur.io>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

mm-migrate-move-nr_file_thps-on-cross-node-migration.patch
mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch

