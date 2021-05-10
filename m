Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F70FC433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 00:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6187C613CF
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 00:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhEJAqk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 20:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhEJAqj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 20:46:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8326613CD;
        Mon, 10 May 2021 00:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620607535;
        bh=wbdJeiMOnhEchxNI2RPeFK8+7yj25Pb0rJXuhAt6HOw=;
        h=Date:From:To:Subject:From;
        b=PL1hZws10aRC9cphSelt2pi0vGwW5awZi6WYIzR7LeLvwI5M7KKZSBMDqAwhKmXZG
         dZbE0xrThoBFGB9y8/8qbqKvM7TbvOmf6zje8uFwe4HL7e4RBLLH7xyGyEDmm8l7cf
         UvAJT+pymL+YKRagSMlsIwFWeB/3f+Ysui+vvmn4=
Date:   Sun, 09 May 2021 17:45:35 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, willy@infradead.org
Subject:  + mm-mmzoneh-simplify-is_highmem_idx.patch added to -mm
 tree
Message-ID: <20210510004535.VBCk98GST%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmzone.h: simplify is_highmem_idx()
has been added to the -mm tree.  Its filename is
     mm-mmzoneh-simplify-is_highmem_idx.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmzoneh-simplify-is_highmem_idx.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmzoneh-simplify-is_highmem_idx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/mmzone.h: simplify is_highmem_idx()

There is a lot of historical ifdefery in is_highmem_idx() and its helper
zone_movable_is_highmem() that was required because of two different paths
for nodes and zones initialization that were selected at compile time.

Until commit 3f08a302f533 ("mm: remove CONFIG_HAVE_MEMBLOCK_NODE_MAP
option") the movable_zone variable was only available for configurations
that had CONFIG_HAVE_MEMBLOCK_NODE_MAP enabled so the test in
zone_movable_is_highmem() used that variable only for such configurations.
For other configurations the test checked if the index of ZONE_MOVABLE
was greater by 1 than the index of ZONE_HIGMEM and then movable zone was
considered a highmem zone.  Needless to say, ZONE_MOVABLE - 1 equals
ZONE_HIGHMEM by definition when CONFIG_HIGHMEM=y.

Commit 3f08a302f533 ("mm: remove CONFIG_HAVE_MEMBLOCK_NODE_MAP option")
made movable_zone variable always available.  Since this variable is set
to ZONE_HIGHMEM if CONFIG_HIGHMEM is enabled and highmem zone is
populated, it is enough to check whether

	zone_idx == ZONE_MOVABLE && movable_zone == ZONE_HIGMEM

to test if zone index points to a highmem zone.

Remove zone_movable_is_highmem() that is not used anywhere except
is_highmem_idx() and use the test above in is_highmem_idx() instead.

Link: https://lkml.kernel.org/r/20210426141927.1314326-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/include/linux/mmzone.h~mm-mmzoneh-simplify-is_highmem_idx
+++ a/include/linux/mmzone.h
@@ -982,22 +982,11 @@ static inline void zone_set_nid(struct z
 
 extern int movable_zone;
 
-#ifdef CONFIG_HIGHMEM
-static inline int zone_movable_is_highmem(void)
-{
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-	return movable_zone == ZONE_HIGHMEM;
-#else
-	return (ZONE_MOVABLE - 1) == ZONE_HIGHMEM;
-#endif
-}
-#endif
-
 static inline int is_highmem_idx(enum zone_type idx)
 {
 #ifdef CONFIG_HIGHMEM
 	return (idx == ZONE_HIGHMEM ||
-		(idx == ZONE_MOVABLE && zone_movable_is_highmem()));
+		(idx == ZONE_MOVABLE && movable_zone == ZONE_HIGHMEM));
 #else
 	return 0;
 #endif
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

