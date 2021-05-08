Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF0BC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFEF561432
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHW4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHW4E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961E3610FA;
        Sat,  8 May 2021 22:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514502;
        bh=DVRwU/5jUHrdIgig+wZToHJ/2RUUi2LPBaL3EluuDxQ=;
        h=Date:From:To:Subject:From;
        b=BS6MxVIjy21xldvPYhAyeJ6e76PkDFqAJNQ+nRYV68AOHU/g96vORjGM2+iEZM3Ds
         5hJpF+9lPww+Kjeg+hZFs3O2U+w82FhoIFtwrteD2ATxn08qy4bHIl7phXqENbm+74
         Zt5itwDbmVY4dOVFHhpNsqDMy1EX3QqV5zxTkbdA=
Date:   Sat, 08 May 2021 15:55:02 -0700
From:   akpm@linux-foundation.org
To:     mcgrof@kernel.org, mm-commits@vger.kernel.org,
        zhouchuangao@vivo.com
Subject:  [merged] umh-fix-some-spelling-mistakes.patch removed
 from -mm tree
Message-ID: <20210508225502.4ZEdFF0V8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/umh.c: fix some spelling mistakes
has been removed from the -mm tree.  Its filename was
     umh-fix-some-spelling-mistakes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -338,8 +338,8 @@ static void helper_unlock(void)
  * @argv: arg vector for process
  * @envp: environment for process
  * @gfp_mask: gfp mask for memory allocation
- * @cleanup: a cleanup function
  * @init: an init function
+ * @cleanup: a cleanup function
  * @data: arbitrary context sensitive data
  *
  * Returns either %NULL on allocation failure, or a subprocess_info
@@ -350,7 +350,7 @@ static void helper_unlock(void)
  * exec.  A non-zero return code causes the process to error out, exit,
  * and return the failure to the calling process
  *
- * The cleanup function is just before ethe subprocess_info is about to
+ * The cleanup function is just before the subprocess_info is about to
  * be freed.  This can be used for freeing the argv and envp.  The
  * Function must be runnable in either a process context or the
  * context in which call_usermodehelper_exec is called.
@@ -386,7 +386,7 @@ EXPORT_SYMBOL(call_usermodehelper_setup)
 
 /**
  * call_usermodehelper_exec - start a usermode application
- * @sub_info: information about the subprocessa
+ * @sub_info: information about the subprocess
  * @wait: wait for the application to finish and return status.
  *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
  *        when the program couldn't be exec'ed. This makes it safe to call
_

Patches currently in -mm which might be from zhouchuangao@vivo.com are


