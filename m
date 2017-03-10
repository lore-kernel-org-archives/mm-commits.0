From: akpm@linux-foundation.org
Subject: [merged]
 mm-do-not-call-mem_cgroup_free-from-within-mem_cgroup_alloc.patch removed
 from -mm tree
Date: Fri, 10 Mar 2017 13:43:28 -0800
Message-ID: <58c31e00.GWSqmp7hJW67/3UM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38092 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933047AbdCJVna (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tahsin@google.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not call mem_cgroup_free() from within mem_cgroup_alloc()
has been removed from the -mm tree.  Its filename was
     mm-do-not-call-mem_cgroup_free-from-within-mem_cgroup_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tahsin Erdogan <tahsin@google.com>
Subject: mm: do not call mem_cgroup_free() from within mem_cgroup_alloc()

mem_cgroup_free() indirectly calls wb_domain_exit() which is not prepared
to deal with a struct wb_domain object that hasn't executed
wb_domain_init().  For instance, the following warning message is printed
by lockdep if alloc_percpu() fails in mem_cgroup_alloc():

  INFO: trying to register non-static key.
  the code is fine but needs lockdep annotation.
  turning off the locking correctness validator.
  CPU: 1 PID: 1950 Comm: mkdir Not tainted 4.10.0+ #151
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
  Call Trace:
   dump_stack+0x67/0x99
   register_lock_class+0x36d/0x540
   __lock_acquire+0x7f/0x1a30
   ? irq_work_queue+0x73/0x90
   ? wake_up_klogd+0x36/0x40
   ? console_unlock+0x45d/0x540
   ? vprintk_emit+0x211/0x2e0
   lock_acquire+0xcc/0x200
   ? try_to_del_timer_sync+0x60/0x60
   del_timer_sync+0x3c/0xc0
   ? try_to_del_timer_sync+0x60/0x60
   wb_domain_exit+0x14/0x20
   mem_cgroup_free+0x14/0x40
   mem_cgroup_css_alloc+0x3f9/0x620
   cgroup_apply_control_enable+0x190/0x390
   cgroup_mkdir+0x290/0x3d0
   kernfs_iop_mkdir+0x58/0x80
   vfs_mkdir+0x10e/0x1a0
   SyS_mkdirat+0xa8/0xd0
   SyS_mkdir+0x14/0x20
   entry_SYSCALL_64_fastpath+0x18/0xad

Add __mem_cgroup_free() which skips wb_domain_exit().  This is used by
both mem_cgroup_free() and mem_cgroup_alloc() clean up.

Fixes: 0b8f73e104285 ("mm: memcontrol: clean up alloc, online, offline, free functions")
Link: http://lkml.kernel.org/r/20170306192122.24262-1-tahsin@google.com
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-do-not-call-mem_cgroup_free-from-within-mem_cgroup_alloc mm/memcontrol.c
--- a/mm/memcontrol.c~mm-do-not-call-mem_cgroup_free-from-within-mem_cgroup_alloc
+++ a/mm/memcontrol.c
@@ -4138,17 +4138,22 @@ static void free_mem_cgroup_per_node_inf
 	kfree(memcg->nodeinfo[node]);
 }
 
-static void mem_cgroup_free(struct mem_cgroup *memcg)
+static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
 
-	memcg_wb_domain_exit(memcg);
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->stat);
 	kfree(memcg);
 }
 
+static void mem_cgroup_free(struct mem_cgroup *memcg)
+{
+	memcg_wb_domain_exit(memcg);
+	__mem_cgroup_free(memcg);
+}
+
 static struct mem_cgroup *mem_cgroup_alloc(void)
 {
 	struct mem_cgroup *memcg;
@@ -4199,7 +4204,7 @@ static struct mem_cgroup *mem_cgroup_all
 fail:
 	if (memcg->id.id > 0)
 		idr_remove(&mem_cgroup_idr, memcg->id.id);
-	mem_cgroup_free(memcg);
+	__mem_cgroup_free(memcg);
 	return NULL;
 }
 
_

Patches currently in -mm which might be from tahsin@google.com are


