Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD82FC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345895AbiC1UbS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345886AbiC1UbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:31:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0F93CA62
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5DA5B81210
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B24DC340ED;
        Mon, 28 Mar 2022 20:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648499368;
        bh=gwYfDmh51FrptYrFQxpe3aEeq9ju8ZKRbCudXoI39M4=;
        h=Date:To:From:Subject:From;
        b=HhPiyYPxKEFxP0+XA8fixKu14OHMH3pi1btDeT21lc7R8p5NhVUWeYdXQL2CMFYT7
         mmZOfc2Dv9ZTeMJrnkkmW0r1bMLQSs274uc83be/LmVVYPbjrL6AnwA35c5l+Z/Odk
         0k4wRqREjUgjOhSNGrWZeWxFEZsSV0LIork04qxU=
Date:   Mon, 28 Mar 2022 13:29:27 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-mmap_assert_write_locked-instead-of-open-coding-it.patch added to -mm tree
Message-Id: <20220328202928.9B24DC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: use mmap_assert_write_locked() instead of open coding it
has been added to the -mm tree.  Its filename is
     mm-use-mmap_assert_write_locked-instead-of-open-coding-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-mmap_assert_write_locked-instead-of-open-coding-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-mmap_assert_write_locked-instead-of-open-coding-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rolf Eike Beer <eb@emlix.com>
Subject: mm/mmap.c: use mmap_assert_write_locked() instead of open coding it

In case the lock is actually not held at this point this also avoids a
stale lock reference if built with NDEBUG.

Link: https://lkml.kernel.org/r/5827758.TJ1SttVevJ@mobilepool36.emlix.com
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-use-mmap_assert_write_locked-instead-of-open-coding-it
+++ a/mm/mmap.c
@@ -3561,7 +3561,7 @@ int mm_take_all_locks(struct mm_struct *
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
 
-	BUG_ON(mmap_read_trylock(mm));
+	mmap_assert_write_locked(mm);
 
 	mutex_lock(&mm_all_locks_mutex);
 
@@ -3641,7 +3641,7 @@ void mm_drop_all_locks(struct mm_struct
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
 
-	BUG_ON(mmap_read_trylock(mm));
+	mmap_assert_write_locked(mm);
 	BUG_ON(!mutex_is_locked(&mm_all_locks_mutex));
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
_

Patches currently in -mm which might be from eb@emlix.com are

mm-use-mmap_assert_write_locked-instead-of-open-coding-it.patch

