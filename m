From: akpm@linux-foundation.org
Subject: +
 mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch added
 to -mm tree
Date: Thu, 30 Nov 2017 12:39:55 -0800
Message-ID: <5a206c9b.k8vVhyRzYpgE1zv3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdK3Uj4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:39:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: add cgroup v2 mount option for cgroup-aware OOM killer
has been added to the -mm tree.  Its filename is
     mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm, oom: add cgroup v2 mount option for cgroup-aware OOM killer

Add a "groupoom" cgroup v2 mount option to enable the cgroup-aware OOM
killer.  If not set, the OOM selection is performed in a "traditional"
per-process way.

The behavior can be changed dynamically by remounting the cgroupfs.

Link: http://lkml.kernel.org/r/20171130152824.1591-6-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup-defs.h |    5 +++++
 kernel/cgroup/cgroup.c      |   10 ++++++++++
 mm/memcontrol.c             |    3 +++
 3 files changed, 18 insertions(+)

diff -puN include/linux/cgroup-defs.h~mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer include/linux/cgroup-defs.h
--- a/include/linux/cgroup-defs.h~mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer
+++ a/include/linux/cgroup-defs.h
@@ -81,6 +81,11 @@ enum {
 	 * Enable cpuset controller in v1 cgroup to use v2 behavior.
 	 */
 	CGRP_ROOT_CPUSET_V2_MODE = (1 << 4),
+
+	/*
+	 * Enable cgroup-aware OOM killer.
+	 */
+	CGRP_GROUP_OOM = (1 << 5),
 };
 
 /* cftype->flags */
diff -puN kernel/cgroup/cgroup.c~mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer kernel/cgroup/cgroup.c
--- a/kernel/cgroup/cgroup.c~mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer
+++ a/kernel/cgroup/cgroup.c
@@ -1731,6 +1731,9 @@ static int parse_cgroup_root_flags(char
 		if (!strcmp(token, "nsdelegate")) {
 			*root_flags |= CGRP_ROOT_NS_DELEGATE;
 			continue;
+		} else if (!strcmp(token, "groupoom")) {
+			*root_flags |= CGRP_GROUP_OOM;
+			continue;
 		}
 
 		pr_err("cgroup2: unknown option \"%s\"\n", token);
@@ -1747,6 +1750,11 @@ static void apply_cgroup_root_flags(unsi
 			cgrp_dfl_root.flags |= CGRP_ROOT_NS_DELEGATE;
 		else
 			cgrp_dfl_root.flags &= ~CGRP_ROOT_NS_DELEGATE;
+
+		if (root_flags & CGRP_GROUP_OOM)
+			cgrp_dfl_root.flags |= CGRP_GROUP_OOM;
+		else
+			cgrp_dfl_root.flags &= ~CGRP_GROUP_OOM;
 	}
 }
 
@@ -1754,6 +1762,8 @@ static int cgroup_show_options(struct se
 {
 	if (cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
 		seq_puts(seq, ",nsdelegate");
+	if (cgrp_dfl_root.flags & CGRP_GROUP_OOM)
+		seq_puts(seq, ",groupoom");
 	return 0;
 }
 
diff -puN mm/memcontrol.c~mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer
+++ a/mm/memcontrol.c
@@ -2869,6 +2869,9 @@ bool mem_cgroup_select_oom_victim(struct
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
 
+	if (!(cgrp_dfl_root.flags & CGRP_GROUP_OOM))
+		return false;
+
 	if (oc->memcg)
 		root = oc->memcg;
 	else
_

Patches currently in -mm which might be from guro@fb.com are

mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch
mm-oom-refactor-the-oom_kill_process-function.patch
mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch
mm-oom-cgroup-aware-oom-killer.patch
mm-oom-introduce-memoryoom_group.patch
mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch
cgroup-list-groupoom-in-cgroup-features.patch

