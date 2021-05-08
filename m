Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEBFC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 352616140E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhEHWlR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhEHWlR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F8C161402;
        Sat,  8 May 2021 22:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513614;
        bh=odJvcWVOZJvoBh5zQYnGrtFxGAuxmt5qoC/xuPM+5z8=;
        h=Date:From:To:Subject:From;
        b=k2HzpJyEcPoMkm9H0EXfYmNTY33vAV5G0rI5U1UlBBjru9NQqWbz8riP3eSG8MkE7
         DbEhLbIb+tNHpYO0QB3YCW/ZG+vx3VZq4c/wPO9r/NUvcPEYzGz3FmtBGkRkf/stex
         tBWhjaZBAsRsuAeHPleUU1l8P/Mc0yAX/nfP1XYE=
Date:   Sat, 08 May 2021 15:40:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org, willy@infradead.org
Subject:  [merged]
 mm-page_owner-use-kstrtobool-to-parse-bool-option.patch removed from -mm
 tree
Message-ID: <20210508224014.7EwXi7st0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_owner: use kstrtobool() to parse bool option
has been removed from the -mm tree.  Its filename was
     mm-page_owner-use-kstrtobool-to-parse-bool-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_owner: use kstrtobool() to parse bool option

I tried to use page_owner=1 for a while noticed too late it had no effect
as opposed to similar init_on_alloc=1 (these work).

Let's make them consistent.

The change decreses binary size slightly:
   text    data     bss     dec     hex filename
  12408     321      17   12746    31ca mm/page_owner.o.before
  12320     321      17   12658    3172 mm/page_owner.o.after

Link: https://lkml.kernel.org/r/20210401210909.3532086-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-use-kstrtobool-to-parse-bool-option
+++ a/mm/page_owner.c
@@ -42,13 +42,7 @@ static void init_early_allocated_pages(v
 
 static int __init early_page_owner_param(char *buf)
 {
-	if (!buf)
-		return -EINVAL;
-
-	if (strcmp(buf, "on") == 0)
-		page_owner_enabled = true;
-
-	return 0;
+	return kstrtobool(buf, &page_owner_enabled);
 }
 early_param("page_owner", early_page_owner_param);
 
_

Patches currently in -mm which might be from slyfox@gentoo.org are


