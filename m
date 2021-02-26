Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07A2C433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 949B064F27
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBZBXN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhBZBWe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B57564F3B;
        Fri, 26 Feb 2021 01:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302495;
        bh=LK5Gdxoelh+DSiG0Dui941ewcvz04XCRFup/um5DaaU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YOVujVYHX3QA0Kb2m9zK9jUPNtkhPUUUB9GtX2tvDGvUIOFupjiRd6JG2n2rTLeg3
         Pw2cY6NIWhrXa8yyrjPDkoZoydplhygQypKqO+8QiBNigEkYNHdJXEo2f4BMTj9Lw6
         CI3PxidwK7qyh/eGfOamPu98NO8/5U4n3mlLQy4w=
Date:   Thu, 25 Feb 2021 17:21:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 097/118] lib/cmdline: remove an unneeded local
 variable in next_arg()
Message-ID: <20210226012134.dlagKsZvQ%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -228,7 +228,6 @@ char *next_arg(char *args, char **param,
 {
 	unsigned int i, equals = 0;
 	int in_quote = 0, quoted = 0;
-	char *next;
 
 	if (*args == '"') {
 		args++;
@@ -266,10 +265,10 @@ char *next_arg(char *args, char **param,
 
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
