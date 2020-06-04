From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-util-annotate-an-data-race-at-vm_committed_as.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 14:30:06 -0700
Message-ID: <20200604213006.k3gayrVtF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgFDVaI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 17:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, cl@linux.com, dennis@kernel.org, elver@google.com, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm/util.c: annotate an data race at vm_committed_as
has been removed from the -mm tree.  Its filename was
     mm-util-annotate-an-data-race-at-vm_committed_as.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/util.c: annotate an data race at vm_committed_as

"vm_committed_as.count" could be accessed concurrently as reported by
KCSAN,

 read to 0xffffffff923164f8 of 8 bytes by task 1268 on cpu 38:
  __vm_enough_memory+0x43/0x280 mm/util.c:801
  mmap_region+0x1b2/0xb90 mm/mmap.c:1726
  do_mmap+0x45c/0x700
  vm_mmap_pgoff+0xc0/0x130
  vm_mmap+0x71/0x90
  elf_map+0xa1/0x1b0
  load_elf_binary+0x9de/0x2180
  search_binary_handler+0xd8/0x2b0
  __do_execve_file+0xb61/0x1080
  __x64_sys_execve+0x5f/0x70
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 write to 0xffffffff923164f8 of 8 bytes by task 1265 on cpu 41:
  percpu_counter_add_batch+0x83/0xd0 lib/percpu_counter.c:91
  exit_mmap+0x178/0x220 include/linux/mman.h:68
  mmput+0x10e/0x270
  flush_old_exec+0x572/0xfe0
  load_elf_binary+0x467/0x2180
  search_binary_handler+0xd8/0x2b0
  __do_execve_file+0xb61/0x1080
  __x64_sys_execve+0x5f/0x70
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The warning is almost impossible to trigger according to the commit
82f71ae4a2b8 ("mm: catch memory commitment underflow") but leave it for
now to catch any possible unbalanced vm_unacct_memory() in the future. 
Since only the read is operating as lockless, mark it as an intentional
data race using the data_race() macro to avoid modifying
percpu_counter_read() and still catch unintended races elsewhere.

Link: http://lkml.kernel.org/r/1581518109-21180-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/util.c~mm-util-annotate-an-data-race-at-vm_committed_as
+++ a/mm/util.c
@@ -814,8 +814,12 @@ int __vm_enough_memory(struct mm_struct
 {
 	long allowed;
 
-	VM_WARN_ONCE(percpu_counter_read(&vm_committed_as) <
-			-(s64)vm_committed_as_batch * num_online_cpus(),
+	/*
+	 * A transient decrease in the value is unlikely, so no need
+	 * READ_ONCE() for vm_committed_as.count.
+	 */
+	VM_WARN_ONCE(data_race(percpu_counter_read(&vm_committed_as) <
+			-(s64)vm_committed_as_batch * num_online_cpus()),
 			"memory commitment underflow");
 
 	vm_acct_memory(pages);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
