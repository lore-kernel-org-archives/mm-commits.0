From: akpm@linux-foundation.org
Subject: + cpuset-avoid-unnecessary-sched-domains-rebuilding.patch added to -mm tree
Date: Wed, 16 Jul 2008 01:59:26 -0700
Message-ID: <200807160859.m6G8xQTB015679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbYGPJAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 05:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, pj@sgi.com, seto.hidetoshi@jp.fujitsu.com


The patch titled
     cpuset: avoid unnecessary sched domains rebuilding
has been added to the -mm tree.  Its filename is
     cpuset-avoid-unnecessary-sched-domains-rebuilding.patch

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
Subject: cpuset: avoid unnecessary sched domains rebuilding
From: Li Zefan <lizf@cn.fujitsu.com>

When changing 'sched_relax_domain_level', don't rebuild sched domains if
'cpus' is empty or 'sched_load_balance' is not set.

Also make the comments of rebuild_sched_domains() more readable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN kernel/cpuset.c~cpuset-avoid-unnecessary-sched-domains-rebuilding kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-avoid-unnecessary-sched-domains-rebuilding
+++ a/kernel/cpuset.c
@@ -496,11 +496,16 @@ update_domain_attr(struct sched_domain_a
 /*
  * rebuild_sched_domains()
  *
- * If the flag 'sched_load_balance' of any cpuset with non-empty
- * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
- * which has that flag enabled, or if any cpuset with a non-empty
- * 'cpus' is removed, then call this routine to rebuild the
- * scheduler's dynamic sched domains.
+ * This routine will be called to rebuild the scheduler's dynamic
+ * sched domains:
+ * - if the flag 'sched_load_balance' of any cpuset with non-empty
+ *   'cpus' changes,
+ * - or if the 'cpus' allowed changes in any cpuset which has that
+ *   flag enabled,
+ * - or if the 'sched_relax_domain_level' of any cpuset which has
+ *   that flag enabled and with non-empty 'cpus' changes,
+ * - or if any cpuset with non-empty 'cpus' is removed,
+ * - or if a cpu gets offlined.
  *
  * This routine builds a partial partition of the systems CPUs
  * (the set of non-overlappping cpumask_t's in the array 'part'
@@ -1074,7 +1079,8 @@ static int update_relax_domain_level(str
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
-		rebuild_sched_domains();
+		if (!cpus_empty(cs->cpus_allowed) && is_sched_load_balance(cs))
+			rebuild_sched_domains();
 	}
 
 	return 0;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
call_usermodehelper-increase-reliability.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch
ext3-kill-2-useless-magic-numbers.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-fix.patch
devcgroup-code-cleanup.patch
devcgroup-code-cleanup-fix.patch
devcgroup-code-cleanup-fix-fix.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
cpuset-avoid-unnecessary-sched-domains-rebuilding.patch

