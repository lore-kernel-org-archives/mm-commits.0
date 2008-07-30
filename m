From: akpm@linux-foundation.org
Subject: - cpuset-fix-wrong-calculation-of-relax-domain-level.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:22 -0700
Message-ID: <200807301914.m6UJEMqA010901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbYG3TQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: fix wrong calculation of relax domain level
has been removed from the -mm tree.  Its filename was
     cpuset-fix-wrong-calculation-of-relax-domain-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: fix wrong calculation of relax domain level
From: Li Zefan <lizf@cn.fujitsu.com>

When multiple cpusets are overlapping in their 'cpus' and hence they
form a single sched domain, the largest sched_relax_domain_level among
those should be used. But when top_cpuset's sched_load_balance is
set, its sched_relax_domain_level is used regardless other sub-cpusets'.

This patch fixes it by walking the cpuset hierarchy to find the largest
sched_relax_domain_level.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpuset.c~cpuset-fix-wrong-calculation-of-relax-domain-level kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-wrong-calculation-of-relax-domain-level
+++ a/kernel/cpuset.c
@@ -616,7 +616,7 @@ void rebuild_sched_domains(void)
 		dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
 		if (dattr) {
 			*dattr = SD_ATTR_INIT;
-			update_domain_attr(dattr, &top_cpuset);
+			update_domain_attr_tree(dattr, &top_cpuset);
 		}
 		*doms = top_cpuset.cpus_allowed;
 		goto rebuild;
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

