From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch removed from -mm tree
Date: Thu, 07 Jan 2016 15:50:19 -0800
Message-ID: <568ef9bb.eOxiZjeu8conH7Xb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbcAGXuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 18:50:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: print symbolic gfp_flags in oom warning
has been removed from the -mm tree.  Its filename was
     mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch

This patch was dropped because an updated version will be merged

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
Acked-by: Michal Hocko <mhocko@suse.com>
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

mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

