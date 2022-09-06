Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D595DECAAA1
	for <mm-commits@archiver.kernel.org>; Tue,  6 Sep 2022 19:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiIFTi0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Sep 2022 15:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiIFTiZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2022 15:38:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9179A9DA
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 12:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E120A61662
        for <mm-commits@vger.kernel.org>; Tue,  6 Sep 2022 19:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4378AC433D6;
        Tue,  6 Sep 2022 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662493102;
        bh=8Gyxb3ZUnwzGVvifObQLHTpHNgqJwOyUA1DqI1rJt7E=;
        h=Date:To:From:Subject:From;
        b=w3HkvnE3mWFYNHlh4qTheA6ZW2mOvDts3aIiMFKIZLTvDXrSA5+FlM62Oa2gKzgUK
         z8ZW0E2q1psLdBJxfZrJt+S5/lyrfWs43/2DY3wI9hxqNOCT24MkWDrA3pyYB9OvxC
         5euOG9oHRTdd6ZagQ/cpZpypTtqeql4K8uEK8k/Q=
Date:   Tue, 06 Sep 2022 12:38:21 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-pagewalk-allow-walk_page_range_novma-without-mm.patch removed from -mm tree
Message-Id: <20220906193822.4378AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pagewalk: allow walk_page_range_novma() without mm
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-allow-walk_page_range_novma-without-mm.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rolf Eike Beer <eb@emlix.com>
Subject: mm: pagewalk: allow walk_page_range_novma() without mm
Date: Mon, 22 Aug 2022 15:03:29 +0200

Since e47690d756a7 ("x86: mm: avoid allocating struct mm_struct on the
stack") a pgd can be passed to walk_page_range_novma().  In case it is set
no place in the pagewalk code use the walk.mm anymore, so permit to pass a
NULL mm instead.  It is up to the caller to ensure proper locking on the
pgd in this case.

Link: https://lkml.kernel.org/r/5760214.MhkbZ0Pkbq@devpool047
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/pagewalk.c~mm-pagewalk-allow-walk_page_range_novma-without-mm
+++ a/mm/pagewalk.c
@@ -506,6 +506,8 @@ int walk_page_range(struct mm_struct *mm
  * not backed by VMAs. Because 'unusual' entries may be walked this function
  * will also not lock the PTEs for the pte_entry() callback. This is useful for
  * walking the kernel pages tables or page tables for firmware.
+ *
+ * Either mm or pgd may be NULL, but not both.
  */
 int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
@@ -520,10 +522,11 @@ int walk_page_range_novma(struct mm_stru
 		.no_vma		= true
 	};
 
-	if (start >= end || !walk.mm)
+	if (start >= end || (!walk.mm && !walk.pgd))
 		return -EINVAL;
 
-	mmap_assert_locked(walk.mm);
+	if (walk.mm)
+		mmap_assert_locked(walk.mm);
 
 	return walk_pgd_range(start, end, &walk);
 }
_

Patches currently in -mm which might be from eb@emlix.com are

mm-pagewalk-fix-documentation-of-pte-hole-handling.patch
mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops.patch

