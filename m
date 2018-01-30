From: akpm@linux-foundation.org
Subject: + mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
 added to -mm tree
Date: Tue, 30 Jan 2018 12:20:46 -0800
Message-ID: <5a70d39e.sEOwTuS5n0sAUJ6E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751556AbeA3UUr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jan 2018 15:20:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, memcg: clarify root memcg oom accounting
has been added to the -mm tree.  Its filename is
     mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: oom, memcg: clarify root memcg oom accounting

David Rientjes has pointed out that the current way how the root memcg is
accounted for the cgroup aware OOM killer is undocumented.  Unlike regular
cgroups there is no accounting going on in the root memcg (mostly for
performance reasons).  Therefore we are suming up oom_badness of its
tasks.  This might result in an over accounting because of the
oom_score_adj setting.  Document this for now.

Link: http://lkml.kernel.org/r/20180130122011.GB21609@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v2.txt |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroup-v2.txt~mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2 Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt~mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2
+++ a/Documentation/cgroup-v2.txt
@@ -1290,8 +1290,15 @@ This affects both system- and cgroup-wid
 the memory controller considers only cgroups belonging to the sub-tree
 of the OOM'ing cgroup.
 
-The root cgroup is treated as a leaf memory cgroup, so it's compared
-with other leaf memory cgroups and cgroups with oom_group option set.
+Leaf cgroups and cgroups with oom_group option set are compared based
+on their cumulative memory usage. The root cgroup is treated as a
+leaf memory cgroup as well, so it's compared with other leaf memory
+cgroups. Due to internal implementation restrictions the size of
+the root cgroup is a cumulative sum of oom_badness of all its tasks
+(in other words oom_score_adj of each task is obeyed). Relying on
+oom_score_adj (appart from OOM_SCORE_ADJ_MIN) can lead to over or
+underestimating of the root cgroup consumption and it is therefore
+discouraged. This might change in the future, though.
 
 If there are no cgroups with the enabled memory controller,
 the OOM killer is using the "traditional" process-based approach.
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
mm-unclutter-thp-migration.patch
mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch
mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch
mm-hugetlb-further-simplify-hugetlb-allocation-api.patch
hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch
hugetlb-mbind-fall-back-to-default-policy-if-vma-is-null.patch
mm-memory_hotplug-fix-memmap-initialization.patch

