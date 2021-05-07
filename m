Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2AAC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F439610FA
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhEGBGt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhEGBGt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1962A61289;
        Fri,  7 May 2021 01:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349549;
        bh=Jr7DaEG7tuCKXnpCxTOV0yWjrk69FgJoH8DATG41kGU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Cz6dC1r2EoSz7Sy3z9Gn8l5jNp5qNNBebrmy/gjniihB49E0ADAdXYF5XdSl0iHLq
         voj0bIXBRcEg5A+qbCryQqUeTM21/Re4u3vDLDQpqAl6WV486bB/oZehVVBu9PkXif
         RMtZPWYYVBuufzFIX1FkTfOaQ3IKWTZpxr4BRWvs=
Date:   Thu, 06 May 2021 18:05:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, unixbhaskar@gmail.com
Subject:  [patch 72/91] ipc/sem.c: mundane typo fixes
Message-ID: <20210507010548.0jnacoFh9%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: ipc/sem.c: mundane typo fixes

s/runtine/runtime/
s/AQUIRE/ACQUIRE/
s/seperately/separately/
s/wont/won\'t/
s/succesfull/successful/

Link: https://lkml.kernel.org/r/20210326022240.26375-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/ipc/sem.c~ipc-semc-mundane-typo-fixes
+++ a/ipc/sem.c
@@ -36,7 +36,7 @@
  * - two Linux specific semctl() commands: SEM_STAT, SEM_INFO.
  * - undo adjustments at process exit are limited to 0..SEMVMX.
  * - namespace are supported.
- * - SEMMSL, SEMMNS, SEMOPM and SEMMNI can be configured at runtine by writing
+ * - SEMMSL, SEMMNS, SEMOPM and SEMMNI can be configured at runtime by writing
  *   to /proc/sys/kernel/sem.
  * - statistics about the usage are reported in /proc/sysvipc/sem.
  *
@@ -224,7 +224,7 @@ static int sysvipc_sem_proc_show(struct
  * Setting it to a result code is a RELEASE, this is ensured by both a
  * smp_store_release() (for case a) and while holding sem_lock()
  * (for case b).
- * The AQUIRE when reading the result code without holding sem_lock() is
+ * The ACQUIRE when reading the result code without holding sem_lock() is
  * achieved by using READ_ONCE() + smp_acquire__after_ctrl_dep().
  * (case a above).
  * Reading the result code while holding sem_lock() needs no further barriers,
@@ -821,7 +821,7 @@ static inline int check_restart(struct s
 
 	/* It is impossible that someone waits for the new value:
 	 * - complex operations always restart.
-	 * - wait-for-zero are handled seperately.
+	 * - wait-for-zero are handled separately.
 	 * - q is a previously sleeping simple operation that
 	 *   altered the array. It must be a decrement, because
 	 *   simple increments never sleep.
@@ -1046,7 +1046,7 @@ static void do_smart_update(struct sem_a
 			 * - No complex ops, thus all sleeping ops are
 			 *   decrease.
 			 * - if we decreased the value, then any sleeping
-			 *   semaphore ops wont be able to run: If the
+			 *   semaphore ops won't be able to run: If the
 			 *   previous value was too small, then the new
 			 *   value will be too small, too.
 			 */
@@ -2108,7 +2108,7 @@ static long do_semtimedop(int semid, str
 	queue.dupsop = dupsop;
 
 	error = perform_atomic_semop(sma, &queue);
-	if (error == 0) { /* non-blocking succesfull path */
+	if (error == 0) { /* non-blocking successful path */
 		DEFINE_WAKE_Q(wake_q);
 
 		/*
_
