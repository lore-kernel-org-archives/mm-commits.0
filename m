Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAB6EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjHUUj0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjHUUjL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A007D197
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 305B264A31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854A2C433C7;
        Mon, 21 Aug 2023 20:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650343;
        bh=yChsvtElSgcu56vs7axDtvvPamPn40j+nVXcZaItzkg=;
        h=Date:To:From:Subject:From;
        b=F8ex6OwL8FtYLBmABWQRYbCLKpL+s68ZdIWQZajAey7YRgJ5ZLXMV6IusR4+IWWkE
         J41nvGyXkyvL0uzjQQoE982i2yhZrGyixMGrMCZpPFKxPueYv++gQiZt25j8DI+Vn1
         YQWH8ipfSAvofH++lwBa+AdJEhRMsrkWceaTKIYA=
Date:   Mon, 21 Aug 2023 13:39:03 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, bhe@redhat.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iomem-remove-__weak-ioremap_cache-helper.patch removed from -mm tree
Message-Id: <20230821203903.854A2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/iomem.c: remove __weak ioremap_cache helper
has been removed from the -mm tree.  Its filename was
     iomem-remove-__weak-ioremap_cache-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kernel/iomem.c: remove __weak ioremap_cache helper
Date: Wed, 26 Jul 2023 16:54:09 +0200

No portable code calls into this function any more, and on architectures
that don't use or define their own, it causes a warning:

kernel/iomem.c:10:22: warning: no previous prototype for 'ioremap_cache' [-Wmissing-prototypes]
   10 | __weak void __iomem *ioremap_cache(resource_size_t offset, unsigned long size)

Fold it into the only caller that uses it on architectures
without the #define.

Note that the fallback to ioremap is probably still wrong on
those architectures, but this is what it's always done there.

Link: https://lkml.kernel.org/r/20230726145432.1617809-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/iomem.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/kernel/iomem.c~iomem-remove-__weak-ioremap_cache-helper
+++ a/kernel/iomem.c
@@ -5,18 +5,14 @@
 #include <linux/mm.h>
 #include <linux/ioremap.h>
 
-#ifndef ioremap_cache
-/* temporary while we convert existing ioremap_cache users to memremap */
-__weak void __iomem *ioremap_cache(resource_size_t offset, unsigned long size)
-{
-	return ioremap(offset, size);
-}
-#endif
-
 #ifndef arch_memremap_wb
 static void *arch_memremap_wb(resource_size_t offset, unsigned long size)
 {
+#ifdef ioremap_cache
 	return (__force void *)ioremap_cache(offset, size);
+#else
+	return (__force void *)ioremap(offset, size);
+#endif
 }
 #endif
 
_

Patches currently in -mm which might be from arnd@arndb.de are


