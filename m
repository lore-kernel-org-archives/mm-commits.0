Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D55CC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiEJEXU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236403AbiEJEWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447E51C12DE
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2492B61758
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786ECC385A6;
        Tue, 10 May 2022 04:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156263;
        bh=A+h2tk2e/QxhAa+EtFzmL8jP8BStZjSVY9gyv0xT4kM=;
        h=Date:To:From:Subject:From;
        b=jjpr5UjFrCX6kcs/wqyOEm2NmPifvD91lI2NW2LV7QVe0rqYI7qKaI6XqcAiQHbgq
         UDgKMDhXUfmshHWFA4y1Kg/9egeBE0V9nkPtGUuX1ps5nwhkbZ2zwDBW+MDRgklzJq
         tMhfvT2QoXuX0Gyw3VsQxO5OPqdceht+gF6O8Iaw=
Date:   Mon, 09 May 2022 21:17:42 -0700
To:     mm-commits@vger.kernel.org, andy@kernel.org,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-stringc-simplify-strspn.patch removed from -mm tree
Message-Id: <20220510041743.786ECC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/string.c: simplify str[c]spn
has been removed from the -mm tree.  Its filename was
     lib-stringc-simplify-strspn.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


