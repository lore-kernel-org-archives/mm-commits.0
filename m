Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A319C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 00:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 410CC23A7C
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jan 2021 00:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbhAIA5S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jan 2021 19:57:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbhAIA5S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 Jan 2021 19:57:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8AD623A75;
        Sat,  9 Jan 2021 00:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610153798;
        bh=nYWQvX/y8eccvCuBCNjlsLazgjL83rtmjqIDbd0zifY=;
        h=Date:From:To:Subject:From;
        b=helhpjok/7Pahv4ei5vHp959Wyv2ptOgRrRNvfBvpFCO+C1XRixukDJf54DlIl4je
         QvFASW739nSxQhGTEGFMNhNPLZdRjnSr3Pe8Xz1rcdGhzRY0W/LjBV1746H8tmGsF2
         iobXAH3EYffWc6LZvnRcmWVCNExHorN9EguniSkM=
Date:   Fri, 08 Jan 2021 16:56:37 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, dan.carpenter@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  + mmhwpoison-fix-printing-of-page-flags.patch added to
 -mm tree
Message-ID: <20210109005637.8TlxwXFXL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: Fix printing of page flags
has been added to the -mm tree.  Its filename is
     mmhwpoison-fix-printing-of-page-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-fix-printing-of-page-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-fix-printing-of-page-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: Fix printing of page flags

Format %pG expects a lower case 'p' in order to print the flags.
Fix it.

Link: https://lkml.kernel.org/r/20210108085202.4506-1-osalvador@suse.de
Fixes: 8295d535e2aa ("mm,hwpoison: refactor get_any_page")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mmhwpoison-fix-printing-of-page-flags
+++ a/mm/memory-failure.c
@@ -1940,7 +1940,7 @@ retry:
 			goto retry;
 		}
 	} else if (ret == -EIO) {
-		pr_info("%s: %#lx: unknown page type: %lx (%pGP)\n",
+		pr_info("%s: %#lx: unknown page type: %lx (%pGp)\n",
 			 __func__, pfn, page->flags, &page->flags);
 	}
 
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-fix-printing-of-page-flags.patch

