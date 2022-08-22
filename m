Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E41C28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 20:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237746AbiHVU7P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237335AbiHVU7K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 16:59:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116064D141
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 13:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A09C4612E7
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 20:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0083AC433C1;
        Mon, 22 Aug 2022 20:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661201948;
        bh=tH6JJ90iKhkM7tc+6SSh9o7pkfT2l7FHuDRgIbbQGwg=;
        h=Date:To:From:Subject:From;
        b=wXfO39Hs3V3FGb/Q2UsqvuhZ/PI/lt2Gyej96Ubj5MNYgTu+qJtihkDMk7TdphKCE
         e2DH9f5mRswDp+W+KV4ZaeCKbLa3miEoPzQy9tZP/fdChBu6tR66mZCzO5Fj8n6ToE
         38l5g/q8toetWh0H1KuJGDv3UP9xjSTbgEK8Us4Y=
Date:   Mon, 22 Aug 2022 13:59:07 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-fix-documentation-of-pte-hole-handling.patch added to mm-unstable branch
Message-Id: <20220822205908.0083AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: fix documentation of PTE hole handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-fix-documentation-of-pte-hole-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-fix-documentation-of-pte-hole-handling.patch

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

mm-pagewalk-make-error-checks-more-obvious.patch
mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch
mm-pagewalk-fix-documentation-of-pte-hole-handling.patch
mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch
mm-pagewalk-allow-walk_page_range_novma-without-mm.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops.patch

