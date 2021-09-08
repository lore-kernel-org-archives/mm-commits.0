Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44290C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3034A61163
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243156AbhIHDB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347430AbhIHDBy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB5BB61153;
        Wed,  8 Sep 2021 03:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070039;
        bh=evux1MfxWkz2MP+CrNH1Sz60vV/y+EXApF3wQBGytr8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pSSuMOoX8fJkDasbADY0PIDO+zmo9TK4e9Jc2KhhzfTr2pW4HRQmKVoSdMfoSpVHt
         XshyoL/3GB8ExW+WJ0Ldlqr7SgVSY4/ptmUDtqsD5U41rMz7pvrvfFx84cZlUHvYVI
         NWWmIkNVbVD9w5M+htt1mjb57b8nj5Y3cqH/dljA=
Date:   Tue, 07 Sep 2021 20:00:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, itazur@amazon.com, kuniyu@amazon.co.jp,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 140/147] pid: cleanup the stale comment mentioning
 pidmap_init().
Message-ID: <20210908030038.dWCH1ffAI%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Takahiro Itazuri <itazur@amazon.com>
Subject: pid: cleanup the stale comment mentioning pidmap_init().

pidmap_init() has already been replaced with pid_idr_init() in the commit
95846ecf9dac ("pid: replace pid bitmap implementation with IDR API"). 
Cleanup the stale comment which still mentions it.

Link: https://lkml.kernel.org/r/20210714120713.19825-1-itazur@amazon.com
Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/threads.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/threads.h~pid-cleanup-the-stale-comment-mentioning-pidmap_init
+++ a/include/linux/threads.h
@@ -38,7 +38,7 @@
  * Define a minimum number of pids per cpu.  Heuristically based
  * on original pid max of 32k for 32 cpus.  Also, increase the
  * minimum settable value for pid_max on the running system based
- * on similar defaults.  See kernel/pid.c:pidmap_init() for details.
+ * on similar defaults.  See kernel/pid.c:pid_idr_init() for details.
  */
 #define PIDS_PER_CPU_DEFAULT	1024
 #define PIDS_PER_CPU_MIN	8
_
