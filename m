Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E04BC12002
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 413D9610A7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhGNWgL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhGNWgL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 18:36:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E1D613C2;
        Wed, 14 Jul 2021 22:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626301998;
        bh=zUCtQy7t0OocPAcCU9hFB35JsAAYdrgcZG/MLia5DWc=;
        h=Date:From:To:Subject:From;
        b=jM7OkLbPAtMnxSGXvEIbOako5UAMY2aLqFbRZ93ZETMjjdgN9PxiyhJSgjYQmrmWq
         3mCJoBH2bx0I024KeWmwWfzZ1X1HzL2Akg9y7y3yF5IlBAyXs02795MK3zzpSZlSoV
         jqAbWLvuWysNhTUXFDqjmlk+wqcyaHHGdRztb++k=
Date:   Wed, 14 Jul 2021 15:33:18 -0700
From:   akpm@linux-foundation.org
To:     itazur@amazon.com, kuniyu@amazon.co.jp, mm-commits@vger.kernel.org
Subject:  +
 pid-cleanup-the-stale-comment-mentioning-pidmap_init.patch added to -mm
 tree
Message-ID: <20210714223318.LNaGra_3V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pid: cleanup the stale comment mentioning pidmap_init().
has been added to the -mm tree.  Its filename is
     pid-cleanup-the-stale-comment-mentioning-pidmap_init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/pid-cleanup-the-stale-comment-mentioning-pidmap_init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/pid-cleanup-the-stale-comment-mentioning-pidmap_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from itazur@amazon.com are

pid-cleanup-the-stale-comment-mentioning-pidmap_init.patch

