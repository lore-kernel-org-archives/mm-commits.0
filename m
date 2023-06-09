Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86873C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbjFIXcC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbjFIXbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C5A44B6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F32BB63E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53649C433D2;
        Fri,  9 Jun 2023 23:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353346;
        bh=3MFB7PR/utUUVIEN5dJygCK8qqV9qOc6+bOTPGZo4yY=;
        h=Date:To:From:Subject:From;
        b=Ov/bOwTsTyMJqPlQjVG0uepR35zlHwXx1kzPwJAOOiEKz5oP93aloZbQ7JnEJb86o
         O0iwtdg35kMmMrmWyurAgHCo3vhYycyZNyjOex97+BraIq/NRMvLdT6KqCQZE7RL/u
         RKXQS66G/koEDV1sJFligUP1QR6VxPz6fZlWDsxk=
Date:   Fri, 09 Jun 2023 16:29:05 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, yuanchu@google.com,
        david@redhat.com, talumbau@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-use-macro-for-bitmap.patch removed from -mm tree
Message-Id: <20230609232906.53649C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: use macro for bitmap
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-use-macro-for-bitmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: use macro for bitmap
Date: Mon, 22 May 2023 11:20:55 +0000

Use DECLARE_BITMAP macro when possible.

Link: https://lkml.kernel.org/r/20230522112058.2965866-1-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yuanchu Xie <yuanchu@google.com>
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


