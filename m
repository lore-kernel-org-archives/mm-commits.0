From: akpm@linux-foundation.org
Subject: - devcgroup-fix-odd-behaviour-when-writing-a-to-devicesallow.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:05:30 -0700
Message-ID: <200807070305.m6735U1V004824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753557AbYGGDGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, sds@tycho.nsa.gov, serue@us.ibm.com, xemul@openvz.or


The patch titled
     devcgroup: fix odd behaviour when writing 'a' to devices.allow
has been removed from the -mm tree.  Its filename was
     devcgroup-fix-odd-behaviour-when-writing-a-to-devicesallow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: fix odd behaviour when writing 'a' to devices.allow
From: Li Zefan <lizf@cn.fujitsu.com>

 # cat /devcg/devices.list
 a *:* rwm
 # echo a > devices.allow
 # cat /devcg/devices.list
 a *:* rwm
 a 0:0 rwm

This is odd and maybe confusing.  With this patch, writing 'a' to
devices.allow will add 'a *:* rwm' to the whitelist.

Also a few fixes and updates to the document.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/devices.txt |    8 ++++++--
 security/device_cgroup.c              |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN Documentation/controllers/devices.txt~devcgroup-fix-odd-behaviour-when-writing-a-to-devicesallow Documentation/controllers/devices.txt
--- a/Documentation/controllers/devices.txt~devcgroup-fix-odd-behaviour-when-writing-a-to-devicesallow
+++ a/Documentation/controllers/devices.txt
@@ -13,7 +13,7 @@ either an integer or * for all.  Access 
 The root device cgroup starts with rwm to 'all'.  A child device
 cgroup gets a copy of the parent.  Administrators can then remove
 devices from the whitelist or add new entries.  A child cgroup can
-never receive a device access which is denied its parent.  However
+never receive a device access which is denied by its parent.  However
 when a device access is removed from a parent it will not also be
 removed from the child(ren).
 
@@ -29,7 +29,11 @@ allows cgroup 1 to read and mknod the de
 
 	echo a > /cgroups/1/devices.deny
 
-will remove the default 'a *:* mrw' entry.
+will remove the default 'a *:* rwm' entry. Doing
+
+	echo a > /cgroups/1/devices.allow
+
+will add the 'a *:* rwm' entry to the whitelist.
 
 3. Security
 
diff -puN security/device_cgroup.c~devcgroup-fix-odd-behaviour-when-writing-a-to-devicesallow security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-fix-odd-behaviour-when-writing-a-to-devicesallow
+++ a/security/device_cgroup.c
@@ -382,6 +382,8 @@ static ssize_t devcgroup_access_write(st
 	case 'a':
 		wh.type = DEV_ALL;
 		wh.access = ACC_MASK;
+		wh.major = ~0;
+		wh.minor = ~0;
 		goto handle;
 	case 'b':
 		wh.type = DEV_BLOCK;
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

