Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE50C433ED
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 056C8619CA
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhC1TLr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231558AbhC1TLn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5184C61999;
        Sun, 28 Mar 2021 19:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958703;
        bh=5nbHNUq1dAPfMwQrUoN8l0Ux/mmvZVAEUcupkvnOTbg=;
        h=Date:From:To:Subject:From;
        b=LMogtiAxaghS73kI6jvLN3707OjdewCI0dIkAfcoh+A86tc3XXMwaTtU+Z+gtZAxK
         F9XmwPEy1IAZZPXpvKzEUtVVqBCxY2vpq+KMOVoIRlBHdL50rCod90ij7vVQDe9j9G
         vbCjLRlb2wyiAx2RXYzdEBBkw4u2diDV8vVIXE7s=
Date:   Sun, 28 Mar 2021 12:11:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        unixbhaskar@gmail.com
Subject:  + ipc-semc-mundane-typo-fixes.patch added to -mm tree
Message-ID: <20210328191142.xvjTXeBUu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: mundane typo fixes
has been added to the -mm tree.  Its filename is
     ipc-semc-mundane-typo-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-mundane-typo-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-mundane-typo-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from unixbhaskar@gmail.com are

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
ocfs2-fix-a-typo.patch
mm-kmemleak-fix-a-typo.patch
mm-typo-fix-in-the-file-utilc.patch
lib-fix-a-typo-in-the-file-bchc.patch
lib-genallocc-fix-a-typo.patch
ipc-semc-mundane-typo-fixes.patch
mm-few-spelling-fixes.patch
kernel-fix-a-typo-in-the-file-upc.patch
ipc-semc-couple-of-spelling-fixes.patch

