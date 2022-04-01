Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52F2C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 02:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiDACs2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 22:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiDACs1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 22:48:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4767F1A8C38
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 19:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 004E5B82344
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 02:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A94C340ED;
        Fri,  1 Apr 2022 02:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648781196;
        bh=Brkylo59OZjYzN3qRe9VSkAPmaNPGjJBWvYwVqRQKr0=;
        h=Date:To:From:Subject:From;
        b=RVllXFt8gaf9Nxz1K4XrKZ9TNdfolnt/yN7wU9gvGCfasxDp9gIjkd+Dsa25rKaGV
         zqDbM9hDNxM2ijvdVlv1rDFrHmqmr3ksycLwUT4phxrbM7SCXdL8xrbFiPyQEmq+S4
         Hj9o+oS6uJrgvVKySPtS9NlaOf0c3InPBzcabCHc=
Date:   Thu, 31 Mar 2022 19:46:35 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, eb@emlix.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-mmap_assert_write_locked-instead-of-open-coding-it.patch added to -mm tree
Message-Id: <20220401024636.94A94C340ED@smtp.kernel.org>
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

In case the lock is actually not held at this point.

Link: https://lkml.kernel.org/r/5827758.TJ1SttVevJ@mobilepool36.emlix.com
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

