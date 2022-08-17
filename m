Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DA9C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbiHQPSV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239900AbiHQPSU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:18:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AF32738
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:18:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DB638CE1D4B
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F5FC433C1;
        Wed, 17 Aug 2022 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660749495;
        bh=UY8qLbO9DntgLSGM3ZnXf2eECP2cUGog0l50DA4L1gM=;
        h=Date:To:From:Subject:From;
        b=PgWiHwQBxjxKkFUaR4wVTpJxWWopuS8E+iKfQw5Uz+4NqJy6ZVM3danHJu+dvBV/Q
         Wlo2PVfyyMeE/hx3HsiXzx56eeafzH9c0lXDJ/0EHA50tWIbL/m5x3mDaXF8r0EyDO
         nM1J6cWAvab6MbzPdm6/qZmdT5mQB1kjqDiz5BQo=
Date:   Wed, 17 Aug 2022 08:18:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        kent.overstreet@gmail.com, kanie@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemapc-fix-the-timing-of-asignment-of-prev_pos.patch added to mm-hotfixes-unstable branch
Message-Id: <20220817151814.E1F5FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: fix the timing of asignment of prev_pos
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-filemapc-fix-the-timing-of-asignment-of-prev_pos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemapc-fix-the-timing-of-asignment-of-prev_pos.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Guixin Liu <kanie@linux.alibaba.com>
Subject: mm/filemap.c: fix the timing of asignment of prev_pos
Date: Wed, 17 Aug 2022 21:51:57 +0800

When I`m running repetitive 4k read io which has same offset, I find that
access to folio_mark_accessed is inevitable in the read process, the
reason is that the prev_pos is assigned after the iocb->ki_pos is
incremented, so that the prev_pos is always not equal to the position
currently visited.

The prev_pos should be assigned before the iocb->ki_pos is incremented, so
that the prev_pos is the exact location of the last visit.

Link: https://lkml.kernel.org/r/1660744317-8183-1-git-send-email-kanie@linux.alibaba.com
Fixes: 06c0444290cec ("mm/filemap.c: generic_file_buffered_read() now uses find_get_pages_contig")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemapc-fix-the-timing-of-asignment-of-prev_pos
+++ a/mm/filemap.c
@@ -2711,8 +2711,8 @@ ssize_t filemap_read(struct kiocb *iocb,
 			copied = copy_folio_to_iter(folio, offset, bytes, iter);
 
 			already_read += copied;
-			iocb->ki_pos += copied;
 			ra->prev_pos = iocb->ki_pos;
+			iocb->ki_pos += copied;
 
 			if (copied < bytes) {
 				error = -EFAULT;
_

Patches currently in -mm which might be from kanie@linux.alibaba.com are

mm-filemapc-fix-the-timing-of-asignment-of-prev_pos.patch

