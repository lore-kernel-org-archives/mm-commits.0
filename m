Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435C9C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 00:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12D9722795
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 00:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbhAXAXj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 19:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbhAXAXi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 19:23:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FA60225AC;
        Sun, 24 Jan 2021 00:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611447776;
        bh=imIyipyeeZAWjNbu1LOl5nFDVhRQYp9CN0jCiZOVmDE=;
        h=Date:From:To:Subject:From;
        b=VLfUD0X8OuuZWP+iF6uF6s/6LY1u4yvoReUIkM/AHFQxYaUgmKApHwFbQlXuDe1B8
         KjSdqTUYHqcurHvM4XyhnqYy7MdUzmux9th3UUAKaEWBe/lRYIZwx7/t4lmnStUOGw
         VybHCGMAAwxiqfI+PjnTnwEXcF98WjfFoBcw1l7Q=
Date:   Sat, 23 Jan 2021 16:22:55 -0800
From:   akpm@linux-foundation.org
To:     broonie@kernel.org, dwaipayanray1@gmail.com, joe@perches.com,
        jpoimboe@redhat.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        yashsri421@gmail.com
Subject:  +
 =?US-ASCII?Q?checkpatch-add-warning-for-avoiding-l-prefix-symbols-in-asse?=
 =?US-ASCII?Q?mbly-files.patch?= added to -mm tree
Message-ID: <20210124002255.lAg8iNtrX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add warning for avoiding .L prefix symbols in assembly files
has been added to the -mm tree.  Its filename is
     checkpatch-add-warning-for-avoiding-l-prefix-symbols-in-assembly-files.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-warning-for-avoiding-l-prefix-symbols-in-assembly-files.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-warning-for-avoiding-l-prefix-symbols-in-assembly-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Aditya Srivastava <yashsri421@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-avoiding-l-prefix-symbols-in-assembly-files
+++ a/scripts/checkpatch.pl
@@ -3606,6 +3606,13 @@ sub process {
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

Patches currently in -mm which might be from yashsri421@gmail.com are

checkpatch-add-warning-for-avoiding-l-prefix-symbols-in-assembly-files.patch

