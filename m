From: akpm@linux-foundation.org
Subject: + memcg-remove-redundant-initialization-in-mem_cgroup_create.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:35:20 -0700
Message-ID: <200804272035.m3RKZKpt023609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbYD0Uf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: remove redundant initialization in mem_cgroup_create()
has been added to the -mm tree.  Its filename is
     memcg-remove-redundant-initialization-in-mem_cgroup_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove redundant initialization in mem_cgroup_create()
From: Li Zefan <lizf@cn.fujitsu.com>

*mem has been zeroed, that means mem->info has already been filled with 0.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-initialization-in-mem_cgroup_create mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-initialization-in-mem_cgroup_create
+++ a/mm/memcontrol.c
@@ -1024,8 +1024,6 @@ mem_cgroup_create(struct cgroup_subsys *
 
 	res_counter_init(&mem->res);
 
-	memset(&mem->info, 0, sizeof(mem->info));
-
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
 			goto free_out;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch
oom_kill-remove-unused-parameter-in-badness.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
memcg-remove-redundant-initialization-in-mem_cgroup_create.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

