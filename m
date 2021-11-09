Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D576DC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE2FF6124D
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhKICf1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICf0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DC9761207;
        Tue,  9 Nov 2021 02:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425161;
        bh=gLvCIZzkF6wkrrje1AA7SZ105gqis/4MBNBzQOu6AKA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Yes3Txmf8VuN+Y6TQsTB6eUVGYLrU5QRn0HilTsT0UpTjw1vrP5jFlNPU/bxRck3a
         qf6Ze9V6wGt2QlsCo02gyXXuOrl09/abeDpH9BpRUYMm1m70JRFP1bzL6wZSobjZaw
         8Bc3wzkY8F3MX5Qwq7U0j/OUtRHzFMVDJYR0jbm0=
Date:   Mon, 08 Nov 2021 18:32:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 24/87] include/linux/generic-radix-tree.h: replace
 kernel.h with the necessary inclusions
Message-ID: <20211109023241.0I8DheIWD%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/generic-radix-tree.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

[akpm@linux-foundation.org: include math.h for round_up()]
Link: https://lkml.kernel.org/r/20211027150548.80042-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/generic-radix-tree.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/generic-radix-tree.h~generic-radix-tree-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/generic-radix-tree.h
@@ -38,8 +38,9 @@
 
 #include <asm/page.h>
 #include <linux/bug.h>
-#include <linux/kernel.h>
 #include <linux/log2.h>
+#include <linux/math.h>
+#include <linux/types.h>
 
 struct genradix_root;
 
_
