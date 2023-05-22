Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15751C7EE2A
	for <mm-commits@archiver.kernel.org>; Mon, 22 May 2023 20:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjEVUsM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 May 2023 16:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjEVUsK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2023 16:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCAEB7
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 13:48:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A3516228C
        for <mm-commits@vger.kernel.org>; Mon, 22 May 2023 20:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA02BC433EF;
        Mon, 22 May 2023 20:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684788487;
        bh=r1zg13NMivwHfAFM2xmwr3iR67vtssJKmYHc1iyB/jw=;
        h=Date:To:From:Subject:From;
        b=XkItvFJxG1ADyctI8WZdhW5HzyyFPF1u+HbXhUO6HftsQHvLvDI0WYLD3NMNntyD4
         GNCubb1qgbjLR4nemDlpnUFR9JQeHNwjG8AKaXh0HNnxxJRy07vEouv3dCW77OSOvW
         wk1YgNfsRhW41KDRkTjukau3J2hG/2QUtZNuin30=
Date:   Mon, 22 May 2023 13:48:06 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, yuanchu@google.com,
        david@redhat.com, talumbau@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-use-macro-for-bitmap.patch added to mm-unstable branch
Message-Id: <20230522204806.EA02BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: use macro for bitmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-use-macro-for-bitmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-use-macro-for-bitmap.patch

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
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: use macro for bitmap
Date: Mon, 22 May 2023 11:20:55 +0000

Use DECLARE_BITMAP macro when possible.

Link: https://lkml.kernel.org/r/20230522112058.2965866-1-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-use-macro-for-bitmap
+++ a/mm/vmscan.c
@@ -4144,7 +4144,7 @@ static void walk_pmd_range(pud_t *pud, u
 	unsigned long next;
 	unsigned long addr;
 	struct vm_area_struct *vma;
-	unsigned long bitmap[BITS_TO_LONGS(MIN_LRU_BATCH)];
+	DECLARE_BITMAP(bitmap, MIN_LRU_BATCH);
 	unsigned long first = -1;
 	struct lru_gen_mm_walk *walk = args->private;
 
_

Patches currently in -mm which might be from talumbau@google.com are

mm-multi-gen-lru-use-macro-for-bitmap.patch
mm-multi-gen-lru-cleanup-lru_gen_soft_reclaim.patch
mm-multi-gen-lru-add-helpers-in-page-table-walks.patch
mm-multi-gen-lru-cleanup-lru_gen_test_recent.patch

