Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74EAC07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB2161CAA
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhGFTYq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhGFTYp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F65B61CA3;
        Tue,  6 Jul 2021 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599326;
        bh=KAB/1DU0DXW2qX5GHrcO4O6bzRXlx6gcSgzaNKhbRN4=;
        h=Date:From:To:Subject:From;
        b=s2kLoLvGtWr5Hmz2FVyZuTExonnt4dXG47FwUFW742UIYJgSYjvIhiH5TC0Lgitdy
         dlyecur11X9YMioE7q8p1Z9GiiFRb/vcaI6YcoY1qzzwzRNevSg0ZRP6irE9KNiWE7
         EuD0189/3oJq0jq1UW8PH9Gkf46rsofWL1MzMH8A=
Date:   Tue, 06 Jul 2021 12:22:06 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 lib-string_helpers-drop-indentation-level-in-string_escape_mem.patch
 removed from -mm tree
Message-ID: <20210706192206.sR-CA_8wO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: drop indentation level in string_escape_mem()
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-drop-indentation-level-in-string_escape_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/string_helpers: drop indentation level in string_escape_mem()

The only one conditional is left on the upper level, move the rest to the
same level and drop indentation level.  No functional changes.

Link: https://lkml.kernel.org/r/20210504180819.73127-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |   46 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/lib/string_helpers.c~lib-string_helpers-drop-indentation-level-in-string_escape_mem
+++ a/lib/string_helpers.c
@@ -515,29 +515,29 @@ int string_escape_mem(const char *src, s
 		 * In these cases we just pass through a character to the
 		 * output buffer.
 		 */
-		if (is_dict && !strchr(only, c)) {
-			/* do nothing */
-		} else {
-			if (isprint(c) &&
-			    flags & ESCAPE_NP && escape_passthrough(c, &p, end))
-				continue;
-
-			if (flags & ESCAPE_SPACE && escape_space(c, &p, end))
-				continue;
-
-			if (flags & ESCAPE_SPECIAL && escape_special(c, &p, end))
-				continue;
-
-			if (flags & ESCAPE_NULL && escape_null(c, &p, end))
-				continue;
-
-			/* ESCAPE_OCTAL and ESCAPE_HEX always go last */
-			if (flags & ESCAPE_OCTAL && escape_octal(c, &p, end))
-				continue;
-
-			if (flags & ESCAPE_HEX && escape_hex(c, &p, end))
-				continue;
-		}
+		if (is_dict && !strchr(only, c) &&
+					  escape_passthrough(c, &p, end))
+			continue;
+
+		if (isprint(c) &&
+		    flags & ESCAPE_NP && escape_passthrough(c, &p, end))
+			continue;
+
+		if (flags & ESCAPE_SPACE && escape_space(c, &p, end))
+			continue;
+
+		if (flags & ESCAPE_SPECIAL && escape_special(c, &p, end))
+			continue;
+
+		if (flags & ESCAPE_NULL && escape_null(c, &p, end))
+			continue;
+
+		/* ESCAPE_OCTAL and ESCAPE_HEX always go last */
+		if (flags & ESCAPE_OCTAL && escape_octal(c, &p, end))
+			continue;
+
+		if (flags & ESCAPE_HEX && escape_hex(c, &p, end))
+			continue;
 
 		escape_passthrough(c, &p, end);
 	}
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


