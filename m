Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC22C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88C0B611C9
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347693AbhIIVF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348026AbhIIVFQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89D6A611C0;
        Thu,  9 Sep 2021 21:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221441;
        bh=0HbKyyYQMepWSzpujgJA5AwMYHFboK0kLtpWYKklA6o=;
        h=Date:From:To:Subject:From;
        b=YTsaAl+qHn2rv+GAhdxYaR5trVkVWo/7FQeKqlJ6EUtRZTrWBTHRHeOGmfsbHlCF0
         fJCn0eyFMYjfKEfLBhadvzP1ZVXpbWR/RkvKI0Grrd6JEE5f1s7IMXKcyZUSC7VfKg
         pxk4s8Us6OJ3Zepwr1D1Pxp4kQuYxsPDhxxbGn+M=
Date:   Thu, 09 Sep 2021 14:04:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, sh_def@163.com,
        yang.yang29@zte.com.cn, zealci@zte.com.cn
Subject:  [merged]
 acct-use-dedicated-helper-to-access-rlimit-values.patch removed from -mm
 tree
Message-ID: <20210909210401.gOflHGD8Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/acct.c: use dedicated helper to access rlimit values
has been removed from the -mm tree.  Its filename was
     acct-use-dedicated-helper-to-access-rlimit-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


