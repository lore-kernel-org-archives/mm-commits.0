Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A25C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B07B061481
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhD3GAc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhD3GAc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 680B06147D;
        Fri, 30 Apr 2021 05:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762383;
        bh=5Q24tDluCQgxazCjDcNMK6jUba2DTu2AgyHldKu/t34=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tlElwkUvzqn/UeguRviMpV7Olj2O0ZLE6x04purbfObD/wb/oKhRqBMI6EApp33AL
         2aHURmJa2QXzYZQ0wtw74+AiFX6+ySVjZ7r5sIyFH2tK5kaeDI/PiEzOa+O1a2x1es
         wvKbHLu7nOh3YtQpJ3woO09jTrsmqtkPp6NyvloE=
Date:   Thu, 29 Apr 2021 22:59:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        daizhiyuan@phytium.com.cn, glider@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 127/178] mm/kasan: switch from strlcpy to strscpy
Message-ID: <20210430055943.-GxILSAQQ%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/kasan: switch from strlcpy to strscpy

strlcpy is marked as deprecated in Documentation/process/deprecated.rst,
and there is no functional difference when the caller expects truncation
(when not checking the return value).  strscpy is relatively better as it
also avoids scanning the whole source string.

Link: https://lkml.kernel.org/r/1613970647-23272-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Acked-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/report_generic.c~mm-kasan-switch-from-strlcpy-to-strscpy
+++ a/mm/kasan/report_generic.c
@@ -148,7 +148,7 @@ static bool __must_check tokenize_frame_
 		}
 
 		/* Copy token (+ 1 byte for '\0'). */
-		strlcpy(token, *frame_descr, tok_len + 1);
+		strscpy(token, *frame_descr, tok_len + 1);
 	}
 
 	/* Advance frame_descr past separator. */
_
