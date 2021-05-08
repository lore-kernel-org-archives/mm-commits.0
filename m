Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C483EC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A343E61432
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhEHWoy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWox (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 827D361421;
        Sat,  8 May 2021 22:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513830;
        bh=O6nTQ/Bexbzmh5hhlqPBRaTQZctfTDPHmq2ts53iyQU=;
        h=Date:From:To:Subject:From;
        b=fopee+REDrn7GQHEooAZI3D4WHlveXUILasi6T17DBUWVKXsnuRFDEjuFfpUSy8lk
         eKJB2LJUCPd8R+cva8895ExmbZIq7XeAynn/OFtPjZiapY4BvGmCRfHgsZ01Js8i0z
         1BsdNhqBskrXE9hLDuwoMzx0sszjofoyOruQPZ6s=
Date:   Sat, 08 May 2021 15:43:50 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, daizhiyuan@phytium.com.cn, glider@google.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-kasan-switch-from-strlcpy-to-strscpy.patch
 removed from -mm tree
Message-ID: <20210508224350.eefhPEvHe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: switch from strlcpy to strscpy
has been removed from the -mm tree.  Its filename was
     mm-kasan-switch-from-strlcpy-to-strscpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are


