From: akpm@linux-foundation.org
Subject: [merged]
 oom-warn-if-we-go-oom-for-higher-order-and-compaction-is-disabled.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:44:33 -0700
Message-ID: <57fc19d1.SSZ3tOW7/iGPJh7a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36763 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbcJJWoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: warn if we go OOM for higher order and compaction is disabled
has been removed from the -mm tree.  Its filename was
     oom-warn-if-we-go-oom-for-higher-order-and-compaction-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: oom: warn if we go OOM for higher order and compaction is disabled

Since the lumpy reclaim is gone there is no source of higher order pages
if CONFIG_COMPACTION=n except for the order-0 pages reclaim which is
unreliable for that purpose to say the least.  Hitting an OOM for !costly
higher order requests is therefore all not that hard to imagine.  We are
trying hard to not invoke OOM killer as much as possible but there is
simply no reliable way to detect whether more reclaim retries make sense.

Disabling COMPACTION is not widespread but it seems that some users might
have disable the feature without realizing full consequences (mostly along
with disabling THP because compaction used to be THP mainly thing).  This
patch just adds a note if the OOM killer was triggered by higher order
request with compaction disabled.  This will help us identifying possible
misconfiguration right from the oom report which is easier than to always
keep in mind that somebody might have disabled COMPACTION without a good
reason.

Link: http://lkml.kernel.org/r/20160830111632.GD23963@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/oom_kill.c~oom-warn-if-we-go-oom-for-higher-order-and-compaction-is-disabled mm/oom_kill.c
--- a/mm/oom_kill.c~oom-warn-if-we-go-oom-for-higher-order-and-compaction-is-disabled
+++ a/mm/oom_kill.c
@@ -406,6 +406,8 @@ static void dump_header(struct oom_contr
 	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
 		current->signal->oom_score_adj);
+	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
+		pr_warn("COMPACTION is disabled!!!\n");
 
 	cpuset_print_current_mems_allowed();
 	dump_stack();
_

Patches currently in -mm which might be from mhocko@suse.com are

fs-use-mapping_set_error-instead-of-opencoded-set_bit.patch
mm-split-gfp_mask-and-mapping-flags-into-separate-fields.patch

