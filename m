Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2848BC32774
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 20:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbiHVU7W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237357AbiHVU7S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 16:59:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721714D27E
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 13:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2710AB818BE
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 20:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECCCC433D6;
        Mon, 22 Aug 2022 20:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661201951;
        bh=uAE2/tUD9glwcoY5E8N8Ms9UBnxGncEy8EMzHoS4Pf8=;
        h=Date:To:From:Subject:From;
        b=A5zwXURr5xMEqw6ZK6e9AKAH3bQHhJVQCqe7tfjpt6jpVciRg1Pg246s5Y/6ApFVQ
         mx/d83Amktjvuwy6/LzLbFFmiHgCmAgifTkbkkqkMch8dZPKbqBcZv1LizkI3p+c6k
         duuaTtb0nmWzn5v7wBTzXt4eiMYJhUtYCi8P/B7A=
Date:   Mon, 22 Aug 2022 13:59:11 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-allow-walk_page_range_novma-without-mm.patch added to mm-unstable branch
Message-Id: <20220822205911.CECCCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: allow walk_page_range_novma() without mm
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagewalk-allow-walk_page_range_novma-without-mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-allow-walk_page_range_novma-without-mm.patch

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

mm-pagewalk-make-error-checks-more-obvious.patch
mm-pagewalk-dont-check-vma-in-walk_page_range_novma.patch
mm-pagewalk-fix-documentation-of-pte-hole-handling.patch
mm-pagewalk-add-api-documentation-for-walk_page_range_novma.patch
mm-pagewalk-allow-walk_page_range_novma-without-mm.patch
mm-pagewalk-move-variables-to-more-local-scope-tweak-loops.patch

