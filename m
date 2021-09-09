Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034D9C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDCB1611CB
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346848AbhIIVEX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348570AbhIIVDa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 788C7611C2;
        Thu,  9 Sep 2021 21:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221338;
        bh=SyfnN2jcJ6OXRffKlZAz8AEvLABRyixl3iGeL/vZBY4=;
        h=Date:From:To:Subject:From;
        b=V9igkY5CRKSvfwNCvy3o8dqwqRJbk79htM4AHP0viXsRTGagQ4KeeDTLJPFx06ltx
         NDPU5qRqb55qM3A7hMnH2N/bBGmoleVfnl0/FxZFTsPKTbImeOjYVxW6Rc38Io2BQM
         utSsxhH96vzB17dG38fKLs7/4yFqSDxrLZJrMLjo=
Date:   Thu, 09 Sep 2021 14:02:18 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, changbin.du@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-in_irq-cleanup.patch removed from -mm tree
Message-ID: <20210909210218.1H6zHiMzN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: in_irq() cleanup
has been removed from the -mm tree.  Its filename was
     mm-in_irq-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Changbin Du <changbin.du@gmail.com>
Subject: mm: in_irq() cleanup

Replace the obsolete and ambiguos macro in_irq() with new macro
in_hardirq().

Link: https://lkml.kernel.org/r/20210813145245.86070-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[kmemleak]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c  |    2 +-
 mm/kmemleak.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c~mm-in_irq-cleanup
+++ a/mm/highmem.c
@@ -436,7 +436,7 @@ EXPORT_SYMBOL(zero_user_segments);
 
 static inline int kmap_local_idx_push(void)
 {
-	WARN_ON_ONCE(in_irq() && !irqs_disabled());
+	WARN_ON_ONCE(in_hardirq() && !irqs_disabled());
 	current->kmap_ctrl.idx += KM_INCR;
 	BUG_ON(current->kmap_ctrl.idx >= KM_MAX_IDX);
 	return current->kmap_ctrl.idx - 1;
--- a/mm/kmemleak.c~mm-in_irq-cleanup
+++ a/mm/kmemleak.c
@@ -598,7 +598,7 @@ static struct kmemleak_object *create_ob
 	object->checksum = 0;
 
 	/* task information */
-	if (in_irq()) {
+	if (in_hardirq()) {
 		object->pid = 0;
 		strncpy(object->comm, "hardirq", sizeof(object->comm));
 	} else if (in_serving_softirq()) {
_

Patches currently in -mm which might be from changbin.du@gmail.com are


