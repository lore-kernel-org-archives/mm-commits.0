Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEBFC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 725CE60E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhEHWyQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhEHWyP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C09C61430;
        Sat,  8 May 2021 22:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514393;
        bh=UBgRSDeNuQhYT5nPbdgyXZzXPZA0WI8Jz1dkfzTxocs=;
        h=Date:From:To:Subject:From;
        b=glQwCpafuOgD2bfPaZo0RkoaSAn/wj4tt01eSdx95vaOkc7PmUjhHPs5H5MLiRgOq
         HnYRmcqbdQW8pEBpHQJVtXhbrA/bO9dqMpizTKe2Ux6pGffKONv9SnZXVaiWoEXB3n
         gMK1YuU7c/VrwqV1U5DqvhDpOslQhtUI5CLs2gaA=
Date:   Sat, 08 May 2021 15:53:13 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mailhol.vincent@wanadoo.fr,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?checkpatch-exclude-four-preprocessor-sub-expressions-from-m?=
 =?US-ASCII?Q?acro=5Farg=5Freuse.patch?= removed from -mm tree
Message-ID: <20210508225313.Rv7a_mqcf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: exclude four preprocessor sub-expressions from MACRO_ARG_REUSE
has been removed from the -mm tree.  Its filename was
     checkpatch-exclude-four-preprocessor-sub-expressions-from-macro_arg_reuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5829,7 +5829,7 @@ sub process {
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


