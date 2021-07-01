Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4189C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F63F61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbhGAB5y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB5y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 942F96141A;
        Thu,  1 Jul 2021 01:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104523;
        bh=p2RllxadCbIusKUbC7ewkpNnDEyDXLUR8LAolvOg/f8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rOluH3KyvKMA4GXo0o761TZNY8A7Dhx8E9W/veFP+sAgI12BDc40vze0bcwZxrZC9
         b3KH1MITs0OWTLYtxvHiGZ+iZ33a4pF7lsZLw0Y7etucM/JwXQXCSBeG+lXAcTYoVq
         yEcYQVKeamAnZudGd4i2yNoXyDJzwfiwM2kO25JA=
Date:   Wed, 30 Jun 2021 18:55:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 154/192] lib/test-string_helpers: print flags in
 hexadecimal format
Message-ID: <20210701015523.QwafX-mc5%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test-string_helpers: print flags in hexadecimal format

Since flags are bitmapped, it's better to print them in hexadecimal
format.

Link: https://lkml.kernel.org/r/20210504180819.73127-8-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-string_helpers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test-string_helpers.c~lib-test-string_helpers-print-flags-in-hexadecimal-format
+++ a/lib/test-string_helpers.c
@@ -19,7 +19,7 @@ static __init bool test_string_check_buf
 	if (q_real == q_test && !memcmp(out_test, out_real, q_test))
 		return true;
 
-	pr_warn("Test '%s' failed: flags = %u\n", name, flags);
+	pr_warn("Test '%s' failed: flags = %#x\n", name, flags);
 
 	print_hex_dump(KERN_WARNING, "Input: ", DUMP_PREFIX_NONE, 16, 1,
 		       in, p, true);
@@ -290,7 +290,7 @@ test_string_escape_overflow(const char *
 
 	q_real = string_escape_mem(in, p, NULL, 0, flags, esc);
 	if (q_real != q_test)
-		pr_warn("Test '%s' failed: flags = %u, osz = 0, expected %d, got %d\n",
+		pr_warn("Test '%s' failed: flags = %#x, osz = 0, expected %d, got %d\n",
 			name, flags, q_test, q_real);
 }
 
_
