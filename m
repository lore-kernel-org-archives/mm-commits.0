Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FABEC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3DA0610CE
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbhEGBHm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhEGBHl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38CF861289;
        Fri,  7 May 2021 01:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349602;
        bh=0RLOwK9Iti97ZwYX6zGcZeCSjGZeROoLdzswzNOV0R4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f8XbNZqQAsgxPTAUoRS0D+qb4yt74lM8HeB3RIsAt87KBWdH/4DxnH9jA5KUR0fUr
         anhrVI1xohnuoF7Auvogb2iT1yGlypNFx6UEK1Q7+V3nTtX/PQRoe8JLWbM+nRl1z9
         lxn3pJX8nNcZ6wBDN4wW4HTGuZ/MONJ2RU8umF5s=
Date:   Thu, 06 May 2021 18:06:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, unixbhaskar@gmail.com
Subject:  [patch 88/91] ipc/sem.c: spelling fix
Message-ID: <20210507010641.epgY7MXfO%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: ipc/sem.c: spelling fix

s/purpuse/purpose/

Link: https://lkml.kernel.org/r/20210319221432.26631-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/sem.c~ipc-semc-couple-of-spelling-fixes
+++ a/ipc/sem.c
@@ -786,7 +786,7 @@ static inline void wake_up_sem_queue_pre
 {
 	get_task_struct(q->sleeper);
 
-	/* see SEM_BARRIER_2 for purpuse/pairing */
+	/* see SEM_BARRIER_2 for purpose/pairing */
 	smp_store_release(&q->status, error);
 
 	wake_q_add_safe(wake_q, q->sleeper);
_
