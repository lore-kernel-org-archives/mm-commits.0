Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D6AC25B06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 00:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiHOASc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 20:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiHOAS3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 20:18:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9DC11C16
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 17:18:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4791C60F46
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 00:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AD3C433D7;
        Mon, 15 Aug 2022 00:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660522707;
        bh=WLwn6kCn7nLjd2zHVjNlRde6b3YWntw3dkwhFFRY/NQ=;
        h=Date:To:From:Subject:From;
        b=VWaeNg9XxZN2VOSFxHoWf/qCS4vbPB8gLWlLIXnNE69KilUxiMkC5p5Kb9kbKjwpA
         BXXwGd67bwI7jKe0a9VCtXlHzrf6tlJKSB8CBFyn8O02R3dF59qQ968rOzoOPN+LZ5
         ARTa5YWLDc2o7fuSzKT5wMgkit5SNmZ3p7wOExrg=
Date:   Sun, 14 Aug 2022 17:18:26 -0700
To:     mm-commits@vger.kernel.org, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-more-build_bug_ons-to-gfp_migratetype.patch added to mm-unstable branch
Message-Id: <20220815001827.97AD3C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add more BUILD_BUG_ONs to gfp_migratetype()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-more-build_bug_ons-to-gfp_migratetype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-more-build_bug_ons-to-gfp_migratetype.patch

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
From: Peter Collingbourne <pcc@google.com>
Subject: mm: add more BUILD_BUG_ONs to gfp_migratetype()
Date: Tue, 26 Jul 2022 16:02:41 -0700

gfp_migratetype() also expects GFP_RECLAIMABLE and
GFP_MOVABLE|GFP_RECLAIMABLE to be shiftable into MIGRATE_* enum values, so
add some more BUILD_BUG_ONs to reflect this assumption.

Link: https://linux-review.googlesource.com/id/Iae64e2182f75c3aca776a486b71a72571d66d83e
Link: https://lkml.kernel.org/r/20220726230241.3770532-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/gfp.h~mm-add-more-build_bug_ons-to-gfp_migratetype
+++ a/include/linux/gfp.h
@@ -18,6 +18,9 @@ static inline int gfp_migratetype(const
 	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
 	BUILD_BUG_ON((___GFP_MOVABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_MOVABLE);
+	BUILD_BUG_ON((___GFP_RECLAIMABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_RECLAIMABLE);
+	BUILD_BUG_ON(((___GFP_MOVABLE | ___GFP_RECLAIMABLE) >>
+		      GFP_MOVABLE_SHIFT) != MIGRATE_HIGHATOMIC);
 
 	if (unlikely(page_group_by_mobility_disabled))
 		return MIGRATE_UNMOVABLE;
_

Patches currently in -mm which might be from pcc@google.com are

mm-add-more-build_bug_ons-to-gfp_migratetype.patch

