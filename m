Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60107C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiC1Wsk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiC1Wsk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:48:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42B67B122
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7133760AEC
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 22:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE610C340F0;
        Mon, 28 Mar 2022 22:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648507617;
        bh=lYnFS9e04D/YdBnfDCu+UrOAE+sA15Cs3cBjxakj/vc=;
        h=Date:To:From:Subject:From;
        b=UlwH2i8OtU3yefppEc+/SarqIOYbinT+D+TSNzRGV+n9eiCGho3gOOlLFfMrbraEt
         lAOaArSANNTFo+mnBlL8W9lzjnlgU/h1N/VaaDf3A0A1n3d5X1SWcO6tbt/DxabIgV
         dPRZgB/JbcAjXR0LpNb1w7n22t8YXTxpXfPDadFM=
Date:   Mon, 28 Mar 2022 15:46:57 -0700
To:     mm-commits@vger.kernel.org, andy@kernel.org,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stringc-simplify-strspn.patch added to -mm tree
Message-Id: <20220328224657.BE610C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: simplify str[c]spn
has been added to the -mm tree.  Its filename is
     lib-stringc-simplify-strspn.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stringc-simplify-strspn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stringc-simplify-strspn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/string.c: simplify str[c]spn

Use strchr(), which makes them a lot shorter, and more obviously symmetric
in their treatment of accept/reject.  It also saves a little bit of .text;
bloat-o-meter for an arm build says

Function                                     old     new   delta
strcspn                                       92      76     -16
strspn                                       108      76     -32

While here, also remove a stray empty line before EXPORT_SYMBOL().

Link: https://lkml.kernel.org/r/20220328224119.3003834-2-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/lib/string.c~lib-stringc-simplify-strspn
+++ a/lib/string.c
@@ -517,21 +517,13 @@ EXPORT_SYMBOL(strnlen);
 size_t strspn(const char *s, const char *accept)
 {
 	const char *p;
-	const char *a;
-	size_t count = 0;
 
 	for (p = s; *p != '\0'; ++p) {
-		for (a = accept; *a != '\0'; ++a) {
-			if (*p == *a)
-				break;
-		}
-		if (*a == '\0')
-			return count;
-		++count;
+		if (!strchr(accept, *p))
+			break;
 	}
-	return count;
+	return p - s;
 }
-
 EXPORT_SYMBOL(strspn);
 #endif
 
@@ -544,17 +536,12 @@ EXPORT_SYMBOL(strspn);
 size_t strcspn(const char *s, const char *reject)
 {
 	const char *p;
-	const char *r;
-	size_t count = 0;
 
 	for (p = s; *p != '\0'; ++p) {
-		for (r = reject; *r != '\0'; ++r) {
-			if (*p == *r)
-				return count;
-		}
-		++count;
+		if (strchr(reject, *p))
+			break;
 	}
-	return count;
+	return p - s;
 }
 EXPORT_SYMBOL(strcspn);
 #endif
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-kconfigdebug-remove-more-config__value-indirections.patch
lib-test_stringc-add-strspn-and-strcspn-tests.patch
lib-stringc-simplify-strspn.patch

