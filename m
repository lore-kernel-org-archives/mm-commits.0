From: akpm@linux-foundation.org
Subject: +
 mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks.patch added to
 -mm tree
Date: Thu, 14 Jul 2016 13:54:32 -0700
Message-ID: <5787fc08.zFWCi47GJ96FCZE8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbcGNUyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 16:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, hannes@cmpxchg.org, jpoimboe@redhat.com, mhocko@kernel.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: track NR_KERNEL_STACK in KiB instead of number of stacks
has been added to the -mm tree.  Its filename is
     mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: mm: track NR_KERNEL_STACK in KiB instead of number of stacks

Currently, NR_KERNEL_STACK tracks the number of kernel stacks in a zone. 
This only makes sense if each kernel stack exists entirely in one zone,
and allowing vmapped stacks could break this assumption.

Since frv has THREAD_SIZE < PAGE_SIZE, we need to track kernel stack
allocations in a unit that divides both THREAD_SIZE and PAGE_SIZE on all
architectures.  Keep it simple and use KiB.

Link: http://lkml.kernel.org/r/083c71e642c5fa5f1b6898902e1b2db7b48940d4.1468523549.git.luto@kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    3 +--
 fs/proc/meminfo.c      |    2 +-
 include/linux/mmzone.h |    2 +-
 kernel/fork.c          |    3 ++-
 mm/page_alloc.c        |    3 +--
 5 files changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/base/node.c~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks drivers/base/node.c
--- a/drivers/base/node.c~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks
+++ a/drivers/base/node.c
@@ -124,8 +124,7 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(node_page_state(pgdat, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
 		       nid, K(i.sharedram),
-		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK) *
-				THREAD_SIZE / 1024,
+		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK_KB),
 		       nid, K(sum_zone_node_page_state(nid, NR_PAGETABLE)),
 		       nid, K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
 		       nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
diff -puN fs/proc/meminfo.c~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks
+++ a/fs/proc/meminfo.c
@@ -147,7 +147,7 @@ static int meminfo_proc_show(struct seq_
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
 		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
-		global_page_state(NR_KERNEL_STACK) * THREAD_SIZE / 1024,
+		global_page_state(NR_KERNEL_STACK_KB),
 		K(global_page_state(NR_PAGETABLE)),
 #ifdef CONFIG_QUICKLIST
 		K(quicklist_total_size()),
diff -puN include/linux/mmzone.h~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks
+++ a/include/linux/mmzone.h
@@ -114,7 +114,7 @@ enum zone_stat_item {
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
-	NR_KERNEL_STACK,
+	NR_KERNEL_STACK_KB,	/* measured in KiB */
 	/* Second 128 byte cacheline */
 	NR_BOUNCE,
 #if IS_ENABLED(CONFIG_ZSMALLOC)
diff -puN kernel/fork.c~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks kernel/fork.c
--- a/kernel/fork.c~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks
+++ a/kernel/fork.c
@@ -225,7 +225,8 @@ static void account_kernel_stack(unsigne
 {
 	struct zone *zone = page_zone(virt_to_page(stack));
 
-	mod_zone_page_state(zone, NR_KERNEL_STACK, account);
+	mod_zone_page_state(zone, NR_KERNEL_STACK_KB,
+			    THREAD_SIZE / 1024 * account);
 }
 
 void free_task(struct task_struct *tsk)
diff -puN mm/page_alloc.c~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks mm/page_alloc.c
--- a/mm/page_alloc.c~mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks
+++ a/mm/page_alloc.c
@@ -4377,8 +4377,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_MLOCK)),
 			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
 			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
-			zone_page_state(zone, NR_KERNEL_STACK) *
-				THREAD_SIZE / 1024,
+			zone_page_state(zone, NR_KERNEL_STACK_KB),
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(free_pcp),
_

Patches currently in -mm which might be from luto@kernel.org are

mm-track-nr_kernel_stack-in-kib-instead-of-number-of-stacks.patch
mm-fix-memcg-stack-accounting-for-sub-page-stacks.patch
kdb-use-task_cpu-instead-of-task_thread_info-cpu.patch
printk-when-dumping-regs-show-the-stack-not-thread_info.patch

