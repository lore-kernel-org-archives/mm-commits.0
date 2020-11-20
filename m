Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FF1C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 21:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F56122264
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 21:07:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hc3MWWyU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgKTVHn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 16:07:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgKTVHn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 16:07:43 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DACC422227;
        Fri, 20 Nov 2020 21:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605906463;
        bh=2fvngyIYxyLCf+JFxlk4yAwM2zU3OZh1NVeb57xx1D8=;
        h=Date:From:To:Subject:From;
        b=hc3MWWyUM8e2V7tvHl+Euoad/rye1oZb/KxyuDtHJmnpF5N/YFyH4vWETHbOnFJrS
         erowqAF6nGICl6f1H/34F60iu/7y1FyN57cE5l/X4KKViNEz3GbW2f9Vzq4GLZpWmt
         Au7yr1cMODCTf6sqnT7pAiOkjVwRgWQ94PtytQUU=
Date:   Fri, 20 Nov 2020 13:07:42 -0800
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, mm-commits@vger.kernel.org
Subject:  + mm-fix-fall-through-warnings-for-clang.patch added to
 -mm tree
Message-ID: <20201120210742.s_EmhX5P0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix fall-through warnings for Clang
has been added to the -mm tree.  Its filename is
     mm-fix-fall-through-warnings-for-clang.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-fall-through-warnings-for-clang.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-fall-through-warnings-for-clang.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: mm: fix fall-through warnings for Clang

In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple of
warnings by explicitly adding a break statement instead of just letting
the code fall through to the next, and by adding a fallthrough
pseudo-keyword in places where the code is intended to fall through.

Link: https://github.com/KSPP/linux/issues/115
Link: https://lkml.kernel.org/r/f5756988b8842a3f10008fbc5b0a654f828920a9.1605896059.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 +
 mm/vmscan.c  |    1 +
 2 files changed, 2 insertions(+)

--- a/mm/mm_init.c~mm-fix-fall-through-warnings-for-clang
+++ a/mm/mm_init.c
@@ -173,6 +173,7 @@ static int __meminit mm_compute_batch_no
 	case MEM_ONLINE:
 	case MEM_OFFLINE:
 		mm_compute_batch(sysctl_overcommit_memory);
+		break;
 	default:
 		break;
 	}
--- a/mm/vmscan.c~mm-fix-fall-through-warnings-for-clang
+++ a/mm/vmscan.c
@@ -1369,6 +1369,7 @@ static unsigned int shrink_page_list(str
 				if (PageDirty(page) || PageWriteback(page))
 					goto keep_locked;
 				mapping = page_mapping(page);
+				fallthrough;
 			case PAGE_CLEAN:
 				; /* try to free the page below */
 			}
_

Patches currently in -mm which might be from gustavoars@kernel.org are

mm-fix-fall-through-warnings-for-clang.patch
lib-stackdepotc-replace-one-element-array-with-flexible-array-member.patch
lib-stackdepotc-use-flex_array_size-helper-in-memcpy.patch
lib-stackdepotc-use-array_size-helper-in-jhash2.patch

