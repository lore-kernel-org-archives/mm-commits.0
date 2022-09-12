Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D168ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiILDay (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiILD3R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989F7286D2
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 330C86116E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8553CC433B5;
        Mon, 12 Sep 2022 03:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953341;
        bh=8KxYtgqYyud6thwH0SlmDnFzvEKz6CVp1mgZNZoZWj4=;
        h=Date:To:From:Subject:From;
        b=mih1pEkEQNBR8xxBurtOTyHUf/5oHD8Mw2KMlbD2tRl18YTUVGmpnQAcjurPmTmhv
         frDOk9rM3Ee8IKh7YUJQT/avfbaY+a+NoegtqNMta7nhb7WBCAw4BOc4mgNZXRumzX
         PDgbYGVTtCaaeligJ9sfck+Ap9j+9b/uID6dIsw8=
Date:   Sun, 11 Sep 2022 20:29:00 -0700
To:     mm-commits@vger.kernel.org, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-more-build_bug_ons-to-gfp_migratetype.patch removed from -mm tree
Message-Id: <20220912032901.8553CC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add more BUILD_BUG_ONs to gfp_migratetype()
has been removed from the -mm tree.  Its filename was
     mm-add-more-build_bug_ons-to-gfp_migratetype.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


