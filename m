Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3D4ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiILDdV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiILDbX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:31:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAED13F3B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8CFBCE0E95
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7A5C433B5;
        Mon, 12 Sep 2022 03:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953382;
        bh=ZLM6ZDBWfuY3axhiUJ7WdPw4RvoAJg9Jz1WZ4bHUb6w=;
        h=Date:To:From:Subject:From;
        b=WlYBHUKHoktqIbd47qWYwCbnS/EsdTimu5egqKckv9pzI1utQHE8mey+1najEXIjB
         qW6T+pEXoeImUHcUlItLxPYgCR+Q8SFPTmttX2kH8q52YreKSi8GQJEuyope1cezZd
         hq2LuyB+IgBwrO9+SoBq6JIwRRsVHFGn0AqhXPu4=
Date:   Sun, 11 Sep 2022 20:29:41 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagewalk-fix-documentation-of-pte-hole-handling.patch removed from -mm tree
Message-Id: <20220912032942.0C7A5C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pagewalk: fix documentation of PTE hole handling
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-fix-documentation-of-pte-hole-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rolf Eike Beer <eb@emlix.com>
Subject: mm: pagewalk: fix documentation of PTE hole handling
Date: Mon, 22 Aug 2022 15:01:32 +0200

Empty PTEs are passed to the pte_entry callback, not to pte_hole.

Link: https://lkml.kernel.org/r/3695521.kQq0lBPeGt@devpool047
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/pagewalk.h~mm-pagewalk-fix-documentation-of-pte-hole-handling
+++ a/include/linux/pagewalk.h
@@ -15,12 +15,12 @@ struct mm_walk;
  *			this handler is required to be able to handle
  *			pmd_trans_huge() pmds.  They may simply choose to
  *			split_huge_page() instead of handling it explicitly.
- * @pte_entry:		if set, called for each non-empty PTE (lowest-level)
- *			entry
+ * @pte_entry:		if set, called for each PTE (lowest-level) entry,
+ *			including empty ones
  * @pte_hole:		if set, called for each hole at all levels,
- *			depth is -1 if not known, 0:PGD, 1:P4D, 2:PUD, 3:PMD
- *			4:PTE. Any folded depths (where PTRS_PER_P?D is equal
- *			to 1) are skipped.
+ *			depth is -1 if not known, 0:PGD, 1:P4D, 2:PUD, 3:PMD.
+ *			Any folded depths (where PTRS_PER_P?D is equal to 1)
+ *			are skipped.
  * @hugetlb_entry:	if set, called for each hugetlb entry
  * @test_walk:		caller specific callback function to determine whether
  *			we walk over the current vma or not. Returning 0 means
_

Patches currently in -mm which might be from eb@emlix.com are


