From: akpm@linux-foundation.org
Subject: + devcgroup-code-cleanup.patch added to -mm tree
Date: Sat, 12 Jul 2008 22:59:17 -0700
Message-ID: <200807130559.m6D5xHX3006889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbYGMGJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:09:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     devcgroup: code cleanup
has been added to the -mm tree.  Its filename is
     devcgroup-code-cleanup.patch

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
Subject: devcgroup: code cleanup
From: Li Zefan <lizf@cn.fujitsu.com>

- clean up set_majmin()
- use simple_strtoul() to parse major/minor

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-code-cleanup security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-code-cleanup
+++ a/security/device_cgroup.c
@@ -202,7 +202,7 @@ static struct cgroup_subsys_state *devcg
 		}
 		wh->minor = wh->major = ~0;
 		wh->type = DEV_ALL;
-		wh->access = ACC_MKNOD | ACC_READ | ACC_WRITE;
+		wh->access = ACC_MASK;
 		list_add(&wh->list, &dev_cgroup->whitelist);
 	} else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
@@ -264,11 +264,10 @@ static char type_to_char(short type)
 
 static void set_majmin(char *str, unsigned m)
 {
-	memset(str, 0, MAJMINLEN);
 	if (m == ~0)
-		sprintf(str, "*");
+		strcpy(str, "*");
 	else
-		snprintf(str, MAJMINLEN, "%u", m);
+		sprintf(str, "%u", m);
 }
 
 static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
@@ -395,11 +394,7 @@ static int devcgroup_update_access(struc
 		wh.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.major = 0;
-		while (isdigit(*b)) {
-			wh.major = wh.major*10+(*b-'0');
-			b++;
-		}
+		wh.major = simple_strtoul(b, &b, 0);
 	} else {
 		return -EINVAL;
 	}
@@ -412,11 +407,7 @@ static int devcgroup_update_access(struc
 		wh.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.minor = 0;
-		while (isdigit(*b)) {
-			wh.minor = wh.minor*10+(*b-'0');
-			b++;
-		}
+		wh.minor = simple_strtoul(b, &b, 0);
 	} else {
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

devcgroup-always-show-positive-major-minor-num.patch
devcgroup-fix-permission-check-when-adding-entry-to-child-cgroup.patch
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

