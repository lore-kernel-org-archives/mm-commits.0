Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AB3C433ED
	for <mm-commits@archiver.kernel.org>; Thu,  8 Apr 2021 23:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E09561165
	for <mm-commits@archiver.kernel.org>; Thu,  8 Apr 2021 23:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhDHXSx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Apr 2021 19:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhDHXSx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 8 Apr 2021 19:18:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BB316115B;
        Thu,  8 Apr 2021 23:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617923921;
        bh=vHBFmdrlVFPRn6UfZO3B/Sgk4FMARTR5Qivz4KVjNe4=;
        h=Date:From:To:Subject:From;
        b=qU5G4LpkeNUsYjEx37GE1sWJvBxZw7JxsOHZGCJbRSXjgDgQmB1MQBOfQN49PSqSb
         6MsoXVFybNN3VvOq6tKYN4Fp7qrl3aVjWgFSNfOU4HQ+UCawA6vO1aGys86BA14NM7
         w6mPCxdSo2lOXBnX44SL52O1uXAIaE4R/rKgdHho=
Date:   Thu, 08 Apr 2021 16:18:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com,
        mailhol.vincent@wanadoo.fr
Subject:  +
 =?us-ascii?Q?checkpatch-exclude-four-preprocessor-sub-expressions-from-m?=
 =?us-ascii?Q?acro=5Farg=5Freuse.patch?= added to -mm tree
Message-ID: <20210408231840.37uMm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: exclude four preprocessor sub-expressions from MACRO_ARG_REUSE
has been added to the -mm tree.  Its filename is
     checkpatch-exclude-four-preprocessor-sub-expressions-from-macro_arg_reuse.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-exclude-four-preprocessor-sub-expressions-from-macro_arg_reuse.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-exclude-four-preprocessor-sub-expressions-from-macro_arg_reuse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: checkpatch: exclude four preprocessor sub-expressions from MACRO_ARG_REUSE

__must_be_array, offsetof, sizeof_field and __stringify are all
preprocessor macros and do not evaluate their arguments.  As such, it is
safe not to warn when arguments are being reused in those four
sub-expressions.

Exclude those so that they can pass checkpatch.

Link: https://lkml.kernel.org/r/20210407105042.25380-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-exclude-four-preprocessor-sub-expressions-from-macro_arg_reuse
+++ a/scripts/checkpatch.pl
@@ -5736,7 +5736,7 @@ sub process {
 			        next if ($arg =~ /\.\.\./);
 			        next if ($arg =~ /^type$/i);
 				my $tmp_stmt = $define_stmt;
-				$tmp_stmt =~ s/\b(sizeof|typeof|__typeof__|__builtin\w+|typecheck\s*\(\s*$Type\s*,|\#+)\s*\(*\s*$arg\s*\)*\b//g;
+				$tmp_stmt =~ s/\b(__must_be_array|offsetof|sizeof|sizeof_field|__stringify|typeof|__typeof__|__builtin\w+|typecheck\s*\(\s*$Type\s*,|\#+)\s*\(*\s*$arg\s*\)*\b//g;
 				$tmp_stmt =~ s/\#+\s*$arg\b//g;
 				$tmp_stmt =~ s/\b$arg\s*\#\#//g;
 				my $use_cnt = () = $tmp_stmt =~ /\b$arg\b/g;
_

Patches currently in -mm which might be from mailhol.vincent@wanadoo.fr are

checkpatch-exclude-four-preprocessor-sub-expressions-from-macro_arg_reuse.patch

