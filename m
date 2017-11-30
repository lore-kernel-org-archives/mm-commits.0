From: akpm@linux-foundation.org
Subject: + mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch added to -mm tree
Date: Thu, 30 Nov 2017 12:39:58 -0800
Message-ID: <5a206c9e.5OPptvBd9wX/BnpI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdK3Uj7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:39:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom, docs: describe the cgroup-aware OOM killer
has been added to the -mm tree.  Its filename is
     mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch

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
Subject: mm, oom, docs: describe the cgroup-aware OOM killer

Document the cgroup-aware OOM killer.

Link: http://lkml.kernel.org/r/20171130152824.1591-7-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |   58 ++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff -puN Documentation/cgroup-v2.txt~mm-oom-docs-describe-the-cgroup-aware-oom-killer Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-oom-docs-describe-the-cgroup-aware-oom-killer
+++ a/Documentation/cgroup-v2.txt
@@ -48,6 +48,7 @@ v1 is available under Documentation/cgro
        5-2-1. Memory Interface Files
        5-2-2. Usage Guidelines
        5-2-3. Memory Ownership
+       5-2-4. OOM Killer
      5-3. IO
        5-3-1. IO Interface Files
        5-3-2. Writeback
@@ -1026,6 +1027,28 @@ PAGE_SIZE multiple when read back.
 	high limit is used and monitored properly, this limit's
 	utility is limited to providing the final safety net.
 
+  memory.oom_group
+
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "0".
+
+	If set, OOM killer will consider the memory cgroup as an
+	indivisible memory consumers and compare it with other memory
+	consumers by it's memory footprint.
+	If such memory cgroup is selected as an OOM victim, all
+	processes belonging to it or it's descendants will be killed.
+
+	This applies to system-wide OOM conditions and reaching
+	the hard memory limit of the cgroup and their ancestor.
+	If OOM condition happens in a descendant cgroup with it's own
+	memory limit, the memory cgroup can't be considered
+	as an OOM victim, and OOM killer will not kill all belonging
+	tasks.
+
+	Also, OOM killer respects the /proc/pid/oom_score_adj value -1000,
+	and will never kill the unkillable task, even if memory.oom_group
+	is set.
+
   memory.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
@@ -1229,6 +1252,41 @@ to be accessed repeatedly by other cgrou
 POSIX_FADV_DONTNEED to relinquish the ownership of memory areas
 belonging to the affected files to ensure correct memory ownership.
 
+OOM Killer
+~~~~~~~~~~
+
+Cgroup v2 memory controller implements a cgroup-aware OOM killer.
+It means that it treats cgroups as first class OOM entities.
+
+Under OOM conditions the memory controller tries to make the best
+choice of a victim, looking for a memory cgroup with the largest
+memory footprint, considering leaf cgroups and cgroups with the
+memory.oom_group option set, which are considered to be an indivisible
+memory consumers.
+
+By default, OOM killer will kill the biggest task in the selected
+memory cgroup. A user can change this behavior by enabling
+the per-cgroup memory.oom_group option. If set, it causes
+the OOM killer to kill all processes attached to the cgroup,
+except processes with oom_score_adj set to -1000.
+
+This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
+the memory controller considers only cgroups belonging to the sub-tree
+of the OOM'ing cgroup.
+
+The root cgroup is treated as a leaf memory cgroup, so it's compared
+with other leaf memory cgroups and cgroups with oom_group option set.
+
+If there are no cgroups with the enabled memory controller,
+the OOM killer is using the "traditional" process-based approach.
+
+Please, note that memory charges are not migrating if tasks
+are moved between different memory cgroups. Moving tasks with
+significant memory footprint may affect OOM victim selection logic.
+If it's a case, please, consider creating a common ancestor for
+the source and destination memory cgroups and enabling oom_group
+on ancestor layer.
+
 
 IO
 --
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

