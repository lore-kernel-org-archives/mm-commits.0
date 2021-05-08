Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2C4C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0F56142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhEHWyH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWyE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9614E61424;
        Sat,  8 May 2021 22:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514382;
        bh=PHPwn+keHt3GZ16gorg2SDtE5D45Tg3GMbKF22ZjjmY=;
        h=Date:From:To:Subject:From;
        b=BmXOgyZcL9ttMhn3vhsiYfLJLpji09B5GoOia27ytoJMTHWoOpPArPMBTV/uWDPXB
         P6xajva2CUQFy4u3CpV2e/pmvdYS+t3KuWd2QPCuFiVD0QYaGpnzWD1kiW/+STThsK
         7KxiRC7WXskXwj2QKSjYObn+k1C/9GvMHAtPW3xc=
Date:   Sat, 08 May 2021 15:53:02 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, mm-commits@vger.kernel.org, nborisov@suse.com,
        swboyd@chromium.org
Subject:  [merged]
 lib-percpu_counter-tame-kernel-doc-compile-warning.patch removed from -mm
 tree
Message-ID: <20210508225302.CdaAvL_aZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/percpu_counter: tame kernel-doc compile warning
has been removed from the -mm tree.  Its filename was
     lib-percpu_counter-tame-kernel-doc-compile-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


