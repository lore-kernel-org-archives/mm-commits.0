Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC35FC3DA6F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 17:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242193AbjHXRQz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 13:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242242AbjHXRQv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 13:16:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63A619B0
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 10:16:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7579563C3A
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 17:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB88C433C8;
        Thu, 24 Aug 2023 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692897408;
        bh=UDSlx5xz117CjPJUJOCjpK0AscmS1uuiGOOklRrnx1E=;
        h=Date:To:From:Subject:From;
        b=AqK2Ar8We4q6bMUfetremy8lazPm93IzQc+g8WDJCZg/5mf8Z+PLnpL3iGnvams5v
         NR77/tzxDVeyHapkmQ0tf93sa+CxXovlRoj7ttJfv5t8Ic7aG6jNcTvk2KKZgJZJlK
         50FhrbUDQ1/TuvjWo44vRwhj3UUL7BmhxY7JdyEs=
Date:   Thu, 24 Aug 2023 10:16:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        michal.simek@amd.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + microblaze-implement-the-new-page-table-range-api-fix.patch added to mm-unstable branch
Message-Id: <20230824171648.CAB88C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: mark flush_dcache_folio() inline
has been added to the -mm mm-unstable branch.  Its filename is
     microblaze-implement-the-new-page-table-range-api-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/microblaze-implement-the-new-page-table-range-api-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: microblaze: mark flush_dcache_folio() inline
Date: Thu, 10 Aug 2023 16:19:26 +0200

The newly added flush_dcache_folio() causes a harmless warning that turns
into a build failure with CONFIG_WERROR:

arch/microblaze/include/asm/cacheflush.h:77:13: error: 'flush_dcache_folio' defined but not used [-Werror=unused-function]

Mark it as inline to avoid this.

Link: https://lkml.kernel.org/r/20230810141947.1236730-9-arnd@kernel.org
Fixes: 1330c94f53996 ("microblaze: implement the new page table range API")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Simek <michal.simek@amd.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/cacheflush.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/microblaze/include/asm/cacheflush.h~microblaze-implement-the-new-page-table-range-api-fix
+++ a/arch/microblaze/include/asm/cacheflush.h
@@ -74,7 +74,7 @@ do { \
 	flush_dcache_range((unsigned) (addr), (unsigned) (addr) + PAGE_SIZE); \
 } while (0);
 
-static void flush_dcache_folio(struct folio *folio)
+static inline void flush_dcache_folio(struct folio *folio)
 {
 	unsigned long addr = folio_pfn(folio) << PAGE_SHIFT;
 
_

Patches currently in -mm which might be from arnd@arndb.de are

microblaze-implement-the-new-page-table-range-api-fix.patch

