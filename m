Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29C2C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0CA611C9
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346952AbhIIVEX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347746AbhIIVDa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 953A8611C7;
        Thu,  9 Sep 2021 21:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221334;
        bh=7BWeY7jZf2ARlswwmir2ibzjP/ISOvia+wJxQRJBS1g=;
        h=Date:From:To:Subject:From;
        b=zewirI6BwHFRwWWM9o4142T7Uk4JtQYxINZxsj30qdqfftQl8vUvHm5oQY21SOSbh
         Gxdfk1CuX2ygeuFor0PjJM1R2zYHR5Zk9uYtYpP/1LiZEtiIUVYfMHvkKxO20oIpRg
         LB7YV1cXSITE7/3dYpmLCX5Ix7JU7pWMkdDDkdq0=
Date:   Thu, 09 Sep 2021 14:02:14 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, david@redhat.com, mm-commits@vger.kernel.org,
        o451686892@gmail.com
Subject:  [merged]
 mm-early_ioremapc-remove-redundant-early_ioremap_shutdown.patch removed
 from -mm tree
Message-ID: <20210909210214.vup5DLLPC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap.c: remove redundant early_ioremap_shutdown()
has been removed from the -mm tree.  Its filename was
     mm-early_ioremapc-remove-redundant-early_ioremap_shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


