Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4C4C04A6A
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 18:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjHDSMq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjHDSMY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 14:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E570B4C18
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 11:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 747A2620E7
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 18:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24ACC433C7;
        Fri,  4 Aug 2023 18:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691172731;
        bh=x9zJTS26Lq9v20sHRi8Iua4mWuCeZBz3fvUeQVkobvU=;
        h=Date:To:From:Subject:From;
        b=GSEJWvQhvPsWLURgiJ3ntCKlmrcUZnXA9+N3rEq0gEEcaPB2KQMUSMSeoTPCcdoRz
         2GTT5oGNey760KlMTfVxPA0UrhI1TtUfYrmJ4bci/3+yMa3+aOPplXqI+KCd8HCJ0x
         i/hQs20BG12M52e3kLQf+a49khC5p5NLsPY3zqYk=
Date:   Fri, 04 Aug 2023 11:12:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfilec-use-helper-macro-k.patch added to mm-unstable branch
Message-Id: <20230804181211.D24ACC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: use helper macro K()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfilec-use-helper-macro-k.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfilec-use-helper-macro-k.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/swapfile.c: use helper macro K()
Date: Fri, 4 Aug 2023 09:25:54 +0800

Use helper macro K() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230804012559.2617515-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-use-helper-macro-k
+++ a/mm/swapfile.c
@@ -46,6 +46,7 @@
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
 #include <linux/swap_cgroup.h>
+#include "internal.h"
 #include "swap.h"
 
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
@@ -2635,8 +2636,8 @@ static int swap_show(struct seq_file *sw
 		return 0;
 	}
 
-	bytes = si->pages << (PAGE_SHIFT - 10);
-	inuse = READ_ONCE(si->inuse_pages) << (PAGE_SHIFT - 10);
+	bytes = K(si->pages);
+	inuse = K(READ_ONCE(si->inuse_pages));
 
 	file = si->swap_file;
 	len = seq_file_path(swap, file, " \t\n\\");
@@ -2861,8 +2862,7 @@ static unsigned long read_swap_header(st
 	}
 	if (last_page > maxpages) {
 		pr_warn("Truncating oversized swap area, only using %luk out of %luk\n",
-			maxpages << (PAGE_SHIFT - 10),
-			last_page << (PAGE_SHIFT - 10));
+			K(maxpages), K(last_page));
 	}
 	if (maxpages > last_page) {
 		maxpages = last_page + 1;
@@ -3184,8 +3184,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 	enable_swap_info(p, prio, swap_map, cluster_info);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
-		p->pages<<(PAGE_SHIFT-10), name->name, p->prio,
-		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
+		K(p->pages), name->name, p->prio, nr_extents,
+		K((unsigned long long)span),
 		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(p->flags & SWP_DISCARDABLE) ? "D" : "",
 		(p->flags & SWP_AREA_DISCARD) ? "s" : "",
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch
mm-page_io-remove-unneeded-clearpageuptodate.patch
mm-page_io-remove-unneeded-setpageerror.patch
mm-page_io-introduce-bio_first_folio_all.patch
mm-page_io-use-a-folio-in-__end_swap_bio_write.patch
mm-page_io-use-a-folio-in-__end_swap_bio_read.patch
mm-page_io-use-a-folio-in-sio_read_complete.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch
mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch
mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch
mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch
mm-remove-redundant-k-macro-definition.patch
mm-swapfilec-use-helper-macro-k.patch
mm-swap_statec-use-helper-macro-k.patch
mm-shmemc-use-helper-macro-k.patch
mm-nommuc-use-helper-macro-k.patch
mm-mmapc-use-helper-macro-k.patch
mm-hugetlbc-use-helper-macro-k.patch

