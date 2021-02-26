Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A4DC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5537064F1F
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhBZAKh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:10:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhBZAKg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:10:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A778164F1F;
        Fri, 26 Feb 2021 00:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614298195;
        bh=N2cs63+OIzi0zO+zdF2pxn+vqLI566n8oEIkr7Bj4b8=;
        h=Date:From:To:Subject:From;
        b=nrQo1Drd+dwWRCb2mkbeUGsBkT2inroEAZAfASxAFB6qiqYnz3+LDuJji59eOkH4n
         V0+zzWGmKWBNtzBhaJ9bMq5KnP2hDvFhoR8Vd+ETqMU2oNaGcla4FwkKKM+X2RKAXm
         SfQzjfrpVrIm1iAXEka8a5W1OZYtvpaRtS3MLBOQ=
Date:   Thu, 25 Feb 2021 16:09:55 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  +
 =?US-ASCII?Q?mm-page=5Fallocc-refactor-initialization-of-struct-page-for-?=
 =?US-ASCII?Q?holes-in-memory-layout-fix.patch?= added to -mm tree
Message-ID: <20210226000955.yPdgJ2DuE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix
has been added to the -mm tree.  Its filename is
     mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch

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
Subject: mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix

don't initialize static to zero, use %llu for u64

Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix
+++ a/mm/page_alloc.c
@@ -6315,7 +6315,7 @@ void __meminit __weak memmap_init_zone(s
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
 	int i, nid = zone_to_nid(zone), zone_id = zone_idx(zone);
-	static unsigned long hole_pfn = 0;
+	static unsigned long hole_pfn;
 	unsigned long start_pfn, end_pfn;
 	u64 pgcnt = 0;
 
@@ -6348,7 +6348,7 @@ void __meminit __weak memmap_init_zone(s
 #endif
 
 	if (pgcnt)
-		pr_info("  %s zone: %lld pages in unavailable ranges\n",
+		pr_info("  %s zone: %llu pages in unavailable ranges\n",
 			zone->name, pgcnt);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-memory_hotplug-prevalidate-the-address-range-being-added-with-platform-fix.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

