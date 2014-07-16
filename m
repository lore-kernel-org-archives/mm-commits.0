From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-deprecate-memoryforce_empty-knob.patch
 removed from -mm tree
Date: Wed, 16 Jul 2014 13:45:41 -0700
Message-ID: <53c6e475.mqECx6nWmE6XFzHB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:53346 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaGPUpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 16:45:42 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so408089iec.5
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 13:45:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, gthelen@google.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: deprecate memory.force_empty knob
has been removed from the -mm tree.  Its filename was
     memcg-deprecate-memoryforce_empty-knob.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: deprecate memory.force_empty knob

force_empty has been introduced primarily to drop memory before it gets
reparented on the group removal.  This alone doesn't sound fully justified
because reparented pages which are not in use can be reclaimed also later
when there is a memory pressure on the parent level.

Mark the knob CFTYPE_INSANE which tells the cgroup core that it shouldn't
create the knob with the experimental sane_behavior.  Other users will get
informed about the deprecation and asked to tell us more because I do not
expect most users will use sane_behavior cgroups mode very soon.

Anyway I expect that most users will be simply cgroup remove handlers
which do that since ever without having any good reason for it.

If somebody really cares because reparented pages, which would be dropped
otherwise, push out more important ones then we should fix the reparenting
code and put pages to the tail.

[akpm@linux-foundation.org: s/pr_info/pr_info_once/, fix garbled printk text]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    3 +++
 mm/memcontrol.c                  |    5 +++++
 2 files changed, 8 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-deprecate-memoryforce_empty-knob Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-deprecate-memoryforce_empty-knob
+++ a/Documentation/cgroups/memory.txt
@@ -473,6 +473,9 @@ About use_hierarchy, see Section 6.
   write will still return success. In this case, it is expected that
   memory.kmem.usage_in_bytes == memory.usage_in_bytes.
 
+  Please note that this knob is considered deprecated and will be removed
+  in the future.
+
   About use_hierarchy, see Section 6.
 
 5.2 stat file
diff -puN mm/memcontrol.c~memcg-deprecate-memoryforce_empty-knob mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-deprecate-memoryforce_empty-knob
+++ a/mm/memcontrol.c
@@ -4035,6 +4035,10 @@ static ssize_t mem_cgroup_force_empty_wr
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
+	pr_info_once("%s (%d): memory.force_empty is deprecated and will be "
+		     "removed.  Let us know if it is needed in your usecase at "
+		     "linux-mm@kvack.org\n",
+		     current->comm, task_pid_nr(current));
 	return mem_cgroup_force_empty(memcg) ?: nbytes;
 }
 
@@ -5211,6 +5215,7 @@ static struct cftype mem_cgroup_files[]
 	},
 	{
 		.name = "force_empty",
+		.flags = CFTYPE_INSANE,
 		.write = mem_cgroup_force_empty_write,
 	},
 	{
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
kbuild-explain-stack-protector-strong-config-logic.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
linux-next.patch

