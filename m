Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDB4C54E94
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 21:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbjAXVW0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 16:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbjAXVWZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 16:22:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D8F3A8C
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 13:22:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CED9B81711
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 21:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F025C433EF;
        Tue, 24 Jan 2023 21:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674595342;
        bh=TcolPVoAQADgNgA5iMovUCSDT8fT4FvIdK73++gbfYM=;
        h=Date:To:From:Subject:From;
        b=t8e0uSyjB6RIkLl+cqDrhFtBX45f9yLXfSV31/XRnwPw2f+QHJADAp880VuCO6DfB
         wMOR44mXcRGTu8e7iMH/9Eac0m59GemlCBCMTWls+G9xLS3UkZPDVBzFDAmUkFsedf
         eC2K8AmA+nsbNMx++JCNpEwbLcM1VY623/GbBTOk=
Date:   Tue, 24 Jan 2023 13:22:21 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ext4-use-try_cmpxchg-in-ext4_update_bh_state.patch added to mm-nonmm-unstable branch
Message-Id: <20230124212222.3F025C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ext4: use try_cmpxchg in ext4_update_bh_state
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-ext4-use-try_cmpxchg-in-ext4_update_bh_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-ext4-use-try_cmpxchg-in-ext4_update_bh_state.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: fs/ext4: use try_cmpxchg in ext4_update_bh_state
Date: Wed, 2 Nov 2022 08:11:47 +0100

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
ext4_update_bh_state.  x86 CMPXCHG instruction returns success in ZF flag,
so this change saves a compare after cmpxchg (and related move instruction
in front of cmpxchg).

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails.  There is no need to re-read the value in the loop.

No functional change intended.

Link: https://lkml.kernel.org/r/20221102071147.6642-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/ext4/inode.c~fs-ext4-use-try_cmpxchg-in-ext4_update_bh_state
+++ a/fs/ext4/inode.c
@@ -786,11 +786,10 @@ static void ext4_update_bh_state(struct
 	 * once we get rid of using bh as a container for mapping information
 	 * to pass to / from get_block functions, this can go away.
 	 */
+	old_state = READ_ONCE(bh->b_state);
 	do {
-		old_state = READ_ONCE(bh->b_state);
 		new_state = (old_state & ~EXT4_MAP_FLAGS) | flags;
-	} while (unlikely(
-		 cmpxchg(&bh->b_state, old_state, new_state) != old_state));
+	} while (unlikely(!try_cmpxchg(&bh->b_state, &old_state, new_state)));
 }
 
 static int _ext4_get_block(struct inode *inode, sector_t iblock,
_

Patches currently in -mm which might be from ubizjak@gmail.com are

lib-genalloc-use-try_cmpxchg-in-setclear_bits_ll.patch
fs-ext4-use-try_cmpxchg-in-ext4_update_bh_state.patch

