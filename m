From: akpm@linux-foundation.org
Subject: + mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch added to
 -mm tree
Date: Tue, 24 Nov 2015 14:45:32 -0800
Message-ID: <5654e88c.J0yFHMDTb66i/q92%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbbKXWpd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 17:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: print symbolic gfp_flags in oom warning
has been added to the -mm tree.  Its filename is
     mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, oom: print symbolic gfp_flags in oom warning

It would be useful to translate gfp_flags into string representation when
printing in case of an OOM, especially as the flags have been undergoing
some changes recently and the script ./scripts/gfp-translate needs a
matching source version to be accurate.

Example output:

a.out invoked oom-killer: order=0, oom_score_adj=0, gfp_mask=0x24280ca(GFP_HIGHUSER_MOVABLE|GFP_ZERO)

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-print-symbolic-gfp_flags-in-oom-warning mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-print-symbolic-gfp_flags-in-oom-warning
+++ a/mm/oom_kill.c
@@ -386,10 +386,12 @@ static void dump_tasks(struct mem_cgroup
 static void dump_header(struct oom_control *oc, struct task_struct *p,
 			struct mem_cgroup *memcg)
 {
-	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
-		"oom_score_adj=%hd\n",
-		current->comm, oc->gfp_mask, oc->order,
-		current->signal->oom_score_adj);
+	pr_warning("%s invoked oom-killer: order=%d, oom_score_adj=%hd, "
+			"gfp_mask=0x%x",
+		current->comm, oc->order, current->signal->oom_score_adj,
+		oc->gfp_mask);
+	dump_gfpflag_names(oc->gfp_mask);
+
 	cpuset_print_current_mems_allowed();
 	dump_stack();
 	if (memcg)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch

