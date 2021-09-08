Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85629C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71E256113C
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347339AbhIHC5T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347443AbhIHC5O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 516AB60E52;
        Wed,  8 Sep 2021 02:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069767;
        bh=bTET6WtxaFFA3PxjQ1OEseughZtMui/CPs+xk1yLi8o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=T6maq6UEydlGcBlSRRsDyxAo9COIPTWZZqb9wnxVcb8JOJPuYJBSYyzLguKHm6pJ3
         yS9f12e+Mti3gIMlE/PsSIGLFGRYCzOw/kEefXwJjuIDmXbR1KIZT8GSlTwv/RLaJC
         uct+V0Egg7OdO+1vrqtigLZXBgx3xEuBYiFDkIls=
Date:   Tue, 07 Sep 2021 19:56:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, david@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        o451686892@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 056/147] mm/early_ioremap.c: remove redundant
 early_ioremap_shutdown()
Message-ID: <20210908025606.tVQuv0bIc%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
