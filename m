Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7C9C7EE23
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 00:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbjFIAwM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jun 2023 20:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbjFIAwL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jun 2023 20:52:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394B62700;
        Thu,  8 Jun 2023 17:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C03C06205D;
        Fri,  9 Jun 2023 00:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2026AC433EF;
        Fri,  9 Jun 2023 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686271929;
        bh=D8jN7POGzEWAMNxYZYQtwN33KV4upnv0wByaPHA0W2A=;
        h=Date:To:From:Subject:From;
        b=gACkwZovJm2SndJGFpNdxvTR9nTMYxhcYCOQ33vEu1NssgM7z+qJU8FwEqg/FG963
         zYejZ3uqfykzRSlWBsH0/qDP0tpU+1Bia0Om3WpurKuCixaDIYzyg1g68rZegncJcP
         fniM9Led1IrIY8kcr9l0mw9xOyAlso1IZNTBif5c=
Date:   Thu, 08 Jun 2023 17:52:08 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        dhowells@redhat.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + afs-fix-waiting-for-writeback-then-skipping-folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20230609005209.2026AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: afs: fix waiting for writeback then skipping folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     afs-fix-waiting-for-writeback-then-skipping-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/afs-fix-waiting-for-writeback-then-skipping-folio.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: afs: fix waiting for writeback then skipping folio
Date: Wed, 7 Jun 2023 13:41:20 -0700

Commit acc8d8588cb7 converted afs_writepages_region() to write back a
folio batch. The function waits for writeback to a folio, but then
proceeds to the rest of the batch without trying to write that folio
again. This patch fixes has it attempt to write the folio again.

This has only been compile tested.

Link: https://lkml.kernel.org/r/20230607204120.89416-2-vishal.moola@gmail.com
Fixes: acc8d8588cb7 ("afs: convert afs_writepages_region() to use filemap_get_folios_tag()")
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/afs/write.c~afs-fix-waiting-for-writeback-then-skipping-folio
+++ a/fs/afs/write.c
@@ -731,6 +731,7 @@ static int afs_writepages_region(struct
 			 * (changing page->mapping to NULL), or even swizzled
 			 * back from swapper_space to tmpfs file mapping
 			 */
+try_again:
 			if (wbc->sync_mode != WB_SYNC_NONE) {
 				ret = folio_lock_killable(folio);
 				if (ret < 0) {
@@ -757,6 +758,7 @@ static int afs_writepages_region(struct
 #ifdef CONFIG_AFS_FSCACHE
 					folio_wait_fscache(folio);
 #endif
+					goto try_again;
 				} else {
 					start += folio_size(folio);
 				}
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

afs-fix-dangling-folio-ref-counts-in-writeback.patch
afs-fix-waiting-for-writeback-then-skipping-folio.patch

