Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0269CC001DC
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jul 2023 20:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjGZUH1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jul 2023 16:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjGZUH0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2023 16:07:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623291BF6
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 13:07:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3EDE61C0A
        for <mm-commits@vger.kernel.org>; Wed, 26 Jul 2023 20:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526AAC433C7;
        Wed, 26 Jul 2023 20:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690402044;
        bh=9Xh1f0PSwtgOiJ7Vot51KkrGiPz/M2VrAQfbS7aluZc=;
        h=Date:To:From:Subject:From;
        b=u55BPYdsF8ZCC7QKkVjMQ9ZFQzDeZrszuWVoX8STIgykxgH/KSgD8pvC1Cp4ypRnm
         OQZUdy5YIJRXDcCxrT1FCzjjsPK0I0TWjed6OEZ2R630OqmKQr9uzL/EdtKF7+y8Xf
         TxlQg4XfUErQKdEALqBW77JZK8N/uOYO/hPAF5QU=
Date:   Wed, 26 Jul 2023 13:07:23 -0700
To:     mm-commits@vger.kernel.org, bhe@redhat.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + iomem-remove-__weak-ioremap_cache-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20230726200724.526AAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/iomem.c: remove __weak ioremap_cache helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     iomem-remove-__weak-ioremap_cache-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iomem-remove-__weak-ioremap_cache-helper.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Baoquan He <bhe@redhat.com>
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

iomem-remove-__weak-ioremap_cache-helper.patch

