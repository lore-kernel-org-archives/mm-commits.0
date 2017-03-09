From: akpm@linux-foundation.org
Subject: + mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix.patch
 added to -mm tree
Date: Thu, 09 Mar 2017 12:04:25 -0800
Message-ID: <58c1b549.XGAIUn3USu84CtjO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdCIUE1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 15:04:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix
has been added to the -mm tree.  Its filename is
     mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix

> Should the workqueue also have been renamed to mm_percpu_wq?

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix
+++ a/mm/vmstat.c
@@ -1766,7 +1766,7 @@ static int __init setup_vmstat(void)
 {
 	int ret __maybe_unused;
 
-	mm_percpu_wq = alloc_workqueue("vmstat", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
+	mm_percpu_wq = alloc_workqueue("mm_percpu_wq", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
 
 #ifdef CONFIG_SMP
 	ret = cpuhp_setup_state_nocalls(CPUHP_MM_VMSTAT_DEAD, "mm/vmstat:dead",
_

Patches currently in -mm which might be from mhocko@kernel.org are

proc-show-madv_free-pages-info-in-smaps-fix.patch
mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix.patch

