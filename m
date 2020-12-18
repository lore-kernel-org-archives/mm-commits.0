Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A374C4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 20:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D508F22C9D
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 20:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgLRUHr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgLRUHr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 15:07:47 -0500
Date:   Fri, 18 Dec 2020 12:07:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608322026;
        bh=CXIQZg5GyVp5qPIf1lwExRhGtIcodJynzkrzH31FckU=;
        h=From:To:Subject:From;
        b=BSwlNVwYWF9IWSE0CUVwHzPLOjAhWB1s3tKCvbJf3ITdyFSfzf7PTRk4oaLtt6rvp
         CQfIKKeRMgQeRw+Gv+pletbvQecPTU6YEOgukwihJHi39JcMPvtjunp9lbhxTXffcF
         +ncZ0IVhXpFUltLEl+jI7z1cRMGxAqF9OXMIIfbM=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, linux@armlinux.org.uk,
        elver@google.com, aryabinin@virtuozzo.com, andreyknvl@google.com,
        valdis.kletnieks@vt.edu
Subject:  [folded-merged]
 kasan-shadow-declarations-only-for-software-modes-fix.patch removed from -mm
 tree
Message-ID: <20201218200706.tB0_L%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: fix build issue with asmlinkage
has been removed from the -mm tree.  Its filename was
     kasan-shadow-declarations-only-for-software-modes-fix.patch

This patch was dropped because it was folded into kasan-shadow-declarations-only-for-software-modes.patch

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

kasan-shadow-declarations-only-for-software-modes.patch

