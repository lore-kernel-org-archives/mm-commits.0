Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6B8C3525A
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 02:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbiAZCph (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 21:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbiAZCpg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 21:45:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D34C06161C
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 18:45:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23460B81BA9
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 02:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAB6C340E0;
        Wed, 26 Jan 2022 02:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643165133;
        bh=9/Vs7fMz6JOJgm3aKBt4nxPpeB/W5gtCSMEx8BkI2Lo=;
        h=Date:From:To:Subject:From;
        b=DGm/SCXPxmLvCbn5UXMNZ9Wmcfxwh3qap70GMdV/Vpu4EiaJk+zTYiDjGyT8iB7kC
         jVdjMp7H8i7IOG9Dlah9dzEYx/BifDML93y27XD9xiwQdcFyy8RJmyGA0WNCjB0XIk
         4mnpmXGovzqetebBYb4X9qY0C8C5OErN8U+isTTM=
Date:   Tue, 25 Jan 2022 18:45:33 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, hch@lst.de, maorg@nvidia.com,
        mm-commits@vger.kernel.org, tglx@linutronix.de
Subject:  + tools-testing-scatterlist-add-missing-defines.patch
 added to -mm tree
Message-ID: <20220126024533.x-hUDODPJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/scatterlist: Add missing defines
has been added to the -mm tree.  Its filename is
     tools-testing-scatterlist-add-missing-defines.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-testing-scatterlist-add-missing-defines.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-testing-scatterlist-add-missing-defines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maor Gottlieb <maorg@nvidia.com>
Subject: tools/testing/scatterlist: Add missing defines

The cited commits replaced preemptible with pagefault_disabled and
flush_kernel_dcache_page with flush_dcache_page respectively, hence need
to update the corresponding defines in the test.

Link: https://lkml.kernel.org/r/20220118082105.1737320-1-maorg@nvidia.com
Fixes: 723aca208516 ("mm/scatterlist: replace the !preemptible warning in sg_miter_stop()")
Fixes: 0e84f5dbf8d6 ("scatterlist: replace flush_kernel_dcache_page with flush_dcache_page")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/scatterlist/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/scatterlist/linux/mm.h~tools-testing-scatterlist-add-missing-defines
+++ a/tools/testing/scatterlist/linux/mm.h
@@ -74,7 +74,7 @@ static inline unsigned long page_to_phys
 	      __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),   \
 	      x, y)
 
-#define preemptible() (1)
+#define pagefault_disabled() (0)
 
 static inline void *kmap(struct page *page)
 {
@@ -127,6 +127,7 @@ kmalloc_array(unsigned int n, unsigned i
 #define kmemleak_free(a)
 
 #define PageSlab(p) (0)
+#define flush_dcache_page(p)
 
 #define MAX_ERRNO	4095
 
_

Patches currently in -mm which might be from maorg@nvidia.com are

tools-testing-scatterlist-add-missing-defines.patch

