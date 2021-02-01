Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B4DC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3539464EC6
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhBAXwI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:52:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhBAXwI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:52:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDAC064E93;
        Mon,  1 Feb 2021 23:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612223487;
        bh=liLDE6SqB/ctq4oxDjenadX+8zpwT/7pxpIqgR6DT3g=;
        h=Date:From:To:Subject:From;
        b=mFCljJhivvgACipAl2YsB98+SpayfM1GDD+jkFmFT3pNFmrgdlNfgRFvVgCEGlrnV
         FRwuTtUxZo+Q9FGOETasP63Oxsb2ZdGiQ2thkiWnXy/WrgFJLhJag15mCJPwIm8NDe
         q7+Oj5IMHyzRfPPZ+muZTft0jrTUhDAhrCIsDdCQ=
Date:   Mon, 01 Feb 2021 15:51:27 -0800
From:   akpm@linux-foundation.org
To:     masahiroy@kernel.org, mm-commits@vger.kernel.org
Subject:  +
 lib-cmdline-remove-an-unneeded-local-variable-in-next_arg.patch added to
 -mm tree
Message-ID: <20210201235127.awC6gKmyH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline: remove an unneeded local variable in next_arg()
has been added to the -mm tree.  Its filename is
     lib-cmdline-remove-an-unneeded-local-variable-in-next_arg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-cmdline-remove-an-unneeded-local-variable-in-next_arg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-cmdline-remove-an-unneeded-local-variable-in-next_arg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: lib/cmdline: remove an unneeded local variable in next_arg()

The local variable 'next' is unneeded because you can simply advance the
existing pointer 'args'.

Link: https://lkml.kernel.org/r/20210201014707.3828753-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/lib/cmdline.c~lib-cmdline-remove-an-unneeded-local-variable-in-next_arg
+++ a/lib/cmdline.c
@@ -215,7 +215,6 @@ char *next_arg(char *args, char **param,
 {
 	unsigned int i, equals = 0;
 	int in_quote = 0, quoted = 0;
-	char *next;
 
 	if (*args == '"') {
 		args++;
@@ -253,10 +252,10 @@ char *next_arg(char *args, char **param,
 
 	if (args[i]) {
 		args[i] = '\0';
-		next = args + i + 1;
+		args += i + 1;
 	} else
-		next = args + i;
+		args += i;
 
 	/* Chew up trailing spaces. */
-	return skip_spaces(next);
+	return skip_spaces(args);
 }
_

Patches currently in -mm which might be from masahiroy@kernel.org are

lib-cmdline-remove-an-unneeded-local-variable-in-next_arg.patch
init-versionc-remove-version_linux_version_code-symbol.patch
init-clean-up-early_param_on_off-macro.patch

