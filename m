Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF8AC001B0
	for <mm-commits@archiver.kernel.org>; Wed,  9 Aug 2023 18:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjHISsT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Aug 2023 14:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjHISsS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2023 14:48:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BE61729
        for <mm-commits@vger.kernel.org>; Wed,  9 Aug 2023 11:48:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27A956332C
        for <mm-commits@vger.kernel.org>; Wed,  9 Aug 2023 18:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5F0C433C8;
        Wed,  9 Aug 2023 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691606897;
        bh=010EDaE78jnBzryTld78174mMA2L4/aRhXEqJ/ETt8A=;
        h=Date:To:From:Subject:From;
        b=v8qBgOelUG41Fx+NPsa0O5b3OumdqS2LUw0b8/Zu9BTI5DW5WZgliP1m3kUd9NjxJ
         B2y6IRvwF0h8iwYykZzj1ywHB40VhKqSaUlprjd8lUMVjmenmligGncreJJoaUEpTw
         7rIC+lpfBO31g7nHYIxWbmKXDjbsLbTI0WYwh+38=
Date:   Wed, 09 Aug 2023 11:48:16 -0700
To:     mm-commits@vger.kernel.org, dylan@andestech.com,
        alexghiti@rivosinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-a-call-to-flush_cache_vmap-in-vmap_pfn.patch added to mm-hotfixes-unstable branch
Message-Id: <20230809184817.7A5F0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add a call to flush_cache_vmap() in vmap_pfn()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-a-call-to-flush_cache_vmap-in-vmap_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-a-call-to-flush_cache_vmap-in-vmap_pfn.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: mm: add a call to flush_cache_vmap() in vmap_pfn()
Date: Wed, 9 Aug 2023 18:46:33 +0200

flush_cache_vmap() must be called after new vmalloc mappings are installed
in the page table in order to allow architectures to make sure the new
mapping is visible.

Link: https://lkml.kernel.org/r/20230809164633.1556126-1-alexghiti@rivosinc.com
Fixes: 3e9a9e256b1e ("mm: add a vmap_pfn function")
Reported-by: Dylan Jhong <dylan@andestech.com>
Closes: https://lore.kernel.org/linux-riscv/ZMytNY2J8iyjbPPy@atctrx.andestech.com/
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/vmalloc.c~mm-add-a-call-to-flush_cache_vmap-in-vmap_pfn
+++ a/mm/vmalloc.c
@@ -2979,6 +2979,10 @@ void *vmap_pfn(unsigned long *pfns, unsi
 		free_vm_area(area);
 		return NULL;
 	}
+
+	flush_cache_vmap((unsigned long)area->addr,
+			 (unsigned long)area->addr + count * PAGE_SIZE);
+
 	return area->addr;
 }
 EXPORT_SYMBOL_GPL(vmap_pfn);
_

Patches currently in -mm which might be from alexghiti@rivosinc.com are

mm-add-a-call-to-flush_cache_vmap-in-vmap_pfn.patch

