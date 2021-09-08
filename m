Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D53C43219
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F86E61153
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347430AbhIHC71 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347390AbhIHC70 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9BBF6113C;
        Wed,  8 Sep 2021 02:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069899;
        bh=gTkP6jaWkfbYKLjyGTpii2sLP6eOwxMVLLTX8ZQ3TUk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zGSTenZ8CRhqLxzOmiUvftL5Ykv0Ujon26sT2H2RMqZCGqzzr0XKlLHs4hFkyGMfW
         yz/6mujt8jdjg7v7MC48GLt4h3/Q8b5qWUV9Wm7dQXZ/7k7WcgLY4o2eEDTO/UHXE3
         9YNVh6R7M3Gj2Bvw5BawMGVc2tnRKjzz4sUr7L1A=
Date:   Tue, 07 Sep 2021 19:58:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, sh_def@163.com,
        torvalds@linux-foundation.org, yang.yang29@zte.com.cn,
        zealci@zte.com.cn
Subject:  [patch 094/147] kernel/acct.c: use dedicated helper to
 access rlimit values
Message-ID: <20210908025818.SN1YMF0Cv%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Yang <yang.yang29@zte.com.cn>
Subject: kernel/acct.c: use dedicated helper to access rlimit values

Use rlimit() helper instead of manually writing whole chain from
task to rlimit value. See patch "posix-cpu-timers: Use dedicated
helper to access rlimit values".

Link: https://lkml.kernel.org/r/20210728030822.524789-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: sh_def@163.com <sh_def@163.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/acct.c~acct-use-dedicated-helper-to-access-rlimit-values
+++ a/kernel/acct.c
@@ -478,7 +478,7 @@ static void do_acct_process(struct bsd_a
 	/*
 	 * Accounting records are not subject to resource limits.
 	 */
-	flim = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+	flim = rlimit(RLIMIT_FSIZE);
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	/* Perform file operations on behalf of whoever enabled accounting */
 	orig_cred = override_creds(file->f_cred);
_
