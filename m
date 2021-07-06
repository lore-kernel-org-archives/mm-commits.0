Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17860C11F68
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 012F661CAC
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhGFTYo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhGFTYn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B1F961CAA;
        Tue,  6 Jul 2021 19:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599324;
        bh=/w2FUb0Ow6Eu8fUvUnJYaiouJL/nufeiyKe1OKUWJRg=;
        h=Date:From:To:Subject:From;
        b=2Th7sKMOpAgoeJNNcxzXIGiNk0ioNpLhIAExZwsZ7W0KhvXCX0EPahWGNwdroMkXv
         mhYjc2eunSBmYiI7t/qL52TIZSjEiPBSf4dzp9l8mnUo3wMEDv74AibSc/Tsp9DLA9
         HLJ8O0ZwMTL5Ziqwc+1QVLRPi+njcx/LoXQTiRsw=
Date:   Tue, 06 Jul 2021 12:22:04 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop.patch
 removed from -mm tree
Message-ID: <20210706192204.Ek-a01zJ7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: move ESCAPE_NP check inside 'else' branch in a loop
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/string_helpers: move ESCAPE_NP check inside 'else' branch in a loop

Refactor code to have better readability by moving ESCAPE_NP handling
inside 'else' branch in the loop.

No functional change intended.

Link: https://lkml.kernel.org/r/20210504180819.73127-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/lib/string_helpers.c~lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop
+++ a/lib/string_helpers.c
@@ -452,10 +452,10 @@ static bool escape_hex(unsigned char c,
  * The process of escaping byte buffer includes several parts. They are applied
  * in the following sequence.
  *
- *	1. The character is matched to the printable class, if asked, and in
- *	   case of match it passes through to the output.
- *	2. The character is not matched to the one from @only string and thus
+ *	1. The character is not matched to the one from @only string and thus
  *	   must go as-is to the output.
+ *	2. The character is matched to the printable class, if asked, and in
+ *	   case of match it passes through to the output.
  *	3. The character is checked if it falls into the class given by @flags.
  *	   %ESCAPE_OCTAL and %ESCAPE_HEX are going last since they cover any
  *	   character. Note that they actually can't go together, otherwise
@@ -506,19 +506,22 @@ int string_escape_mem(const char *src, s
 
 		/*
 		 * Apply rules in the following sequence:
-		 *	- the character is printable, when @flags has
-		 *	  %ESCAPE_NP bit set
 		 *	- the @only string is supplied and does not contain a
 		 *	  character under question
+		 *	- the character is printable, when @flags has
+		 *	  %ESCAPE_NP bit set
 		 *	- the character doesn't fall into a class of symbols
 		 *	  defined by given @flags
 		 * In these cases we just pass through a character to the
 		 * output buffer.
 		 */
-		if ((flags & ESCAPE_NP && isprint(c)) ||
-		    (is_dict && !strchr(only, c))) {
+		if (is_dict && !strchr(only, c)) {
 			/* do nothing */
 		} else {
+			if (isprint(c) &&
+			    flags & ESCAPE_NP && escape_passthrough(c, &p, end))
+				continue;
+
 			if (flags & ESCAPE_SPACE && escape_space(c, &p, end))
 				continue;
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


