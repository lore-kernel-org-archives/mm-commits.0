Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9916C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C35F160FDA
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347462AbhIBVQ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347450AbhIBVQ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:16:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8214A6102A;
        Thu,  2 Sep 2021 21:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617327;
        bh=cOhaCYYpvPdGfa5IVOtVuERu0X5+jdFlqxBDhJcWYpQ=;
        h=Date:From:To:Subject:From;
        b=mUaRZJKDH7Pvk207f+9D2fLAQk+/0TpN3hvlWMbb23O0AxdzXLHViAGCxlGZnn31D
         qcDNnPIbydldwOp5llRgo4ds3wZLytOd2WqK/4qaQrlnndkhxLKAEfbpIy9UngB6PO
         +AcotiinwPXOQvSw+AIiC6/is+BlTMTSUGuNTbj0=
Date:   Thu, 02 Sep 2021 14:15:27 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anton@ozlabs.org,
        benh@kernel.crashing.org, luto@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, paulus@ozlabs.org,
        rdunlap@infradead.org
Subject:  [folded-merged]
 lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch removed
 from -mm tree
Message-ID: <20210902211527.5MvyUaQjg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix
has been removed from the -mm tree.  Its filename was
     lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch

This patch was dropped because it was folded into lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix

fix comment

Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/sched/mm.h~lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix
+++ a/include/linux/sched/mm.h
@@ -63,7 +63,8 @@ static inline void mmdrop_lazy_tlb(struc
 	} else {
 		/*
 		 * mmdrop_lazy_tlb must provide a full memory barrier, see the
-		 * membarrier comment finish_task_switch which relies on this.
+		 * membarrier comment in finish_task_switch which relies on
+		 * this.
 		 */
 		smp_mb();
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
checkpatch-improve-git_commit_id-test-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

