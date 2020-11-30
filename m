Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83DCC64E8A
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 21:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8928322210
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 21:31:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wHezuPNM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388636AbgK3VbC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 16:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388656AbgK3VbC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Nov 2020 16:31:02 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCC2221FD;
        Mon, 30 Nov 2020 21:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606771815;
        bh=SuMz5h0GIVgVzhEZ7NZfKIDODI/LT4dUm7BhTaO7UbY=;
        h=Date:From:To:Subject:From;
        b=wHezuPNM1L0pWOPsfXdSWk4YYMMu7YTmKsMvrcqis283gBFp5awC/8yg+LnUCMVtC
         Q+dYS4fmQ8xtTsI81/9E/mX0Tge8wAzjhQJH9MGxdmfzPjYTS8SCc8yzyz28WYWhAC
         z5X/9x7PdZryTUFt3tGSy12nojfP+x27R34Qm0Pg=
Date:   Mon, 30 Nov 2020 13:30:14 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, elver@google.com,
        linux@armlinux.org.uk, mm-commits@vger.kernel.org,
        valdis.kletnieks@vt.edu
Subject:  +
 kasan-shadow-declarations-only-for-software-modes-fix.patch added to -mm
 tree
Message-ID: <20201130213014.7rfOm2_ke%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: fix build issue with asmlinkage
has been added to the -mm tree.  Its filename is
     kasan-shadow-declarations-only-for-software-modes-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-shadow-declarations-only-for-software-modes-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-shadow-declarations-only-for-software-modes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Subject: kasan, mm: fix build issue with asmlinkage

commit 2df573d2ca4c1ce6ea33cb7849222f771e759211
Author: Andrey Konovalov <andreyknvl@google.com>
Date:   Tue Nov 24 16:45:08 2020 +1100

    kasan: shadow declarations only for software modes

introduces a build failure when it removed an include for linux/pgtable.h
It actually only needs linux/linkage.h

Test builds on both x86_64 and arm build cleanly

Link: https://lkml.kernel.org/r/35126.1606402815@turing-police
Link: https://lore.kernel.org/linux-arm-kernel/24105.1606397102@turing-police/
Fixes:   2df573d2ca4c ("kasan: shadow declarations only for software modes")
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/kasan.h~kasan-shadow-declarations-only-for-software-modes-fix
+++ a/include/linux/kasan.h
@@ -11,6 +11,7 @@ struct task_struct;
 
 #ifdef CONFIG_KASAN
 
+#include <linux/linkage.h>
 #include <asm/kasan.h>
 
 /* kasan_data struct is used in KUnit tests for KASAN expected failures */
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are

kasan-shadow-declarations-only-for-software-modes-fix.patch

