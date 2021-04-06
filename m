Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338E3C433ED
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 02:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DACDD6139F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 02:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhDFCWI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 22:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238828AbhDFCWH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Apr 2021 22:22:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B995F6135D;
        Tue,  6 Apr 2021 02:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617675720;
        bh=gAJsU8hkyT/HmWbrG3DT11nEKY4fdAhebiEAMWI65F4=;
        h=Date:From:To:Subject:From;
        b=fpM68aaD3X1TX6gHs2HYevjIXNemmk6rAgrbPpZ7R0xWvGvFDOVeGBexKz3K0x+xu
         tBfZDvQ7D/w4RZS/KSz76WhZcZ0Q5Nd75K+XzeVGAzvR1GfpbuvVp3mYNbphEFrFzY
         gtxDgpVd13+DfVulnWsxt9TvARokgB8xWnG2vcps=
Date:   Mon, 05 Apr 2021 19:22:00 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, mm-commits@vger.kernel.org, nborisov@suse.com,
        swboyd@chromium.org
Subject:  +
 lib-percpu_counter-tame-kernel-doc-compile-warning.patch added to -mm tree
Message-ID: <20210406022200.EjVX_PxuI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/percpu_counter: tame kernel-doc compile warning
has been added to the -mm tree.  Its filename is
     lib-percpu_counter-tame-kernel-doc-compile-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-percpu_counter-tame-kernel-doc-compile-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-percpu_counter-tame-kernel-doc-compile-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alexs@kernel.org>
Subject: lib/percpu_counter: tame kernel-doc compile warning

commit 3e8f399da490 ("writeback: rework wb_[dec|inc]_stat family of
functions") add some function description of percpu_counter_add_batch. 
but the double '*' in comments means a kernel-doc format comment which
isn't right.

Since the whole file of lib/percpu_counter.c has no any other kernel-doc
format comments, we'd better to remove this incomplete one to tame the
kernel-doc warning:

lib/percpu_counter.c:83: warning: Function parameter or member 'fbc' not described in 'percpu_counter_add_batch'
lib/percpu_counter.c:83: warning: Function parameter or member 'amount' not described in 'percpu_counter_add_batch'
lib/percpu_counter.c:83: warning: Function parameter or member 'batch' not described in 'percpu_counter_add_batch'

Link: https://lkml.kernel.org/r/20210405135505.132446-1-alexs@kernel.org
Signed-off-by: Alex Shi <alexs@kernel.org>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/percpu_counter.c~lib-percpu_counter-tame-kernel-doc-compile-warning
+++ a/lib/percpu_counter.c
@@ -72,7 +72,7 @@ void percpu_counter_set(struct percpu_co
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
-/**
+/*
  * This function is both preempt and irq safe. The former is due to explicit
  * preemption disable. The latter is guaranteed by the fact that the slow path
  * is explicitly protected by an irq-safe spinlock whereas the fast patch uses
_

Patches currently in -mm which might be from alexs@kernel.org are

lib-percpu_counter-tame-kernel-doc-compile-warning.patch

