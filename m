Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CE0C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbiC1ULX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbiC1ULW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:11:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FFE5133D
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:09:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2140EB81106
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5C2C340ED;
        Mon, 28 Mar 2022 20:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648498177;
        bh=uLsGXeNeXTk4ZGUDbWVKvFJ/9s4YAR/D/aMl9USQMIo=;
        h=Date:To:From:Subject:From;
        b=xGuwPSl8vLTR3Af78nVZPf96Y3iCISPOZwwBYjmFugDNxLyvL4TlQxQ5u6W9LIuor
         PxDHbHxbz4H2/HUNhVPwOV79K/sUFjsMJ+gEcV6EKwP++WzsbJK83bQ0lAclW8adhE
         rajV+75qMHTPSllDK9Is5EOuk/86XXjHkh9x1NmM=
Date:   Mon, 28 Mar 2022 13:09:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sfr@canb.auug.org.au, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch added to -mm tree
Message-Id: <20220328200937.AE5C2C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: remove fields to fix htmldocs warnings
has been added to the -mm tree.  Its filename is
     mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: remove fields to fix htmldocs warnings

Stephen reports that 'make htmldocs' currently issues two warnings:

include/linux/mm_types.h:275: warning: Function parameter or member
'__filler' not described in 'folio'
include/linux/mm_types.h:275: warning: Function parameter or member
'mlock_count' not described in 'folio'

Certainly __filler doesn't want documenting there, and all but one use of
mlock_count is through page->mlock_count at present: so I think it's best
just to remove them both from struct folio for now, and sort out the right
way to document folio->mlock_count once that is the one true way.

Link: https://lkml.kernel.org/r/d2c8f66d-be8e-7c91-b0c8-b2f7ffb08bec@google.com
Fixes: 07ca76067308 ("mm/munlock: maintain page->mlock_count while unevictable")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 +-------
 mm/swap.c                |    4 ++--
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/include/linux/mm_types.h~mm-munlock-remove-fields-to-fix-htmldocs-warnings
+++ a/include/linux/mm_types.h
@@ -253,13 +253,7 @@ struct folio {
 		struct {
 	/* public: */
 			unsigned long flags;
-			union {
-				struct list_head lru;
-				struct {
-					void *__filler;
-					unsigned int mlock_count;
-				};
-			};
+			struct list_head lru;
 			struct address_space *mapping;
 			pgoff_t index;
 			void *private;
--- a/mm/swap.c~mm-munlock-remove-fields-to-fix-htmldocs-warnings
+++ a/mm/swap.c
@@ -1026,13 +1026,13 @@ static void __pagevec_lru_add_fn(struct
 		folio_clear_active(folio);
 		folio_set_unevictable(folio);
 		/*
-		 * folio->mlock_count = !!folio_test_mlocked(folio)?
+		 * page->mlock_count = !!PageMlocked(page)?
 		 * But that leaves __mlock_page() in doubt whether another
 		 * actor has already counted the mlock or not.  Err on the
 		 * safe side, underestimate, let page reclaim fix it, rather
 		 * than leaving a page on the unevictable LRU indefinitely.
 		 */
-		folio->mlock_count = 0;
+		folio_page(folio, 0)->mlock_count = 0;
 		if (!was_unevictable)
 			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch

