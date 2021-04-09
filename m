Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7226C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C417D61178
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhDIU1z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234159AbhDIU1z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7FA36113A;
        Fri,  9 Apr 2021 20:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000062;
        bh=ropNXJ0RUOz2cNxSQ1Npm+PVss05ZV7zCBurMb53u54=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yLukpdUIfsqIRoWKgViwcGZOQrRTEgaYGkbhrUERx99sILcmL1aFj6bJDNy0aa0NJ
         o6d/HzDN5T3iobG8DyF1aerfAZrF6aVRT0qnLwJ1hmT5yu+2IWKEc9hRtnZFmDInZq
         pnTLyIHOdOiJjz+ds0s8+F7JtK+uSblBG6m44cUM=
Date:   Fri, 09 Apr 2021 13:27:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, elver@google.com, glider@google.com,
        linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 14/16] lib/test_kasan_module.c: suppress unused
 var warning
Message-ID: <20210409202741.xZ0aCbu7I%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/test_kasan_module.c: suppress unused var warning

Local `unused' is intentionally unused - it is there to suppress
__must_check warnings.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lkml.kernel.org/r/202104050216.HflRxfJm-lkp@intel.com
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan_module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kasan_module.c~lib-test_kasan_modulec-suppress-unused-var-warning
+++ a/lib/test_kasan_module.c
@@ -22,7 +22,7 @@ static noinline void __init copy_user_te
 	char *kmem;
 	char __user *usermem;
 	size_t size = 10;
-	int unused;
+	int __maybe_unused unused;
 
 	kmem = kmalloc(size, GFP_KERNEL);
 	if (!kmem)
_
