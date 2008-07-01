From: akpm@linux-foundation.org
Subject: + cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup.patch added to -mm tree
Date: Tue, 01 Jul 2008 13:24:23 -0700
Message-ID: <200807012024.m61KONDI012913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757159AbYGAUZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 16:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, menage@google.com, pj@sgi.com


The patch titled
     cgroups: document the effect of attaching PID 0 to a cgroup
has been added to the -mm tree.  Its filename is
     cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup.patch

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
Subject: cgroups: document the effect of attaching PID 0 to a cgroup
From: Li Zefan <lizf@cn.fujitsu.com>

Document that a pid of zero(0) can be used to refer to the current task
when attaching a task to a cgroup, as in the following usage:

	# echo 0 > /dev/cgroup/tasks

This is consistent with existing cpuset behavior.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/cgroups.txt~cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup Documentation/cgroups.txt
--- a/Documentation/cgroups.txt~cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup
+++ a/Documentation/cgroups.txt
@@ -390,6 +390,10 @@ If you have several tasks to attach, you
 	...
 # /bin/echo PIDn > tasks
 
+You can attach the current task by echoing 0:
+
+# /bin/echo 0 > tasks
+
 3. Kernel API
 =============
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup.patch
call_usermodehelper-increase-reliability.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch
ext3-kill-2-useless-magic-numbers.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

