Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CC4C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiGRAWA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiGRAUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50121092
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60F8EB80E27
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D71C341C0;
        Mon, 18 Jul 2022 00:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103525;
        bh=zPwhysMqKne0fsfENQCWijIpSfRyvEz1mMA8DO4E2l8=;
        h=Date:To:From:Subject:From;
        b=DvkcmLBIS1+EEF/RmCvMVPSJEi6MHdXtzfp3b2cvWnqStTVNcXzxe5a5JZPiNuCxd
         xefUgXTFlwt8WKlgVUShgZOToOq0DkBoSIeIltjcbfcwrdMamxqnSrl05ln51ISJPW
         dX4piHrFC9ZZm1qKYbsRCaJ1HwFWKVADdtFAH3Sg=
Date:   Sun, 17 Jul 2022 17:18:44 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-try_cmpxchg-in-set_pfnblock_flags_mask.patch removed from -mm tree
Message-Id: <20220718001845.11D71C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: use try_cmpxchg in set_pfnblock_flags_mask
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-try_cmpxchg-in-set_pfnblock_flags_mask.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: mm/page_alloc: use try_cmpxchg in set_pfnblock_flags_mask
Date: Fri, 8 Jul 2022 16:07:36 +0200

Use try_cmpxchg instead of cmpxchg in set_pfnblock_flags_mask.  x86
CMPXCHG instruction returns success in ZF flag, so this change saves a
compare after cmpxchg (and related move instruction in front of cmpxchg). 
The main loop improves from:

    1c5d:	48 89 c2             	mov    %rax,%rdx
    1c60:	48 89 c1             	mov    %rax,%rcx
    1c63:	48 21 fa             	and    %rdi,%rdx
    1c66:	4c 09 c2             	or     %r8,%rdx
    1c69:	f0 48 0f b1 16       	lock cmpxchg %rdx,(%rsi)
    1c6e:	48 39 c1             	cmp    %rax,%rcx
    1c71:	75 ea                	jne    1c5d <...>

to:

    1c60:	48 89 ca             	mov    %rcx,%rdx
    1c63:	48 21 c2             	and    %rax,%rdx
    1c66:	4c 09 c2             	or     %r8,%rdx
    1c69:	f0 48 0f b1 16       	lock cmpxchg %rdx,(%rsi)
    1c6e:	75 f0                	jne    1c60 <...>

Link: https://lkml.kernel.org/r/20220708140736.8737-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-try_cmpxchg-in-set_pfnblock_flags_mask
+++ a/mm/page_alloc.c
@@ -602,7 +602,7 @@ void set_pfnblock_flags_mask(struct page
 {
 	unsigned long *bitmap;
 	unsigned long bitidx, word_bitidx;
-	unsigned long old_word, word;
+	unsigned long word;
 
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 	BUILD_BUG_ON(MIGRATE_TYPES > (1 << PB_migratetype_bits));
@@ -618,12 +618,8 @@ void set_pfnblock_flags_mask(struct page
 	flags <<= bitidx;
 
 	word = READ_ONCE(bitmap[word_bitidx]);
-	for (;;) {
-		old_word = cmpxchg(&bitmap[word_bitidx], word, (word & ~mask) | flags);
-		if (word == old_word)
-			break;
-		word = old_word;
-	}
+	do {
+	} while (!try_cmpxchg(&bitmap[word_bitidx], &word, (word & ~mask) | flags));
 }
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
_

Patches currently in -mm which might be from ubizjak@gmail.com are

compiler-gcch-remove-ancient-workaround-for-gcc-pr-58670.patch

