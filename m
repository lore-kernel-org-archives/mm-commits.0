Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DF2C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 883AE20789
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817945;
	bh=6fyAFns8NHCqsO6S0Mz2Ln+quBrFfq7CHWa8RJWkpTs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=yE/dbWD1AqoS1ylxLEw4I6YDdf11kfIInF6p7+Fe72/N+cdl4jwP6aN9EyyNjwJzY
	 wRwSX03ihfTJ4lSALhPKiRzemf0rWG7IyTR9qdVS9pkKY7uT+kIIBRorHWSzbeMWWu
	 dj+jSu/kPyFuBv5bDpnoXPeBahKAeJcVtgYYXWmM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389776AbgJPDMZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDMZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A84C220789;
        Fri, 16 Oct 2020 03:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817943;
        bh=6fyAFns8NHCqsO6S0Mz2Ln+quBrFfq7CHWa8RJWkpTs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=H3mIwy0/qHHCf7lBoLK1F2M8uTVmsxt1dKhfUEibT7juEzgHWEUpAhliynSa0A0Yp
         76nzt8yvlIrino5cHqFcJbuMZUvBXM66wIFMjx9RgcM2P3mlZWQwPTdd1lh4XmnlIe
         E3Ur255dU71PX9JoSJi/nsf9w/QnxKE3QNhdnOek=
Date:   Thu, 15 Oct 2020 20:12:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 131/156] checkpatch: fix multi-statement macro
 checks for while blocks.
Message-ID: <20201016031222.krxEUYL3S%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -5351,9 +5351,9 @@ sub process {
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
 
@@ -5394,6 +5394,7 @@ sub process {
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
 			    $dstat !~ /^(?:\#\s*$Ident|\#\s*$Constant)\s*$/ &&		# stringification #foo
 			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...} while (...); // do {...} while (...)
+			    $dstat !~ /^while\s*$Constant\s*$Constant\s*$/ &&		# while (...) {...}
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
 			    $dstat !~ /^do\s*{/ &&					# do {...
_
