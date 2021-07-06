Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F9CC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6D6A61CAB
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhGFTYz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhGFTYy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6905061CAA;
        Tue,  6 Jul 2021 19:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599334;
        bh=i/y0eR5jpzZcIUfs2gmHWw3j+/Z1NN7wq1xMQIRfR1E=;
        h=Date:From:To:Subject:From;
        b=q8zNvWD3TOpAzetvHibK4uMfZaTAG8A1FcHn5fZaN6tXVGFQDQLbQZXuU7e2iYbLE
         bFcp8skMt6yftqNH+9WihsRNiVnAGTOUFBXvsGLJ6dWT6bP5Wai8OwNQDM53KevswD
         gcPYHskC0a+cc3Q9wdqJO53kQtKAoGOft1io5Mno=
Date:   Tue, 06 Jul 2021 12:22:14 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 lib-test-string_helpers-print-flags-in-hexadecimal-format.patch removed
 from -mm tree
Message-ID: <20210706192214.bdmuOKE8z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-string_helpers: print flags in hexadecimal format
has been removed from the -mm tree.  Its filename was
     lib-test-string_helpers-print-flags-in-hexadecimal-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


