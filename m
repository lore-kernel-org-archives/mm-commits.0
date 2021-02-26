Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1D0C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B508564EE4
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBZBXY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhBZBWn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE1364F43;
        Fri, 26 Feb 2021 01:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302518;
        bh=PrKSCZGl0kLEiEEp++MoQMYdTD/1sHt+9FXhlrlGVmo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J+i8Q4+5AFmNmk8qqi7YsDRfR1AczvrDuxfp+CpK+G26s/japW8ydpKs63MpsXVnT
         V9wO67FrJ3UlRh8iUnYn9nsHpFHVPymR9KZUbXG4gCPx5SI7rx+lLuwpczHlzW22Wn
         4PG+ERnnB+lor2XBU6xZYAc2zpXOz36cmNyOuaZA=
Date:   Thu, 25 Feb 2021 17:21:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, broonie@kernel.org,
        dwaipayanray1@gmail.com, joe@perches.com, jpoimboe@redhat.com,
        linux-mm@kvack.org, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        torvalds@linux-foundation.org, yashsri421@gmail.com
Subject:  [patch 104/118] checkpatch: add warning for avoiding .L
 prefix symbols in assembly files
Message-ID: <20210226012157.Dq91JG3pF%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Aditya Srivastava <yashsri421@gmail.com>
Subject: checkpatch: add warning for avoiding .L prefix symbols in assembly files

objtool requires that all code must be contained in an ELF symbol.  Symbol
names that have a '.L' prefix do not emit symbol table entries, as they
have special meaning for the assembler.

'.L' prefixed symbols can be used within a code region, but should be
avoided for denoting a range of code via 'SYM_*_START/END' annotations.

Add a new check to emit a warning on finding the usage of '.L' symbols for
'.S' files, if it denotes range of code via SYM_*_START/END annotation
pair.

Link: https://lkml.kernel.org/r/20210123190459.9701-1-yashsri421@gmail.com
Link: https://lore.kernel.org/lkml/20210112210154.GI4646@sirena.org.uk
Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
Suggested-by: Mark Brown <broonie@kernel.org>
Acked-by: Joe Perches <joe@perches.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Aditya Srivastava <yashsri421@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-avoiding-l-prefix-symbols-in-assembly-files
+++ a/scripts/checkpatch.pl
@@ -3599,6 +3599,13 @@ sub process {
 			}
 		}
 
+# check for .L prefix local symbols in .S files
+		if ($realfile =~ /\.S$/ &&
+		    $line =~ /^\+\s*(?:[A-Z]+_)?SYM_[A-Z]+_(?:START|END)(?:_[A-Z_]+)?\s*\(\s*\.L/) {
+			WARN("AVOID_L_PREFIX",
+			     "Avoid using '.L' prefixed local symbol names for denoting a range of code via 'SYM_*_START/END' annotations; see Documentation/asm-annotations.rst\n" . $herecurr);
+		}
+
 # check we are in a valid source file C or perl if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
 
_
