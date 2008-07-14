From: akpm@linux-foundation.org
Subject: - devcgroup-always-show-positive-major-minor-num.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:14 -0700
Message-ID: <200807141935.m6EJZEWQ023885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997AbYGNTfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     devcgroup: always show positive major/minor num
has been removed from the -mm tree.  Its filename was
     devcgroup-always-show-positive-major-minor-num.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: always show positive major/minor num
From: Li Zefan <lizf@cn.fujitsu.com>

 # echo "b $((0x7fffffff)):$((0x80000000)) rwm" > devices.allow
 # cat devices.list
 b 214748364:-21474836 rwm

though a major/minor number of 0x800000000 is meaningless, we
should not cast it to a negative value.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-always-show-positive-major-minor-num security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-always-show-positive-major-minor-num
+++ a/security/device_cgroup.c
@@ -222,7 +222,7 @@ static void devcgroup_destroy(struct cgr
 #define DEVCG_DENY 2
 #define DEVCG_LIST 3
 
-#define MAJMINLEN 10
+#define MAJMINLEN 13
 #define ACCLEN 4
 
 static void set_access(char *acc, short access)
@@ -254,7 +254,7 @@ static void set_majmin(char *str, unsign
 	if (m == ~0)
 		sprintf(str, "*");
 	else
-		snprintf(str, MAJMINLEN, "%d", m);
+		snprintf(str, MAJMINLEN, "%u", m);
 }
 
 static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
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

