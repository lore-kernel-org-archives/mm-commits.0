Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECEBC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbiEJERA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbiEJEQX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B6A13F414
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD678B81AFD
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7058CC385A6;
        Tue, 10 May 2022 04:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155909;
        bh=btpj92WOcbS5FUXEBJPa+Xp2bwwQSzQZPGHS9I71KaQ=;
        h=Date:To:From:Subject:From;
        b=MT+T/cWljXRhN7pzClzWmhVV4mKbSCsDElH3cVbkNGNpDYFn6VKwCkLouRf1n3qlf
         GMAS1DC4G7Gpmswc4rl6739+GciditN4Otnmbfw5tj7OU4O+KZrAbLTWhd3LK/GsR5
         B+khdvGZB/H1ZNmWMHaZky/RKzGT6S4sY/FMV2Cc=
Date:   Mon, 09 May 2022 21:11:48 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, eb@emlix.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-mmap_assert_write_locked-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220510041149.7058CC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap.c: use mmap_assert_write_locked() instead of open coding it
has been removed from the -mm tree.  Its filename was
     mm-use-mmap_assert_write_locked-instead-of-open-coding-it.patch

This patch was dropped because it was merged into mm-stable

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
@@ -3553,7 +3553,7 @@ int mm_take_all_locks(struct mm_struct *
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
 
-	BUG_ON(mmap_read_trylock(mm));
+	mmap_assert_write_locked(mm);
 
 	mutex_lock(&mm_all_locks_mutex);
 
@@ -3633,7 +3633,7 @@ void mm_drop_all_locks(struct mm_struct
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
 
-	BUG_ON(mmap_read_trylock(mm));
+	mmap_assert_write_locked(mm);
 	BUG_ON(!mutex_is_locked(&mm_all_locks_mutex));
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
_

Patches currently in -mm which might be from eb@emlix.com are


