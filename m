Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C4CEB64DC
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 16:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjGFQgz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjGFQgy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 12:36:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C73173F
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 09:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 892D96068F
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 16:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF7AC433C8;
        Thu,  6 Jul 2023 16:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688661412;
        bh=ZYikSKzQ2uxDzm4vBzPCOC8zizI+QpnXdaTVNTn1/dA=;
        h=Date:To:From:Subject:From;
        b=0E4OHIQUy9UuFWVd38jzZ14q5TKR22/4bOTe9gQC6fGlreWeuXrMj2PUJ5gXB3Z77
         egEi5za3/f/XiA3wEkJ7kPO6EWw+0xOLgAzXkm1P8uKf65hsPM7tDrBBUbuXcA7YzT
         dFRSNcPfHgA2ohWwEx/9jfTeMJOXZaYcb45Lvip8=
Date:   Thu, 06 Jul 2023 09:36:52 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch added to mm-unstable branch
Message-Id: <20230706163652.CCF7AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove obsolete comment above struct per_cpu_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove obsolete comment above struct per_cpu_pages
Date: Thu, 6 Jul 2023 17:24:41 +0800

Since commit 01b44456a7aa ("mm/page_alloc: replace local_lock with normal
spinlock"), per_cpu_pages is protected by normal spinlock.  Remove the
obsolete comment as it's not that helpful.

Link: https://lkml.kernel.org/r/20230706092441.1574950-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mmzone.h~mm-remove-obsolete-comment-above-struct-per_cpu_pages
+++ a/include/linux/mmzone.h
@@ -676,7 +676,6 @@ enum zone_watermarks {
 #define high_wmark_pages(z) (z->_watermark[WMARK_HIGH] + z->watermark_boost)
 #define wmark_pages(z, i) (z->_watermark[i] + z->watermark_boost)
 
-/* Fields and list protected by pagesets local_lock in page_alloc.c */
 struct per_cpu_pages {
 	spinlock_t lock;	/* Protects lists field */
 	int count;		/* number of pages in the list */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
memory-tier-rename-destroy_memory_type-to-put_memory_type.patch
mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch

