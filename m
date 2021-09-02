Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7A2C432BE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 01:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6FA8610A8
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 01:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhIBBq3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Sep 2021 21:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhIBBq3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Sep 2021 21:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D92610A4;
        Thu,  2 Sep 2021 01:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630547131;
        bh=2n5nRjtFPS8Vc7mBO9ulVAJTPzYMNrch+ilZPTK1v4w=;
        h=Date:From:To:Subject:From;
        b=MBAAOdxOvHxFA36e8CjsaG4IX35XUCA7pag6pa1yjLEE/ICBI8Z2TZ8Nw/CzvWKZa
         RgBZihhYgtghX8HijKZfSbdf4ejTqWgTsuXRBtr7RGVpSmDY4CFOUiVIijsbPub+5u
         jY9Q0I4ykRkguCaKMAv3H/mDjSM7rgpVlPYx5PzY=
Date:   Wed, 01 Sep 2021 18:45:30 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, david@redhat.com, mm-commits@vger.kernel.org,
        o451686892@gmail.com
Subject:  +
 mm-early_ioremapc-remove-redundant-early_ioremap_shutdown.patch added to
 -mm tree
Message-ID: <20210902014530.1dcdf8N2t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap.c: remove redundant early_ioremap_shutdown()
has been added to the -mm tree.  Its filename is
     mm-early_ioremapc-remove-redundant-early_ioremap_shutdown.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-early_ioremapc-remove-redundant-early_ioremap_shutdown.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-early_ioremapc-remove-redundant-early_ioremap_shutdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weizhao Ouyang <o451686892@gmail.com>
Subject: mm/early_ioremap.c: remove redundant early_ioremap_shutdown()

early_ioremap_reset() reserved a weak function so that architectures can
provide a specific cleanup.  Now no architectures use it, remove this
redundant function.

Link: https://lkml.kernel.org/r/20210901082917.399953-1-o451686892@gmail.com
Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/early_ioremap.h |    6 ------
 mm/early_ioremap.c                  |    5 -----
 2 files changed, 11 deletions(-)

--- a/include/asm-generic/early_ioremap.h~mm-early_ioremapc-remove-redundant-early_ioremap_shutdown
+++ a/include/asm-generic/early_ioremap.h
@@ -19,12 +19,6 @@ extern void *early_memremap_prot(resourc
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 extern void early_memunmap(void *addr, unsigned long size);
 
-/*
- * Weak function called by early_ioremap_reset(). It does nothing, but
- * architectures may provide their own version to do any needed cleanups.
- */
-extern void early_ioremap_shutdown(void);
-
 #if defined(CONFIG_GENERIC_EARLY_IOREMAP) && defined(CONFIG_MMU)
 /* Arch-specific initialization */
 extern void early_ioremap_init(void);
--- a/mm/early_ioremap.c~mm-early_ioremapc-remove-redundant-early_ioremap_shutdown
+++ a/mm/early_ioremap.c
@@ -38,13 +38,8 @@ pgprot_t __init __weak early_memremap_pg
 	return prot;
 }
 
-void __init __weak early_ioremap_shutdown(void)
-{
-}
-
 void __init early_ioremap_reset(void)
 {
-	early_ioremap_shutdown();
 	after_paging_init = 1;
 }
 
_

Patches currently in -mm which might be from o451686892@gmail.com are

mm-early_ioremapc-remove-redundant-early_ioremap_shutdown.patch

