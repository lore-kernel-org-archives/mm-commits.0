From: akpm@linux-foundation.org
Subject: + memcg-fix-prepare-migration.patch added to -mm tree
Date: Mon, 12 Apr 2010 21:26:39 -0400
Message-ID: <201004130428.o3D4SHCK012692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab0DME2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 00:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix prepare migration
has been added to the -mm tree.  Its filename is
     memcg-fix-prepare-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix prepare migration
From: Andrea Arcangeli <aarcange@redhat.com>

If a signal is pending (task being killed by sigkill)
__mem_cgroup_try_charge will write NULL into &mem, and css_put will oops
on null pointer dereference.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff810fc6cc>] mem_cgroup_prepare_migration+0x7c/0xc0
PGD a5d89067 PUD a5d8a067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/platform/microcode/firmware/microcode/loading
CPU 0
Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc acpi_cpufreq pcspkr sg [last unloaded: microcode]

Pid: 5299, comm: largepages Tainted: G        W  2.6.34-rc3 #3 Penryn1600SLI-110dB/To Be Filled By O.E.M.
RIP: 0010:[<ffffffff810fc6cc>]  [<ffffffff810fc6cc>] mem_cgroup_prepare_migration+0x7c/0xc0

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-prepare-migration mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-prepare-migration
+++ a/mm/memcontrol.c
@@ -2429,8 +2429,9 @@ int mem_cgroup_prepare_migration(struct 
 	}
 	unlock_page_cgroup(pc);
 
+	*ptr = mem;
 	if (mem) {
-		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem, false);
+		ret = __mem_cgroup_try_charge(NULL, GFP_KERNEL, ptr, false);
 		css_put(&mem->css);
 	}
 	*ptr = mem;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
memcg-fix-prepare-migration.patch
define-madv_hugepage.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-memory-compaction-core-fix-page-buddy-can-go-away-before-reading-page_order-while-isolating-pages-for-migration.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch

