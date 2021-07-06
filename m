Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56493C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B8D961CA1
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhGFTXg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTXg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88AF561C9C;
        Tue,  6 Jul 2021 19:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599256;
        bh=8AJ5Y+IKJFCm/jEllgBJkHW6950zSqeFJY3oxXVK938=;
        h=Date:From:To:Subject:From;
        b=LhCeWrbzz/xS8H5uGGqxZL6U6syGkz1wbY5yNXX1quLm1bvp2XBBon4Zcf5/zvODA
         Q7HH3NkmFFBzcRNQxju7OYeO2Gv/w6dX5nWteqvUBdtt2F/OO52UkQlTG66dbJZY9O
         0ozE9PL2W724uX46A30C1QjWUcI3yJAV4apz9dTY=
Date:   Tue, 06 Jul 2021 12:20:56 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch removed from
 -mm tree
Message-ID: <20210706192056.6XOxflyzY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mapping_dirty_helpers: remove double Note in kerneldoc
has been removed from the -mm tree.  Its filename was
     mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/mapping_dirty_helpers: remove double Note in kerneldoc

make W=1 generates the following warning for mm/mapping_dirty_helpers.c

mm/mapping_dirty_helpers.c:325: warning: duplicate section name 'Note'

The helper function is very specific to one driver -- vmwgfx.  While the
two notes are separate, all of it needs to be taken into account when
using the helper so make it one note.

Link: https://lkml.kernel.org/r/20210520084809.8576-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mapping_dirty_helpers.c~mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc
+++ a/mm/mapping_dirty_helpers.c
@@ -317,7 +317,7 @@ EXPORT_SYMBOL_GPL(wp_shared_mapping_rang
  * pfn_mkwrite(). And then after a TLB flush following the write-protection
  * pick up all dirty bits.
  *
- * Note: This function currently skips transhuge page-table entries, since
+ * This function currently skips transhuge page-table entries, since
  * it's intended for dirty-tracking on the PTE level. It will warn on
  * encountering transhuge dirty entries, though, and can easily be extended
  * to handle them as well.
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


