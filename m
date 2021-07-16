Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6B2C12002
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 23:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 684D4613E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 23:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhGPXif (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jul 2021 19:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhGPXif (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Jul 2021 19:38:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82961613E3;
        Fri, 16 Jul 2021 23:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626478539;
        bh=C3q/4zoGqdrHHnK7XsCRTiRwksg0Ff4kCCgbPnqr97Q=;
        h=Date:From:To:Subject:From;
        b=vCQtE7mLKP2pOU6RwyNs9SO9OzYEbm1xYqHxr894RE1mknoXZYuUjQ8IudVNHkYjw
         +7qeKv6Oej4IVXueTSesZe4bY3WURWwHH90IH1qPqfgX8BgHTWNKQ0LdDOvYmDMNEf
         xYncRoZVNfluQXy74d0l/gLk/zuktHnk4VWBE734=
Date:   Fri, 16 Jul 2021 16:35:39 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  + mm-secretmem-wire-up-set_page_dirty.patch added to -mm
 tree
Message-ID: <20210716233539.Mv_udqnBs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: wire up ->set_page_dirty
has been added to the -mm tree.  Its filename is
     mm-secretmem-wire-up-set_page_dirty.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-secretmem-wire-up-set_page_dirty.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-secretmem-wire-up-set_page_dirty.patch

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
Subject: mm/secretmem: wire up ->set_page_dirty

Make secretmem up to date with the changes done in commit 0af573780b0b
("mm: require ->set_page_dirty to be explicitly wired up") so that
unconditional call to this method won't cause crashes.

Link: https://lkml.kernel.org/r/20210716063933.31633-1-rppt@kernel.org
Fixes: 0af573780b0b ("mm: require ->set_page_dirty to be explicitly wired up")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/secretmem.c~mm-secretmem-wire-up-set_page_dirty
+++ a/mm/secretmem.c
@@ -152,6 +152,7 @@ static void secretmem_freepage(struct pa
 }
 
 const struct address_space_operations secretmem_aops = {
+	.set_page_dirty	= __set_page_dirty_no_writeback,
 	.freepage	= secretmem_freepage,
 	.migratepage	= secretmem_migratepage,
 	.isolate_page	= secretmem_isolate_page,
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

memblock-make-for_each_mem_range-traverse-memblock_hotplug-regions.patch
mm-secretmem-wire-up-set_page_dirty.patch
mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
microblaze-simplify-pte_alloc_one_kernel.patch
mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch
memblock-stop-poisoning-raw-allocations.patch
mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch
mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

