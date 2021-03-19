Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4654CC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24E46197B
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 22:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhCSWZY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 18:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhCSWZK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 18:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E17A26196E;
        Fri, 19 Mar 2021 22:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616192710;
        bh=I/IHYUFDEbIZhHfD1GHhQfDlmRzPmiXejbXT0l0Krg8=;
        h=Date:From:To:Subject:From;
        b=xH22EEUkvE6Fml2Ye8/AvV5CrzefNQThrn95V9seEF4R/2ye5LR+CXfi8jusmaNTO
         DMPEdnApnp6vGJBpUXa1949RzWZtj0ZBRRp/9Met+827wgohHrtXghYNge/44PdKDF
         D/PZXpIl2+p2ScrwFtltcLr9IpSgDK/b9vTsWjXI=
Date:   Fri, 19 Mar 2021 15:25:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, unixbhaskar@gmail.com
Subject:  + ipc-semc-couple-of-spelling-fixes.patch added to -mm
 tree
Message-ID: <20210319222509.rsA4D8g5y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: couple of spelling fixes
has been added to the -mm tree.  Its filename is
     ipc-semc-couple-of-spelling-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-couple-of-spelling-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-couple-of-spelling-fixes.patch

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
Subject: ipc/sem.c: couple of spelling fixes

s/purpuse/purpose/
s/seperately/separately/

Link: https://lkml.kernel.org/r/20210319221432.26631-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/ipc/sem.c~ipc-semc-couple-of-spelling-fixes
+++ a/ipc/sem.c
@@ -786,7 +786,7 @@ static inline void wake_up_sem_queue_pre
 {
 	get_task_struct(q->sleeper);
 
-	/* see SEM_BARRIER_2 for purpuse/pairing */
+	/* see SEM_BARRIER_2 for purpose/pairing */
 	smp_store_release(&q->status, error);
 
 	wake_q_add_safe(wake_q, q->sleeper);
@@ -821,7 +821,7 @@ static inline int check_restart(struct s
 
 	/* It is impossible that someone waits for the new value:
 	 * - complex operations always restart.
-	 * - wait-for-zero are handled seperately.
+	 * - wait-for-zero are handled separately.
 	 * - q is a previously sleeping simple operation that
 	 *   altered the array. It must be a decrement, because
 	 *   simple increments never sleep.
_

Patches currently in -mm which might be from unixbhaskar@gmail.com are

ia64-kernel-few-typos-fixed-in-the-file-fsyss.patch
ia64-include-asm-minor-typo-fixes-in-the-file-pgtableh.patch
mm-kmemleak-fix-a-typo.patch
mm-typo-fix-in-the-file-utilc.patch
kernel-fix-a-typo-in-the-file-upc.patch
lib-fix-a-typo-in-the-file-bchc.patch
ipc-semc-couple-of-spelling-fixes.patch

