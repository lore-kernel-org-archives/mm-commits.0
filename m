Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DA3C4320A
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 19:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63FCE60FC0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 19:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhG0Tfb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 15:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhG0Tfa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 15:35:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81CA560C51;
        Tue, 27 Jul 2021 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627414529;
        bh=bFy0HPa5CE6+NidH3jvz33wAS44kQb68oPZtW7Z9Kbc=;
        h=Date:From:To:Subject:From;
        b=inO0AjDJm5en1vrX+jSw6nPHrvflDNbPwBzkhk1MHPEVZucVOrf8m/q9aMKoXTeTt
         dbTUXlybBgp8tHDcSJmEypbLRvlmzeKpMdcMSRzfOV6DJZDZYGkFgIDxi4ejaYTU7S
         hu22xgTghGruUw/4mPjdBNqZA5VZVXUplwy+nCVE=
Date:   Tue, 27 Jul 2021 12:35:29 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [merged] mm-secretmem-wire-up-set_page_dirty.patch
 removed from -mm tree
Message-ID: <20210727193529.KXe2zQDOZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: wire up ->set_page_dirty
has been removed from the -mm tree.  Its filename was
     mm-secretmem-wire-up-set_page_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
microblaze-simplify-pte_alloc_one_kernel.patch
mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch
memblock-stop-poisoning-raw-allocations.patch
mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref.patch
mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

