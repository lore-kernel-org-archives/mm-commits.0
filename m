Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7AAC47096
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 02:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86C196140C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 02:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFDCcy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 22:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhFDCcy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 22:32:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA3261407;
        Fri,  4 Jun 2021 02:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622773868;
        bh=nB6Gl1JhRJXxOrseZMtKCU2OHkfvClhXVr++Q4tDum4=;
        h=Date:From:To:Subject:From;
        b=lmtfRtwUpCywF3QDsMJ0iI7rewf3hLNG/SjBgE2ytM7kph5HjM/7qwRKRfnlBVT9Y
         iy8nbb2IgPm5O4GFbwASkF41qvduuiwbhcW3mcgRsBlWFCdEwF33cCa1LELeXJH6e5
         bUtdg3F5X2wr0JxAP5kROvOCazWGalSiqCktzsGc=
Date:   Thu, 03 Jun 2021 19:31:08 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, js07.lee@samsung.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-report-which-part-of-mem-is-being-freed-on-initmem-case.patch added to
 -mm tree
Message-ID: <20210604023108.SYeIUzZ6e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: report which part of mem is being freed on initmem case
has been added to the -mm tree.  Its filename is
     mm-report-which-part-of-mem-is-being-freed-on-initmem-case.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-report-which-part-of-mem-is-being-freed-on-initmem-case.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-report-which-part-of-mem-is-being-freed-on-initmem-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jungseung Lee <js07.lee@samsung.com>
Subject: mm: report which part of mem is being freed on initmem case

Add the details for figuring out which parts of the kernel image is being
freed on initmem case.

Before:
   Freeing unused kernel memory: 1024K

After:
   Freeing unused kernel image (initmem) memory: 1024K

Link: https://lkml.kernel.org/r/1622706274-4533-1-git-send-email-js07.lee@samsung.com
Signed-off-by: Jungseung Lee <js07.lee@samsung.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-report-which-part-of-mem-is-being-freed-on-initmem-case
+++ a/include/linux/mm.h
@@ -2417,7 +2417,7 @@ static inline unsigned long free_initmem
 	extern char __init_begin[], __init_end[];
 
 	return free_reserved_area(&__init_begin, &__init_end,
-				  poison, "unused kernel");
+				  poison, "unused kernel image (initmem)");
 }
 
 static inline unsigned long get_num_physpages(void)
_

Patches currently in -mm which might be from js07.lee@samsung.com are

mm-report-which-part-of-mem-is-being-freed-on-initmem-case.patch

