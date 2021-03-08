Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20156C433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 18:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9D6D6518A
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 18:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCHSeS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 13:34:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhCHSeJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 13:34:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7FD6518A;
        Mon,  8 Mar 2021 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615228448;
        bh=vVtz/yuJHtiqFcwb4lG4QhVBmBkng6qbfRpBY/quC+A=;
        h=Date:From:To:Subject:From;
        b=ovYlpirYuwgkvn+LH4+IVF+p+vt0/lL9VtbfpdJJaUZBv3RWsZkaxiZmP3iOw073O
         VpfWz6/wIxtWwkcEsaFUAT+awhzZsxt+D3GQne4+MXwF/DUF/jAAa/AeJQkIG8H37F
         YKR1DuP5XQp1jlWEGw4yzpVUrbF/ICR8SaY+M8oo=
Date:   Mon, 08 Mar 2021 10:34:08 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20210308183408.QQDThB4N5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/page_mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/m68k/include/asm/page_mm.h~linux-next-rejects
+++ a/arch/m68k/include/asm/page_mm.h
@@ -167,11 +167,11 @@ static inline __attribute_const__ int __
 	((__p) - pgdat->node_mem_map) + pgdat->node_start_pfn;		\
 })
 #else
-#define ARCH_PFN_OFFSET (m68k_memory[0].addr)
+#define ARCH_PFN_OFFSET (m68k_memory[0].addr >> PAGE_SHIFT)
 #include <asm-generic/memory_model.h>
 #endif
 
-#define virt_addr_valid(kaddr)	((void *)(kaddr) >= (void *)PAGE_OFFSET && (void *)(kaddr) < high_memory)
+#define virt_addr_valid(kaddr)	((unsigned long)(kaddr) >= PAGE_OFFSET && ((unsigned long)kaddr) < (unsigned long)high_memory)
 #define pfn_valid(pfn)		virt_addr_valid(pfn_to_virt(pfn))
 
 #endif /* __ASSEMBLY__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

