Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DEDC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 19:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD4356023D
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 19:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhG1TeV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:34:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhG1TeU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Jul 2021 15:34:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E6C6101B;
        Wed, 28 Jul 2021 19:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627500857;
        bh=KrDGFvAJlE0xussSXBbh36HYDXzicKjnhHG60TVpqM4=;
        h=Date:From:To:Subject:From;
        b=T/5WWbxZCPpJhSBzqcSoktYrOIJ1LtFsmEUYeYlMYD2ddm+fGmEl75e95tt6zyyY1
         mszvEabQg0GaB8HIUNwPgbe+rPTAogQApR8wHhTgjUHErDueknpnuWXQIRZiKeSGcc
         MOUEfdAqdpadJObKjodnfe8l9Tv0RVA65y04jclE=
Date:   Wed, 28 Jul 2021 12:34:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, sh_def@163.com,
        rdunlap@infradead.org, yang.yang29@zte.com.cn
Subject:  + acct-use-dedicated-helper-to-access-rlimit-values.patch
 added to -mm tree
Message-ID: <20210728193417.PO2cg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/acct.c: use dedicated helper to access rlimit values
has been added to the -mm tree.  Its filename is
     acct-use-dedicated-helper-to-access-rlimit-values.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/acct-use-dedicated-helper-to-access-rlimit-values.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/acct-use-dedicated-helper-to-access-rlimit-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

acct-use-dedicated-helper-to-access-rlimit-values.patch

