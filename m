Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3278C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F0A61242
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbhKICgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235794AbhKICgH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A308C60FC1;
        Tue,  9 Nov 2021 02:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425202;
        bh=MtiibVnAtK2cDcpMkbTo11je5LdzJ2FZvkK+hFpqtaw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cKTS+8QC6p6Ejuqs9/5uXeRX3qVNDcZLhxQq4kEqzrpRvKg5FPiHomavb7dNdrEkw
         lbLJw6q8SPqWwT9P6jsfLEI0NRRiUJClbPhKptggtxAOrxs6sJoOjzPj/qM3N7Y9qB
         EWGqlnv0zrhskevX6fG3cK3l3nvcZYDrp2TJ5rJY=
Date:   Mon, 08 Nov 2021 18:33:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rf@opensource.cirrus.com,
        torvalds@linux-foundation.org
Subject:  [patch 37/87] lib: uninline simple_strntoull() as well
Message-ID: <20211109023322.c5_jln5YN%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
