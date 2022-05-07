Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F62C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 21:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354984AbiEGV7T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 17:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350158AbiEGV7S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 17:59:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15202FD03
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 14:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B65A60F22
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 21:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0B0C385A5;
        Sat,  7 May 2022 21:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651960528;
        bh=7aPOyFk3EKRJSIMegInqL8cCxdLc0RGTAPFCawhBX+k=;
        h=Date:To:From:Subject:From;
        b=tpsJD4NH05mWouF2PeifZv+gCL/c2BDkFTYcF4jHNwsC64haVrMlfVvJRSyYjD+HG
         MV9Ld23IgkwVf0O+wHFFhPeGmt1ejlz1L2VrsEkXRuA18CTDSs17He0zCvQDUOxR9F
         n1diDg+nVpJAXlQk0qiuCRFhiC2MLrQsQWIcFuu0=
Date:   Sat, 07 May 2022 14:55:28 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, linmiaohe@huawei.com,
        hch@lst.de, geert+renesas@glider.be, neilb@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-thp-in-swap_page_fs-count_vm_events.patch added to mm-unstable branch
Message-Id: <20220507215528.DE0B0C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MM: handle THP in swap_*page_fs() - count_vm_events()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-thp-in-swap_page_fs-count_vm_events.patch

This patch should soon appear in the mm-unstable branch at
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
From: "NeilBrown" <neilb@suse.de>
Subject: MM: handle THP in swap_*page_fs() - count_vm_events()

We need to use count_swpout_vm_event() for sio_write_complete() to get
correct counting.

Note that THP swap in (if it ever happens) is current accounted 1 for each
page, whether HUGE or normal.  This is different from swap-out accounting.

This patch should be squashed into
    MM: handle THP in swap_*page_fs()

Link: https://lkml.kernel.org/r/165146948934.24404.5909750610552745025@noble.neil.brown.name
Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-handle-thp-in-swap_page_fs-count_vm_events
+++ a/mm/page_io.c
@@ -280,8 +280,10 @@ static void sio_write_complete(struct ki
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
-	} else
-		count_vm_events(PSWPOUT, sio->pages);
+	} else {
+		for (p = 0; p < sio->pages; p++)
+			count_swpout_vm_event(sio->bvec[p].bv_page);
+	}
 
 	for (p = 0; p < sio->pages; p++)
 		end_page_writeback(sio->bvec[p].bv_page);
_

Patches currently in -mm which might be from neilb@suse.de are

mm-create-new-mm-swaph-header-file.patch
mm-drop-swap_dirty_folio.patch
mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch
mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch
mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch
nfs-rename-nfs_direct_io-and-use-as-swap_rw.patch
mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw.patch
doc-update-documentation-for-swap_activate-and-swap_rw.patch
mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch
mm-submit-multipage-write-for-swp_fs_ops-swap-space.patch
mm-handle-thp-in-swap_page_fs.patch
mm-handle-thp-in-swap_page_fs-count_vm_events.patch
vfs-add-fmode_can_odirect-file-flag.patch
mm-discard-__gfp_atomic.patch

