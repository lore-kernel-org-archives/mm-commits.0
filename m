Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02282EE020D
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 21:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbjIMVuk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbjIMVuh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 17:50:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C65D1BC6
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 14:50:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF179C433CB;
        Wed, 13 Sep 2023 21:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694641832;
        bh=UoyGWgjLljZqRGdUH3Y5vwB+523v3pygnnRBsQ+r8RU=;
        h=Date:To:From:Subject:From;
        b=cvgfhcQH1d/wpPGbetSSSy63wyGCT5nJNxLkJerQgpkCFwdfOqBcxMq17AMsOfHos
         2FyeUdhxi2APBopGQGZYELRkvn9CjqtU3plHglbILAJ7ZARlK4PdJtixEePU+uG3Zi
         9GNsE+G3uc9xzBEZwDIr6qbXoft+4sm74KcGuka4=
Date:   Wed, 13 Sep 2023 14:50:32 -0700
To:     mm-commits@vger.kernel.org, vernhao@tencent.com,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230913215032.BF179C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix
Date: Wed Sep 13 02:48:29 PM PDT 2023

fix swap_writepage_fs(), per Johannes

Link: https://lkml.kernel.org/r/20230913213343.GB48476@cmpxchg.org
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Xin Hao <vernhao@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_io.c~mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix
+++ a/mm/page_io.c
@@ -295,7 +295,7 @@ static void swap_writepage_fs(struct pag
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = page_file_offset(page);
 
-	count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
+	count_swpout_vm_event(page_folio(page));
 	set_page_writeback(page);
 	unlock_page(page);
 	if (wbc->swap_plug)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
revert-scripts-gdb-symbols-add-specific-ko-module-load-command.patch
kthread-add-kthread_stop_put-v2-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch

