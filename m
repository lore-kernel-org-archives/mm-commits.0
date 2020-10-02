Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCD5C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 22:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF4042072E
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 22:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601676928;
	bh=bc5oeIo6uQPuqwKpvY0otvLZTVjOd/tug6MubQVgBbU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oUrpyHuD/nFw4YH5l9A01m6qfy/f2XWDerGdMbGmVqD3MmTIf62ev6r/A6Jopw+2u
	 9bqiP1IvU8KKv74wftPKW4g8GySD8TCL979qIFnxKE/eL5Z/m5H66VwAG5Mqn7PDK4
	 JlKVJfrwPv3x1PgfR5gN4n0BfvGHIOV56OwRBguY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgJBWP1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 18:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJBWP1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 18:15:27 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB54720719;
        Fri,  2 Oct 2020 22:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601676925;
        bh=bc5oeIo6uQPuqwKpvY0otvLZTVjOd/tug6MubQVgBbU=;
        h=Date:From:To:Subject:From;
        b=DQaB7LOUlYmyFZuFu6GPcASTkDrFYenpSg1oQVvAIQIerKy10Jy9dkYZ6a2Ub1R6h
         59ciiA/4XqlGl/9cUW8vdVsTw8Shh8bSz+iIxxHyQr5fnlOvVEXx2LOwLpwMgz/wG/
         vjyfvwGdDjYmszvbaWzU4xnqKKlcRiVTgXl/yDn0=
Date:   Fri, 02 Oct 2020 15:15:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com,
        dwaipayanray1@gmail.com
Subject:  +
 checkpatch-fix-multi-statement-macro-checks-for-while-blocks.patch added to
 -mm tree
Message-ID: <20201002221524.bcZmW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix multi-statement macro checks for while blocks.
has been added to the -mm tree.  Its filename is
     checkpatch-fix-multi-statement-macro-checks-for-while-blocks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-multi-statement-macro-checks-for-while-blocks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-multi-statement-macro-checks-for-while-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: fix multi-statement macro checks for while blocks.

Checkpatch.pl doesn't have a check for excluding while (...) {...} blocks
from MULTISTATEMENT_MACRO_USE_DO_WHILE error.

For example, running checkpatch.pl on the file mm/maccess.c in the kernel
generates the following error:

ERROR: Macros with complex values should be enclosed in parentheses
+#define copy_from_kernel_nofault_loop(dst, src, len, type, err_label)  \
+       while (len >= sizeof(type)) {                                   \
+               __get_kernel_nofault(dst, src, type, err_label);        \
+               dst += sizeof(type);                                    \
+               src += sizeof(type);                                    \
+               len -= sizeof(type);                                    \
+       }

The error is misleading for this case.  Enclosing it in parentheses
doesn't make any sense.

Checkpatch already has an exception list for such common macro types. 
Added a new exception for while (...) {...} style blocks to the same.

In addition, the brace flatten logic was modified by changing the
substitution characters from "1" to "1u".  This was done to ensure that
macros in the form "#define foo(bar) while(bar){bar--;}" were also
correctly procecssed.

Link: https://lore.kernel.org/linux-kernel-mentees/dc985938aa3986702815a0bd68dfca8a03c85447.camel@perches.com/

Link: https://lkml.kernel.org/r/20201001171903.312021-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-multi-statement-macro-checks-for-while-blocks
+++ a/scripts/checkpatch.pl
@@ -5353,9 +5353,9 @@ sub process {
 			$dstat =~ s/\s*$//s;
 
 			# Flatten any parentheses and braces
-			while ($dstat =~ s/\([^\(\)]*\)/1/ ||
-			       $dstat =~ s/\{[^\{\}]*\}/1/ ||
-			       $dstat =~ s/.\[[^\[\]]*\]/1/)
+			while ($dstat =~ s/\([^\(\)]*\)/1u/ ||
+			       $dstat =~ s/\{[^\{\}]*\}/1u/ ||
+			       $dstat =~ s/.\[[^\[\]]*\]/1u/)
 			{
 			}
 
@@ -5396,6 +5396,7 @@ sub process {
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
 			    $dstat !~ /^(?:\#\s*$Ident|\#\s*$Constant)\s*$/ &&		# stringification #foo
 			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...} while (...); // do {...} while (...)
+			    $dstat !~ /^while\s*$Constant\s*$Constant\s*$/ &&		# while (...) {...}
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
 			    $dstat !~ /^do\s*{/ &&					# do {...
_

Patches currently in -mm which might be from dwaipayanray1@gmail.com are

checkpatch-extend-author-signed-off-by-check-for-split-from-header.patch
checkpatch-fix-multi-statement-macro-checks-for-while-blocks.patch

