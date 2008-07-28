From: akpm@linux-foundation.org
Subject: + cpuset-fix-wrong-calculation-of-relax-domain-level.patch added to -mm tree
Date: Sun, 27 Jul 2008 20:27:02 -0700
Message-ID: <200807280327.m6S3R22k017939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbYG1D1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 23:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, clg@fr.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, menage@google.com, pj@sgi.com


The patch titled
     cpuset: fix wrong calculation of relax domain level
has been added to the -mm tree.  Its filename is
     cpuset-fix-wrong-calculation-of-relax-domain-level.patch

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
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpuset.c~cpuset-fix-wrong-calculation-of-relax-domain-level kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-wrong-calculation-of-relax-domain-level
+++ a/kernel/cpuset.c
@@ -614,7 +614,7 @@ void rebuild_sched_domains(void)
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
cgroup-fix-possible-memory-leak.patch
cgroup-remove-duplicate-code-in-allocate_cg_link.patch
cgroup-uninline-cgroup_has_css_refs.patch
memcg-remove-redundant-check-in-move_task.patch
cpuset-a-bit-cleanup-for-scan_for_empty_cpusets.patch
cpuset-clean-up-cpuset-hierarchy-traversal-code.patch
cpuset-speed-up-sched-domain-partition.patch
cpuset-fix-wrong-calculation-of-relax-domain-level.patch
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

