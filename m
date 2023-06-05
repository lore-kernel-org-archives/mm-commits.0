Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31B7C7EE24
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 21:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjFEVF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjFEVF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 17:05:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03582ED
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 14:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84B76628AD
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 21:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC55CC433D2;
        Mon,  5 Jun 2023 21:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685999124;
        bh=onDmxo+YWdTO1ywhCnz+i4g5VcbtgweHoIWaraXqqOM=;
        h=Date:To:From:Subject:From;
        b=GyoVYr7NbFX8qdHLfwaqWJeuIuFcJuuNowSp5YF+O6tSnKGYCi162RzWn40GSElvc
         l6+7D28i+/8fwqiLxB8w9rRxLJGYKhxjdH++AJVDJZ7HXm6W5JTLoA9dr0HT+Gtsxd
         GkZiJkOwcAAEStjRl3Ez4xFC0hBhr865yeKYt0Uk=
Date:   Mon, 05 Jun 2023 14:05:24 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, tglx@linutronix.de,
        hch@lst.de, bhe@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix.patch added to mm-unstable branch
Message-Id: <20230605210524.CC55CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix.patch

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

lib-test_vmallocc-avoid-garbage-in-page-array.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch
mm-gup-add-missing-gup_must_unshare-check-to-gup_huge_pgd.patch
mm-gup-remove-unused-vmas-parameter-from-get_user_pages.patch
mm-gup-remove-unused-vmas-parameter-from-pin_user_pages_remote.patch
mm-gup-remove-vmas-parameter-from-get_user_pages_remote.patch
io_uring-rsrc-delegate-vma-file-backed-check-to-gup.patch
mm-gup-remove-vmas-parameter-from-pin_user_pages.patch
mm-gup-remove-vmas-array-from-internal-gup-functions.patch
mm-mmap-refactor-mlock_future_check.patch
mm-vmalloc-dont-purge-usable-blocks-unnecessarily-fix.patch

