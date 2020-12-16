Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F902C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8FCE23432
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgLPRKF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgLPRKF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:05 -0500
Date:   Wed, 16 Dec 2020 09:09:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138589;
        bh=x7+ywwtV4ZdlV3bx0tH9qpBZfxTQsKcaC3D/rPdLGTw=;
        h=From:To:Subject:From;
        b=KQLkj67zV4NInTTaKv9YzOmJW1BDJT3eRBfk7MHxCEwW7VZaTmxNJZickUoo/IOh4
         bUg2YT1OvpBFwLt8qS96G7IadYRIFF0t1sP8pJczNGvV/NUgJiDAhDCzy4i+Z4vZ72
         bbDC1JB51bJH6qnisbxyfkdCFdLtoQvmP+obHwkI=
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-prefer-static-const-declarations.patch removed from -mm tree
Message-ID: <20201216170949.7VCdAR9oq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer static const declarations
has been removed from the -mm tree.  Its filename was
     checkpatch-prefer-static-const-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are


