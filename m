Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2811BC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 22:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02585613B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 22:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGIWiQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 18:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhGIWiP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 18:38:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3B15613B4;
        Fri,  9 Jul 2021 22:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625870130;
        bh=jv4gkvuUCYW9c9xMxZMvCDYP1STZjDBHDJOWmSSdzEU=;
        h=Date:From:To:Subject:From;
        b=lWBP5RLZW/CjeXOcnieFDaVmLAoqqohkYLOAWaXerrhlEkbSjKUaz6lrCE9oL3FmX
         4YwZisKqdHWDEcxM0Z+O2etp+XBVfYuqkhOnns2YlfIoc6gwjfbpxVO7kXbnyVjcNE
         3oJni6Ka2ZX8VBJkprZSUu5c1o2uk+38VJvc4Xjs=
Date:   Fri, 09 Jul 2021 15:35:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shy828301@gmail.com,
        mhocko@kernel.org, mgorman@techsingularity.net, ddstreet@ieee.org,
        david@redhat.com, mcroce@microsoft.com
Subject:  +
 revert-mm-page_alloc-make-should_fail_alloc_page-static.patch added to -mm
 tree
Message-ID: <20210709223530.Cp45I%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm/page_alloc: make should_fail_alloc_page() static"
has been added to the -mm tree.  Its filename is
     revert-mm-page_alloc-make-should_fail_alloc_page-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-page_alloc-make-should_fail_alloc_page-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-page_alloc-make-should_fail_alloc_page-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matteo Croce <mcroce@microsoft.com>
Subject: Revert "mm/page_alloc: make should_fail_alloc_page() static"

This reverts commit f7173090033c70886d925995e9dfdfb76dbb2441.

Fix an unresolved symbol error when CONFIG_DEBUG_INFO_BTF=y:

  LD      vmlinux
  BTFIDS  vmlinux
FAILED unresolved symbol should_fail_alloc_page
make: *** [Makefile:1199: vmlinux] Error 255
make: *** Deleting file 'vmlinux'

Link: https://lkml.kernel.org/r/20210708191128.153796-1-mcroce@linux.microsoft.com
Fixes: f7173090033c ("mm/page_alloc: make should_fail_alloc_page() static")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~revert-mm-page_alloc-make-should_fail_alloc_page-static
+++ a/mm/page_alloc.c
@@ -3820,7 +3820,7 @@ static inline bool __should_fail_alloc_p
 
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
-static noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	return __should_fail_alloc_page(gfp_mask, order);
 }
_

Patches currently in -mm which might be from mcroce@microsoft.com are

revert-mm-page_alloc-make-should_fail_alloc_page-static.patch

