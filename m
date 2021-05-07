Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0F4C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D35CF61041
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhEGBE6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhEGBE6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E036A610F7;
        Fri,  7 May 2021 01:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349439;
        bh=3oIOmhhwylh/Ad5EKTVIjtRH+XgJ7M7Dn139FYpVpcY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KLvJu+3ktFaFnxT2umWjTTYRvjdZggi4BqkqL6PoTmqMvOIflXtUVtVstgpt+Sao3
         BfKe9tLfsD3upHdIZJOoxZe22VW0YjmW3kGGxTqVsU19lGAwey6BLHVDV9oj58wv4c
         6mU20kLS+XTELjZBnmX4vTJc2we4d+0ZrIwtyRTs=
Date:   Thu, 06 May 2021 18:03:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mailhol.vincent@wanadoo.fr, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 37/91] checkpatch: exclude four preprocessor
 sub-expressions from MACRO_ARG_REUSE
Message-ID: <20210507010358.m2ZZiPpcT%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
