Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315F6C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjFIXU1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjFIXU0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:20:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C4930D7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616AD65CAE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2464C433D2;
        Fri,  9 Jun 2023 23:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352824;
        bh=PQNy1pKSYaUU7HAf6+W1WJb2h1tZCrtOrvSOuiZLkkw=;
        h=Date:To:From:Subject:From;
        b=ufNaLnEyxr8QlvOqE5UOjZeq1UyVw23ZYsdoZei4EMzDFzKICo7CijVB5altY4Qfi
         R05+dpmyg4TjVtGfw2xfH5onp/NXNKSQCqCusiYcc+B07CavWQX02j/k6tTW4ZLhfk
         xwoQXt3gh0BxSS0jOwgSSXRhMOR+VOAXPN1djPB0=
Date:   Fri, 09 Jun 2023 16:20:24 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, tglx@linutronix.de,
        hch@lst.de, bhe@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix.patch removed from -mm tree
Message-Id: <20230609232024.B2464C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix.patch

This patch was dropped because it was folded into mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix
Date: Mon, 5 Jun 2023 21:44:20 +0100

We do NOT purge if this conditional evalutates true, so correct
VMAP_PURGE_THRESHOLD check.

Link: https://lkml.kernel.org/r/3e92ef61-b910-4576-88e7-cf43211fd4e7@lucifer.local
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix
+++ a/mm/vmalloc.c
@@ -2102,7 +2102,7 @@ static bool purge_fragmented_block(struc
 		return false;
 
 	/* Don't overeagerly purge usable blocks unless requested */
-	if (!force_purge && vb->free < VMAP_PURGE_THRESHOLD)
+	if (!(force_purge || vb->free < VMAP_PURGE_THRESHOLD))
 		return false;
 
 	/* prevent further allocs after releasing lock */
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch
mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch
mm-gup-remove-unused-vmas-parameter-from-get_user_pages.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote.patch
io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch
mm-gup-remove-vmas-parameter-from-pin_user_pages.patch
mm-gup-remove-vmas-array-from-internal-gup-functions.patch
mm-mmap-refactor-mlock_future_check.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

