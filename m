From: akpm@linux-foundation.org
Subject: - cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:30:07 -0700
Message-ID: <200807250030.m6P0U8f2014251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYGYAaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, miaox@cn.fujitsu.com, pj@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: restructure the function update_cpumask() and update_nodemask() fix
has been removed from the -mm tree.  Its filename was
     cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch

This patch was dropped because it was folded into cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: restructure the function update_cpumask() and update_nodemask() fix
From: Li Zefan <lizf@cn.fujitsu.com>

>> kernel/cpuset.c: In function 'cpuset_write_resmask':
>> kernel/cpuset.c:1374: warning: passing argument 2 of 'update_nodemask' discards qualifiers from pointer target type
>>
>> Did you not get this warning also?
>>
>> I don't know how to fix it.  cftype.write_string() requires a const
>> char* in the third arg, but we then go on to call update_nodemask(),
>> which does a strstrip() on this allegedly-const char array.
>>
>
> That strstrip() should be removed. because cgroup_write_string() already strstrip()ed
> the buffer. Paul M's original patch removed that 2 strstrip()s in cpuset.c.
>

Here is the patch:

Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix
+++ a/kernel/cpuset.c
@@ -1013,7 +1013,7 @@ done:
  * lock each such tasks mm->mmap_sem, scan its vma's and rebind
  * their mempolicies to the cpusets new mems_allowed.
  */
-static int update_nodemask(struct cpuset *cs, char *buf)
+static int update_nodemask(struct cpuset *cs, const char *buf)
 {
 	struct cpuset trialcs;
 	nodemask_t oldmem;
@@ -1034,7 +1034,6 @@ static int update_nodemask(struct cpuset
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have memory.
 	 */
-	buf = strstrip(buf);
 	if (!*buf) {
 		nodes_clear(trialcs.mems_allowed);
 	} else {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
call_usermodehelper-increase-reliability.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
ext3-kill-2-useless-magic-numbers.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
devcgroup-code-cleanup.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
cpuset-avoid-unnecessary-sched-domains-rebuilding.patch

