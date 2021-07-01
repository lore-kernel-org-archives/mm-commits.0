Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B714C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 728A06146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbhGAB6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238564AbhGAB6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C6061469;
        Thu,  1 Jul 2021 01:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104583;
        bh=ycD4VMGuhVPokmYYI/5gsUNLK1BzminCOCdV/oMVzdw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wXKLtvNOgWKpA2FaF+opTYsHpMuhdMrKUTV7Oy1ATlqf5OMRJnjhPYdAjGWVyxyhc
         imjOJmtwt2wpbEYIfMRhyrNGziWnOUjI/hv5u+CrgR1rfZsXKUc6UAwGPj7rRrkIG7
         o4pk6+ou2dMolCubo5zt3anyHhe5C7358nDL+g74=
Date:   Wed, 30 Jun 2021 18:56:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, elder@ieee.org,
        gregkh@linuxfoundation.org, joe@perches.com, linux-mm@kvack.org,
        manikishanghantasala@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 174/192] checkpatch: improve the indented label
 test
Message-ID: <20210701015622.z0Hi22fow%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve the indented label test

checkpatch identifies a label only when a terminating colon
immediately follows an identifier.

Bitfield definitions can appear to be labels so ignore any
spaces between the identifier terminating colon and any digit
that may be used to define a bitfield length.

Miscellanea:

o Improve the initial checkpatch comment
o Use the more typical '&&' instead of 'and'
o Require the initial label character to be a non-digit
  (Can't use $Ident here because $Ident allows ## concatenation)
o Use $sline instead of $line to ignore comments
o Use '$sline !~ /.../' instead of '!($line =~ /.../)'

Link: https://lkml.kernel.org/r/b54d673e7cde7de5de0c9ba4dd57dd0858580ca4.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Manikishan Ghantasala <manikishanghantasala@gmail.com>
Cc: Alex Elder <elder@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-the-indented-label-test
+++ a/scripts/checkpatch.pl
@@ -5361,9 +5361,13 @@ sub process {
 			}
 		}
 
-#goto labels aren't indented, allow a single space however
-		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
-		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
+# check that goto labels aren't indented (allow a single space indentation)
+# and ignore bitfield definitions like foo:1
+# Strictly, labels can have whitespace after the identifier and before the :
+# but this is not allowed here as many ?: uses would appear to be labels
+		if ($sline =~ /^.\s+[A-Za-z_][A-Za-z\d_]*:(?!\s*\d+)/ &&
+		    $sline !~ /^. [A-Za-z\d_][A-Za-z\d_]*:/ &&
+		    $sline !~ /^.\s+default:/) {
 			if (WARN("INDENTED_LABEL",
 				 "labels should not be indented\n" . $herecurr) &&
 			    $fix) {
_
