Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FF0C001DC
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 16:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjG0QdP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbjG0QdC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 12:33:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C0C3ABB
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 09:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D580061ED2
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 16:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CA0C433C8;
        Thu, 27 Jul 2023 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690475487;
        bh=DkK/VLQhBBz8rnttD342NUhRnI7xX/u27h4CKOFrV9c=;
        h=Date:To:From:Subject:From;
        b=uAn3CGc/4IiN9S+KGkJl9BK+1k4szFvnasyd58+vHtXtcFNXEvdeNjVzjoKjR7I3g
         1HCvRGHoYkLhTOzljoksZJUXD0yAZyLDJjYjbBbQAA5KUD/QP2hyeeWTrXsB6WXcsF
         hUHON0lLrOiXhv8EyX1YPIfJn4MYlRK+kCmGo1SA=
Date:   Thu, 27 Jul 2023 09:31:26 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, song.bao.hua@hisilicon.com,
        sjenning@redhat.com, nphamcs@gmail.com,
        cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch added to mm-unstable branch
Message-Id: <20230727163127.33CA0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zswap: use zswap_invalidate_entry() for duplicates
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: use zswap_invalidate_entry() for duplicates
Date: Thu, 27 Jul 2023 12:22:23 -0400

Patch series "mm: zswap: three cleanups".

Three small cleanups to zswap, the first one suggested by Yosry during the
frontswap removal.


This patch (of 3):

Minor cleanup.  Instead of open-coding the tree deletion and the put, use
the zswap_invalidate_entry() convenience helper.

Link: https://lkml.kernel.org/r/20230727162343.1415598-1-hannes@cmpxchg.org
Link: https://lkml.kernel.org/r/20230727162343.1415598-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-zswap_invalidate_entry-for-duplicates
+++ a/mm/zswap.c
@@ -1370,9 +1370,7 @@ insert_entry:
 	spin_lock(&tree->lock);
 	while (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
 		zswap_duplicate_entry++;
-		/* remove from rbtree */
-		zswap_rb_erase(&tree->rbroot, dupentry);
-		zswap_entry_put(tree, dupentry);
+		zswap_invalidate_entry(tree, dupentry);
 	}
 	if (entry->length) {
 		spin_lock(&entry->pool->lru_lock);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-kill-frontswap.patch
mm-kill-frontswap-fix.patch
mm-zswap-use-zswap_invalidate_entry-for-duplicates.patch
mm-zswap-tighten-up-entry-invalidation.patch
mm-zswap-kill-zswap_get_swap_cache_page.patch

