Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08715C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1AC023130
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgLPEoq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgLPEoq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:46 -0500
Date:   Tue, 15 Dec 2020 20:44:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093871;
        bh=rB2man6EMyPry/qrFdG+b6vK2MPuxTblV+rYWeqCpso=;
        h=From:To:Subject:In-Reply-To:From;
        b=nAFQlvR1wku9jQm1TjHf8OARU7ryhM0Aymc2kaMJsZVGdf0FOH+lElTT9nZq01quv
         1A+3cmtNKvASCBO+8Icz7sgiufv1FSlQuH8pZq8RDiXTzxywq8cGsfo9Kn11+wldk8
         FoVysPx1JEolrre8b/fO4UymHkrYFTHvk+1Efuyk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 40/95] checkpatch: prefer static const
 declarations
Message-ID: <20201216044430.HxlOUQnZ_%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: prefer static const declarations

There are about 100,000 uses of 'static const <type>' but about 400 uses
of 'static <type> const' in the kernel where type is not a pointer.

The kernel almost always uses "static const" over "const static" as there
is a compiler warning for that declaration style.

But there is no compiler warning for "static <type> const".

So add a checkpatch warning for the atypical declaration uses of.

	const static <type> <foo>
and
	static <type> const <foo>

For example:

$ ./scripts/checkpatch.pl -f --emacs --quiet --nosummary -types=static_const arch/arm/crypto/aes-ce-glue.c
arch/arm/crypto/aes-ce-glue.c:75: WARNING: Move const after static - use 'static const u8'
#75: FILE: arch/arm/crypto/aes-ce-glue.c:75:
+	static u8 const rcon[] = {

Link: https://lkml.kernel.org/r/4b863be68e679546b40d50b97a4a806c03056a1c.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-prefer-static-const-declarations
+++ a/scripts/checkpatch.pl
@@ -4232,6 +4232,18 @@ sub process {
 			}
 		}
 
+# check for const static or static <non ptr type> const declarations
+# prefer 'static const <foo>' over 'const static <foo>' and 'static <foo> const'
+		if ($sline =~ /^\+\s*const\s+static\s+($Type)\b/ ||
+		    $sline =~ /^\+\s*static\s+($BasicType)\s+const\b/) {
+			if (WARN("STATIC_CONST",
+				 "Move const after static - use 'static const $1'\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\bconst\s+static\b/static const/;
+				$fixed[$fixlinenr] =~ s/\bstatic\s+($BasicType)\s+const\b/static const $1/;
+			}
+		}
+
 # check for non-global char *foo[] = {"bar", ...} declarations.
 		if ($line =~ /^.\s+(?:static\s+|const\s+)?char\s+\*\s*\w+\s*\[\s*\]\s*=\s*\{/) {
 			WARN("STATIC_CONST_CHAR_ARRAY",
_
