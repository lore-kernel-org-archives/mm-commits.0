Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07446C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC3A12083B
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602818018;
	bh=Bd180Skf41DEf0A9RM8mX2N5VcW/9KqVQPGxaodD4QA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hveQ78xBVRWaIbLCi2FrLgaJXeTaCYFqmvw3961pJpuYH5f9WEXooJKPOYcxVuTl0
	 BM5bQ3HhqznlZOSIN5e9VaLvcO01+qeHmryWcYcEzb5jRZoYAs4jK2TtRq35owPe2P
	 sCjbTRHFi6XMd1OABQAfO7TlfuaCMaOTp1WZqN4M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393962AbgJPDNi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393799AbgJPDNi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:13:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16BDE20789;
        Fri, 16 Oct 2020 03:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602818016;
        bh=Bd180Skf41DEf0A9RM8mX2N5VcW/9KqVQPGxaodD4QA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ORlaaxLHcVxiRPx4hYrJ+bGkODbqESr5/3gXd0pEB22TRa4xT1Dae7aNKeJiJeVrb
         iZHob31xYeeDMa8IlBFCohSpPi2rCVVjMvd91G1YBBaxBBeFOZmaX/Bu+6qIGLF/eA
         4LEQ7ct4ayW5zGWbwCHPEEHJyP1b+SWV5A4+MPx8=
Date:   Thu, 15 Oct 2020 20:13:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org,
        lenaptr@google.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 152/156] sched.h: drop in_ubsan field when UBSAN
 is in trap mode
Message-ID: <20201016031335.ZUCgrO3VE%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Elena Petrova <lenaptr@google.com>
Subject: sched.h: drop in_ubsan field when UBSAN is in trap mode

in_ubsan field of task_struct is only used in lib/ubsan.c, which in its
turn is used only `ifneq ($(CONFIG_UBSAN_TRAP),y)`.

Removing unnecessary field from a task_struct will help preserve the ABI
between vanilla and CONFIG_UBSAN_TRAP'ed kernels.  In particular, this
will help enabling bounds sanitizer transparently for Android's GKI.

Link: https://lkml.kernel.org/r/20200910134802.3160311-1-lenaptr@google.com
Signed-off-by: Elena Petrova <lenaptr@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/sched.h~schedh-drop-in_ubsan-field-when-ubsan-is-in-trap-mode
+++ a/include/linux/sched.h
@@ -1013,7 +1013,7 @@ struct task_struct {
 	struct held_lock		held_locks[MAX_LOCK_DEPTH];
 #endif
 
-#ifdef CONFIG_UBSAN
+#if defined(CONFIG_UBSAN) && !defined(CONFIG_UBSAN_TRAP)
 	unsigned int			in_ubsan;
 #endif
 
_
