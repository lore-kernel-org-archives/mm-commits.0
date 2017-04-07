From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix.patch removed from -mm tree
Date: Fri, 07 Apr 2017 16:02:47 -0700
Message-ID: <58e81a97.bG8/EdYBz0E8nWa0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752766AbdDGXCs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 19:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix
has been removed from the -mm tree.  Its filename was
     mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix.patch

This patch was dropped because it was folded into mm-move-pcp-and-lru-pcp-drainging-into-single-wq.patch

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix

> Should the workqueue also have been renamed to mm_percpu_wq?

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmstat.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-move-pcp-and-lru-pcp-drainging-into-single-wq-fix
+++ a/mm/vmstat.c
@@ -1766,11 +1766,10 @@ void __init init_mm_internals(void)
 {
 	int ret __maybe_unused;
 
-	mm_percpu_wq = alloc_workqueue("vmstat",
+	mm_percpu_wq = alloc_workqueue("mm_percpu_wq",
 				       WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
 
 #ifdef CONFIG_SMP
