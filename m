Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5047CC77B73
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 19:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjE3Tqd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 15:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjE3Tqc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 15:46:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88B2E8
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 12:46:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65D19631F2
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 19:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2BCC433D2;
        Tue, 30 May 2023 19:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685475989;
        bh=fgU5YXo203+SznXiUsc6C+GXnmravncUZal15E3zfro=;
        h=Date:To:From:Subject:From;
        b=rvcojAh5cmmiLak5DQ7fGOyDXo8Vy+H/vzsvxS017x1KYGmocZltY0+y0IFP/M6r9
         cyM0tnS0xZny9oOIceaz6t2cnfLsqtvvnTR88uX+5m296pzQ4HYad1wt2hd5AJTlJF
         kjag4MUaOK6JGFc2tBe6F1zQoRNW5FFAOfEwy5ZA=
Date:   Tue, 30 May 2023 12:46:28 -0700
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk, hch@lst.de,
        vincent.whitchurch@axis.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-cache-partial-compressed-blocks-fix-2.patch added to mm-nonmm-unstable branch
Message-Id: <20230530194629.BD2BCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: fix page update race
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-cache-partial-compressed-blocks-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-cache-partial-compressed-blocks-fix-2.patch

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
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: squashfs: fix page update race
Date: Fri, 26 May 2023 15:25:45 +0200

We only put the page into the cache after we've read it, so the
PageUptodate() check should not be necessary.  In fact, it's actively
harmful since the check could fail (since we used find_get_page() and not
find_lock_page()) and we could end up submitting a page for I/O after it
has been read and while it's actively being used, which could lead to
corruption depending on what the block driver does with it.

Link: https://lkml.kernel.org/r/20230526-squashfs-cache-fixup-v1-1-d54a7fa23e7b@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-cache-partial-compressed-blocks-fix-2
+++ a/fs/squashfs/block.c
@@ -92,7 +92,7 @@ static int squashfs_bio_read_cached(stru
 	bio_for_each_segment_all(bv, fullbio, iter_all) {
 		struct page *page = bv->bv_page;
 
-		if (page->mapping == cache_mapping && PageUptodate(page)) {
+		if (page->mapping == cache_mapping) {
 			idx++;
 			continue;
 		}
_

Patches currently in -mm which might be from vincent.whitchurch@axis.com are

squashfs-cache-partial-compressed-blocks.patch
squashfs-cache-partial-compressed-blocks-fix-2.patch
squashfs-cache-partial-compressed-blocks-fix-3.patch

