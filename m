Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB89C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Nov 2023 17:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjKMRK7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Nov 2023 12:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjKMRK6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Nov 2023 12:10:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7768518D
        for <mm-commits@vger.kernel.org>; Mon, 13 Nov 2023 09:10:55 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1649CC433C7;
        Mon, 13 Nov 2023 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699895455;
        bh=5UW0dbrvc89HVJuFwa5DkI91vd5cGYlEc09cJedAPTc=;
        h=Date:To:From:Subject:From;
        b=mCRTNDxKuovjz/RG3+P/BBLzZnqjQnuMmUGDp6SX/RAtEue5DMwK+vCgxR2dasI75
         Ifqw2b6wxR/T3ygDBFQvT0yAp897n56gjlPtfF1kDRBBe3PZJXItvC/uizEErc2jNV
         vbmM6N7KCwV/+AAovbA4WjTkrmHQ4gHU/eSqbQtw=
Date:   Mon, 13 Nov 2023 09:10:54 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        p.raghav@samsung.com, mcgrof@kernel.org, konishi.ryusuke@gmail.com,
        hare@suse.de, akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-fix-grow_buffers-for-block-size-page_size-fix.patch added to mm-unstable branch
Message-Id: <20231113171055.1649CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer-fix-grow_buffers-for-block-size-page_size-fix
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: buffer-fix-grow_buffers-for-block-size-page_size-fix
Date: Mon Nov 13 09:08:21 AM PST 2023

hexagon wants __muloti4 so use a shift

Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/buffer.c~buffer-fix-grow_buffers-for-block-size-page_size-fix
+++ a/fs/buffer.c
@@ -1099,7 +1099,7 @@ static bool grow_buffers(struct block_de
 	}
 
 	/* Create a folio with the proper size buffers */
-	return grow_dev_folio(bdev, block, pos / PAGE_SIZE, size, gfp);
+	return grow_dev_folio(bdev, block, pos >> PAGE_SHIFT, size, gfp);
 }
 
 static struct buffer_head *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-for-negative-counter-nr_file_hugepages-fix.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
buffer-fix-grow_buffers-for-block-size-page_size-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

