From: akpm@linux-foundation.org
Subject: + ia64-use-goto-to-jump-out-do-while_each_thread.patch added to -mm tree
Date: Thu, 03 Apr 2008 12:35:37 -0700
Message-ID: <200804031935.m33JZbMO018818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762100AbYDCTfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 15:35:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, tony.luck@intel.com


The patch titled
     ia64: use goto to jump out do/while_each_thread
has been added to the -mm tree.  Its filename is
     ia64-use-goto-to-jump-out-do-while_each_thread.patch

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
Subject: ia64: use goto to jump out do/while_each_thread
From: Li Zefan <lizf@cn.fujitsu.com>

do_each_thread/while_each_thread is a double loop, so should use 'goto' rather
than 'break' to break out the loop.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~ia64-use-goto-to-jump-out-do-while_each_thread arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~ia64-use-goto-to-jump-out-do-while_each_thread
+++ a/arch/ia64/kernel/perfmon.c
@@ -4204,10 +4204,10 @@ pfm_check_task_exist(pfm_context_t *ctx)
 	do_each_thread (g, t) {
 		if (t->thread.pfm_context == ctx) {
 			ret = 0;
-			break;
+			goto out;
 		}
 	} while_each_thread (g, t);
-
+out:
 	read_unlock(&tasklist_lock);
 
 	DPRINT(("pfm_check_task_exist: ret=%d ctx=%p\n", ret, ctx));
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

ia64-use-goto-to-jump-out-do-while_each_thread.patch
sctp-fix-wrong-debug-counting-of-datamsg.patch
sctp-fix-wrong-debug-counting-of-bind_bucket.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch

