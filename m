Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B309C433E9
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1400722CB8
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbhAQCMI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jan 2021 21:12:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbhAQCMH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 16 Jan 2021 21:12:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EB6A22D57;
        Sun, 17 Jan 2021 02:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610849463;
        bh=yhoiB6id23yikiGVT6ASO9SQHNlM/3AyukVqw5MuVCM=;
        h=Date:From:To:Subject:From;
        b=Uuv0ovhlW4Ws1oLTTrdwJSyjf0cVl19LxvsgDcS8cLX1iPc20BODD4z6KK9CoJ9VL
         9HSs2LS2Lwpp1mGBfydlJY4KqxhAjOWzMbtWjI2IfVlDIpD7AADHr7SeAK0Za6DNjx
         jQgqv9oSXwjwon/zmMo7w8c3urFW05BJncalDxPM=
Date:   Sat, 16 Jan 2021 18:11:03 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, dan.carpenter@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  [merged] mmhwpoison-fix-printing-of-page-flags.patch
 removed from -mm tree
Message-ID: <20210117021103.lasWEZF8w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: fix printing of page flags
has been removed from the -mm tree.  Its filename was
     mmhwpoison-fix-printing-of-page-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: fix printing of page flags

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


