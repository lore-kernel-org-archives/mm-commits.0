Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4088DC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BFEC610E5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350144AbhICU5g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350130AbhICU5V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D936601FD;
        Fri,  3 Sep 2021 20:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702580;
        bh=o9JNmuCBfD8v7eRZ4lcQLr3NwBX4oZAEFD99NfuBbT8=;
        h=Date:From:To:Subject:From;
        b=CzW/qBxa5gOb3vzOwy6xJjzGhD/gFTqc+JdAMhDoP08/P47SOtbs3wq7Xrdm+s8CI
         TO5yTjsQCWaAy0hOidJovEL3dS3e1O6mbINjTvJQvWfYrUWrVHZVOfBq09vPRXWwr0
         YrFJqZcv94t01viei4ueL+yV5vXtWHq5ASAvggMo=
Date:   Fri, 03 Sep 2021 13:56:20 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, imbrenda@linux.ibm.com, jack@suse.cz,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-gup-remove-unneed-local-variable-orig_refs.patch removed from -mm tree
Message-ID: <20210903205620.8v8rCG6ki%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: remove unneed local variable orig_refs
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-unneed-local-variable-orig_refs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: gup: remove unneed local variable orig_refs

Remove unneed local variable orig_refs since refs is unchanged now.

Link: https://lkml.kernel.org/r/20210807093620.21347-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-remove-unneed-local-variable-orig_refs
+++ a/mm/gup.c
@@ -117,8 +117,6 @@ __maybe_unused struct page *try_grab_com
 	if (flags & FOLL_GET)
 		return try_get_compound_head(page, refs);
 	else if (flags & FOLL_PIN) {
-		int orig_refs = refs;
-
 		/*
 		 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
 		 * right zone, so fail and let the caller fall back to the slow
@@ -150,7 +148,7 @@ __maybe_unused struct page *try_grab_com
 			page_ref_add(page, refs * (GUP_PIN_COUNTING_BIAS - 1));
 
 		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED,
-				    orig_refs);
+				    refs);
 
 		return page;
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

