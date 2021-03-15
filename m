Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EDFC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3790564F0C
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 22:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhCOW2R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 18:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhCOW15 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 18:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBFDB64F0C;
        Mon, 15 Mar 2021 22:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615847277;
        bh=grYPIW9s6goWVy99ElZAAdgMaV5vp53M205kYnWKQ4g=;
        h=Date:From:To:Subject:From;
        b=REvv/J5OBcS5jH5mENApLRLr5khINOlVHAgaboS98x0RWl0fG1aicco+DNqZ8uRWO
         JN1SoH6E6CftjHHpef+jhVsCbEdmLdMYwfjHh78KOQPPcKCljIOdUhk1vmD2uLxCEl
         SgZWRecWfWkrJ35+mLzBlIJILM7FR505VT4Nxby8=
Date:   Mon, 15 Mar 2021 15:27:56 -0700
From:   akpm@linux-foundation.org
To:     mcgrof@kernel.org, mm-commits@vger.kernel.org,
        zhouchuangao@vivo.com
Subject:  + umh-fix-some-spelling-mistakes.patch added to -mm tree
Message-ID: <20210315222756.wKnxYLy2C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/umh.c: fix some spelling mistakes
has been added to the -mm tree.  Its filename is
     umh-fix-some-spelling-mistakes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/umh-fix-some-spelling-mistakes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/umh-fix-some-spelling-mistakes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhouchuangao <zhouchuangao@vivo.com>
Subject: kernel/umh.c: fix some spelling mistakes

Fix some spelling mistakes, and modify the order of the parameter comments
to be consistent with the order of the parameters passed to the function.

Link: https://lkml.kernel.org/r/1615636139-4076-1-git-send-email-zhouchuangao@vivo.com
Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/umh.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/umh.c~umh-fix-some-spelling-mistakes
+++ a/kernel/umh.c
@@ -336,8 +336,8 @@ static void helper_unlock(void)
  * @argv: arg vector for process
  * @envp: environment for process
  * @gfp_mask: gfp mask for memory allocation
- * @cleanup: a cleanup function
  * @init: an init function
+ * @cleanup: a cleanup function
  * @data: arbitrary context sensitive data
  *
  * Returns either %NULL on allocation failure, or a subprocess_info
@@ -348,7 +348,7 @@ static void helper_unlock(void)
  * exec.  A non-zero return code causes the process to error out, exit,
  * and return the failure to the calling process
  *
- * The cleanup function is just before ethe subprocess_info is about to
+ * The cleanup function is just before the subprocess_info is about to
  * be freed.  This can be used for freeing the argv and envp.  The
  * Function must be runnable in either a process context or the
  * context in which call_usermodehelper_exec is called.
@@ -384,7 +384,7 @@ EXPORT_SYMBOL(call_usermodehelper_setup)
 
 /**
  * call_usermodehelper_exec - start a usermode application
- * @sub_info: information about the subprocessa
+ * @sub_info: information about the subprocess
  * @wait: wait for the application to finish and return status.
  *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
  *        when the program couldn't be exec'ed. This makes it safe to call
_

Patches currently in -mm which might be from zhouchuangao@vivo.com are

umh-fix-some-spelling-mistakes.patch

