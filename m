Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CE4C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA52861469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbhGAB5m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238543AbhGAB5m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A827161468;
        Thu,  1 Jul 2021 01:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104512;
        bh=4Mpa2rwdbCPvVFcSJxxOL9nBYSlpttWLrsHinkDW53g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NUjnVtaNlp8LJUGPeCs9AYMLZayDhZfDLSQVWiBs8BGKLoepO4gzbChIIh/m+/arv
         sUCfTvJbiNP+n6ucbpNqIPzuhoUrm4/N38gwWIiMDBB4Skc07LfC+Ph5TVIyX5M4Ei
         TBX4C4+KPlIfBJmP8NJGGdAfS9gZgkwn2sDmcLzM=
Date:   Wed, 30 Jun 2021 18:55:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 150/192] lib/string_helpers: drop indentation
 level in string_escape_mem()
Message-ID: <20210701015511.sGCCmfpPg%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
