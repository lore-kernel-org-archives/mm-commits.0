Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E924CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3C836103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhKKCzI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCzH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 841CE610A2;
        Thu, 11 Nov 2021 02:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599139;
        bh=iMIIPaHSQ7hAqdTJCuHmJQ2GI9Jq2RYpVJYG7ooTH34=;
        h=Date:From:To:Subject:From;
        b=UgXw2GJIxm3WiOHoTXo3LdqU6+AzdXfa269DR3goDvRcP8sTQ0YrncLzSUq7MLsss
         1Ju0HlrNInC9N4rJVWcohyxA9jShYccmB1p7d6TXkTjy7WGeXP4uvX/xWAzj8zxBXG
         LzHegy5z0FRaSeXk18qgG5Bt8RXeuSbyi9NWWnBA=
Date:   Wed, 10 Nov 2021 18:52:19 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org,
        rf@opensource.cirrus.com
Subject:  [merged] lib-uninline-simple_strntoull-as-well.patch
 removed from -mm tree
Message-ID: <20211111025219.jW9YH9fIL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: uninline simple_strntoull() as well
has been removed from the -mm tree.  Its filename was
     lib-uninline-simple_strntoull-as-well.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: lib: uninline simple_strntoull() as well

Codegen become bloated again after simple_strntoull() introduction

	add/remove: 0/0 grow/shrink: 0/4 up/down: 0/-224 (-224)
	Function                                     old     new   delta
	simple_strtoul                                 5       2      -3
	simple_strtol                                 23      20      -3
	simple_strtoull                              119      15    -104
	simple_strtoll                               155      41    -114

Link: https://lkml.kernel.org/r/YVmlB9yY4lvbNKYt@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/vsprintf.c~lib-uninline-simple_strntoull-as-well
+++ a/lib/vsprintf.c
@@ -53,8 +53,7 @@
 #include <linux/string_helpers.h>
 #include "kstrtox.h"
 
-static unsigned long long simple_strntoull(const char *startp, size_t max_chars,
-					   char **endp, unsigned int base)
+static noinline unsigned long long simple_strntoull(const char *startp, size_t max_chars, char **endp, unsigned int base)
 {
 	const char *cp;
 	unsigned long long result = 0ULL;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

elf-fix-overflow-in-total-mapping-size-calculation.patch

