Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7654BC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0286100C
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhEHWqS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWqS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A514A613C5;
        Sat,  8 May 2021 22:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513915;
        bh=nBOCnUcIuDPwyzdSZgZ9iLZdZxMX2a3ncHojGAMbKFs=;
        h=Date:From:To:Subject:From;
        b=f+Ps0jGDs8Zvg6JE0DLODB9yBycz3NqTTgGDwl13fpfZ1taETMgab3tDZ1w0WiZKl
         bj7O8JVkRH+/7VfjXLBI13h5A6Cjrikv+67bUKR+MrkL95qk58P902kAJ8LP0mkFKo
         uXaPIAZja4M6bbMle5SOcgqnBRA4HBL5nCAkTbVQ=
Date:   Sat, 08 May 2021 15:45:15 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, geert@linux-m68k.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  [merged] mm-remove-default-discontigmem_manual.patch
 removed from -mm tree
Message-ID: <20210508224515.yQpuCxP8T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/Kconfig: remove default DISCONTIGMEM_MANUAL
has been removed from the -mm tree.  Its filename was
     mm-remove-default-discontigmem_manual.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm/Kconfig: remove default DISCONTIGMEM_MANUAL

Commit 214496cb18700fd7 ("ia64: make SPARSEMEM default and disable
DISCONTIGMEM") removed the last enabler of ARCH_DISCONTIGMEM_DEFAULT,
hence the memory model can no longer default to DISCONTIGMEM_MANUAL.

Link: https://lkml.kernel.org/r/20210312141208.3465520-1-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/Kconfig~mm-remove-default-discontigmem_manual
+++ a/mm/Kconfig
@@ -9,7 +9,6 @@ config SELECT_MEMORY_MODEL
 choice
 	prompt "Memory model"
 	depends on SELECT_MEMORY_MODEL
-	default DISCONTIGMEM_MANUAL if ARCH_DISCONTIGMEM_DEFAULT
 	default SPARSEMEM_MANUAL if ARCH_SPARSEMEM_DEFAULT
 	default FLATMEM_MANUAL
 	help
_

Patches currently in -mm which might be from geert@linux-m68k.org are


