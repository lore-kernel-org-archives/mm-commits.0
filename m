Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBEBC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A790864EE4
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBZBXT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230049AbhBZBWi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BA9164F40;
        Fri, 26 Feb 2021 01:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302508;
        bh=YKl4woXe2vxyEZWZHCVwHJpaiuqNWBAvRHJlA+mjMfk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JA19xpBxmR6vSyaYz9Vlsg/war5C2qZSdmkrBjy+PkaSBBzKQi1NIW72d8hjfqymd
         NEd9KBeuICz8VpLAtKzYgcI8cwUrmoWbn41be+OLF1lb3xVx3cPBczeEXXRZj64zTg
         D0Mn/H47xbX8RdsPqdQ+1qsjU1j97Ynbm4G+Zbnk=
Date:   Thu, 25 Feb 2021 17:21:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 101/118] checkpatch: trivial style fixes
Message-ID: <20210226012147.CZquddUee%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: trivial style fixes

Indentations should use tabs wherever possible.
Replace spaces by tabs for indents.

Link: https://lkml.kernel.org/r/20210105103044.40282-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-trivial-style-fixes
+++ a/scripts/checkpatch.pl
@@ -2974,7 +2974,7 @@ sub process {
 				}
 				if (!defined $lines[$linenr]) {
 					WARN("BAD_SIGN_OFF",
-                                             "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline);
+					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline);
 				} elsif ($rawlines[$linenr] !~ /^\s*signed-off-by:\s*(.*)/i) {
 					WARN("BAD_SIGN_OFF",
 					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline . "\n" .$rawlines[$linenr]);
@@ -2997,8 +2997,8 @@ sub process {
 			if (ERROR("GERRIT_CHANGE_ID",
 			          "Remove Gerrit Change-Id's before submitting upstream\n" . $herecurr) &&
 			    $fix) {
-                                fix_delete_line($fixlinenr, $rawline);
-                        }
+				fix_delete_line($fixlinenr, $rawline);
+			}
 		}
 
 # Check if the commit log is in a possible stack dump
@@ -3240,10 +3240,10 @@ sub process {
 				next if ($start_char =~ /^\S$/);
 				next if (index(" \t.,;?!", $end_char) == -1);
 
-                                # avoid repeating hex occurrences like 'ff ff fe 09 ...'
-                                if ($first =~ /\b[0-9a-f]{2,}\b/i) {
-                                        next if (!exists($allow_repeated_words{lc($first)}));
-                                }
+				# avoid repeating hex occurrences like 'ff ff fe 09 ...'
+				if ($first =~ /\b[0-9a-f]{2,}\b/i) {
+					next if (!exists($allow_repeated_words{lc($first)}));
+				}
 
 				if (WARN("REPEATED_WORD",
 					 "Possible repeated word: '$first'\n" . $herecurr) &&
@@ -4423,7 +4423,7 @@ sub process {
 			WARN("STATIC_CONST_CHAR_ARRAY",
 			     "char * array declaration might be better as static const\n" .
 				$herecurr);
-               }
+		}
 
 # check for sizeof(foo)/sizeof(foo[0]) that could be ARRAY_SIZE(foo)
 		if ($line =~ m@\bsizeof\s*\(\s*($Lval)\s*\)@) {
@@ -5276,7 +5276,7 @@ sub process {
 		    $lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
 			WARN("RETURN_VOID",
 			     "void function return statements are not generally useful\n" . $hereprev);
-               }
+		}
 
 # if statements using unnecessary parentheses - ie: if ((foo == bar))
 		if ($perl_version_ok &&
_
