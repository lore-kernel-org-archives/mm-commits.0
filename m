Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D789CC7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbjFLVDy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235965AbjFLVDf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:03:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8779930F1;
        Mon, 12 Jun 2023 13:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACF1E61FBF;
        Mon, 12 Jun 2023 20:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A48C4339B;
        Mon, 12 Jun 2023 20:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686603486;
        bh=hxd+LoMEJ9cO+c0Tt7pmCAOX8bgWzrmk3POIw6h1Mto=;
        h=Date:To:From:Subject:From;
        b=IQbg5mq/kCd4IGpOOCbUUGcJaFBfyJjw5RmYJpmmSbDJvB79DnRFfqfmfEBDRE6mc
         SScp5berKNyLzM1gX+umvE2b8MzbJ06hj7rteLT+xfZBAfNumJ1KP/44LBfET6oh6a
         jtIL9MrXGfstcWm1PwfSTXwB9HYhOc7j5sOOMYg0=
Date:   Mon, 12 Jun 2023 13:58:05 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-prevent-general-protection-fault-in-nilfs_clear_dirty_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20230612205806.08A48C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: prevent general protection fault in nilfs_clear_dirty_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-prevent-general-protection-fault-in-nilfs_clear_dirty_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-prevent-general-protection-fault-in-nilfs_clear_dirty_page.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: prevent general protection fault in nilfs_clear_dirty_page()
Date: Mon, 12 Jun 2023 11:14:56 +0900

In a syzbot stress test that deliberately causes file system errors on
nilfs2 with a corrupted disk image, it has been reported that
nilfs_clear_dirty_page() called from nilfs_clear_dirty_pages() can cause a
general protection fault.

In nilfs_clear_dirty_pages(), when looking up dirty pages from the page
cache and calling nilfs_clear_dirty_page() for each dirty page/folio
retrieved, the back reference from the argument page to "mapping" may have
been changed to NULL (and possibly others).  It is necessary to check this
after locking the page/folio.

So, fix this issue by not calling nilfs_clear_dirty_page() on a page/folio
after locking it in nilfs_clear_dirty_pages() if the back reference
"mapping" from the page/folio is different from the "mapping" that held
the page/folio just before.

Link: https://lkml.kernel.org/r/20230612021456.3682-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+53369d11851d8f26735c@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/000000000000da4f6b05eb9bf593@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/page.c~nilfs2-prevent-general-protection-fault-in-nilfs_clear_dirty_page
+++ a/fs/nilfs2/page.c
@@ -370,7 +370,15 @@ void nilfs_clear_dirty_pages(struct addr
 			struct folio *folio = fbatch.folios[i];
 
 			folio_lock(folio);
-			nilfs_clear_dirty_page(&folio->page, silent);
+
+			/*
+			 * This folio may have been removed from the address
+			 * space by truncation or invalidation when the lock
+			 * was acquired.  Skip processing in that case.
+			 */
+			if (likely(folio->mapping == mapping))
+				nilfs_clear_dirty_page(&folio->page, silent);
+
 			folio_unlock(folio);
 		}
 		folio_batch_release(&fbatch);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-buffer-corruption-due-to-concurrent-device-reads.patch
nilfs2-prevent-general-protection-fault-in-nilfs_clear_dirty_page.patch

