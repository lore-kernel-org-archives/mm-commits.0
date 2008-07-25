From: akpm@linux-foundation.org
Subject: - memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:25:25 -0700
Message-ID: <200807250025.m6P0PPEd014012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbYGYAZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:25:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@in.ibm.com, ebiederm@xmission.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@val


The patch titled
     memcg: mem_cgroup_shrink_usage css_put
has been removed from the -mm tree.  Its filename was
     memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch

This patch was dropped because it was folded into memcg-helper-function-for-relcaim-from-shmem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: mem_cgroup_shrink_usage css_put
From: Hugh Dickins <hugh@veritas.com>

mem_cgroup_shrink_usage makes no charge: balance its css_get with a css_put.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put
+++ a/mm/memcontrol.c
@@ -800,6 +800,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
 	} while (!progress && --retry);
 
+	css_put(&mem->css);
 	if (!retry)
 		return -ENOMEM;
 	return 0;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exec-remove-some-includes.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch

