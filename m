From: akpm@linux-foundation.org
Subject: - cpuset-avoid-unnecessary-sched-domains-rebuilding.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:07 -0700
Message-ID: <200807252259.m6PMx7M4003353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbYGYW75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, pj@sgi.com, seto.hidetoshi@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: avoid unnecessary sched domains rebuilding
has been removed from the -mm tree.  Its filename was
     cpuset-avoid-unnecessary-sched-domains-rebuilding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1076,7 +1081,8 @@ static int update_relax_domain_level(str
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
-		rebuild_sched_domains();
+		if (!cpus_empty(cs->cpus_allowed) && is_sched_load_balance(cs))
+			rebuild_sched_domains();
 	}
 
 	return 0;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch

