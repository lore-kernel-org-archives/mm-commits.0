Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02208C433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCA6D64F24
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhB0CdY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhB0Ccm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75CCD64F29;
        Sat, 27 Feb 2021 02:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393130;
        bh=aF1CztGWGBO6MXLqsC5reqyFVkMZys0w3ciRCdN30S0=;
        h=Date:From:To:Subject:From;
        b=2gCmNiER5zMS58AntJTvoAlxmJgJOoaZsuC/s0dmmZD4KGWT4uZDseWqFTCDhaUjc
         KrpcPnSOUQfUgVeUBbQrWsRNGm13K6j0494QIr5vhgcQ6xOcB7idPRPRn/OW+f3JWM
         TcAtY3SDOsUceGoKCxPl5ZYyqe2VacyT2vCihlEE=
Date:   Fri, 26 Feb 2021 18:32:10 -0800
From:   akpm@linux-foundation.org
To:     masahiroy@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 lib-cmdline-remove-an-unneeded-local-variable-in-next_arg.patch removed
 from -mm tree
Message-ID: <20210227023210.-VfQvbr8W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline: remove an unneeded local variable in next_arg()
has been removed from the -mm tree.  Its filename was
     lib-cmdline-remove-an-unneeded-local-variable-in-next_arg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from masahiroy@kernel.org are

init-kconfig-make-compile_test-depend-on-has_iomem.patch

