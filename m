Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CD7ECAAD4
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 20:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiH2UDh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 16:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiH2UDg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 16:03:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3C897D59
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 13:03:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A416B811F5
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 20:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CEFC433D6;
        Mon, 29 Aug 2022 20:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661803413;
        bh=1kwG6GroX+LInIj+BoYB+OhU7xatAHOwn01hEfh6qD8=;
        h=Date:To:From:Subject:From;
        b=F/6s+9VlWd/spMtHTTS7TPwDX+2XZmofgFTerFB3EjKltZNuY505XLqQOF5Mpq2if
         p8bfzq4XcoG8Pt39FEZ4CnDSa90Eh1aH25qn89SFvmJ33YWRG/SaHbJLHHiDjfflXx
         mLlqQsZqtc4J3+X1saV4j1yryTQDDbo4pz1Al32I=
Date:   Mon, 29 Aug 2022 13:03:32 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-mark-swap_lock-and-swap_active_head-static.patch added to mm-unstable branch
Message-Id: <20220829200333.23CEFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: mark swap_lock and swap_active_head static"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-mm-mark-swap_lock-and-swap_active_head-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-mark-swap_lock-and-swap_active_head-static.patch

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
From: Liu Shixin <liushixin2@huawei.com>
Subject: Revert "mm: mark swap_lock and swap_active_head static"
Date: Mon, 29 Aug 2022 21:22:58 +0800

This reverts commit 633423a09cb5cfe61438283e1ce49c23cf4a0611.

swap_lock and swap_active_head will be used in the next patch, so export
them again.

Link: https://lkml.kernel.org/r/20220829132302.3367054-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapfile.h |    2 ++
 mm/swapfile.c            |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/swapfile.h~revert-mm-mark-swap_lock-and-swap_active_head-static
+++ a/include/linux/swapfile.h
@@ -6,6 +6,8 @@
  * these were static in swapfile.c but frontswap.c needs them and we don't
  * want to expose them to the dozens of source files that include swap.h
  */
+extern spinlock_t swap_lock;
+extern struct plist_head swap_active_head;
 extern struct swap_info_struct *swap_info[];
 extern unsigned long generic_max_swapfile_size(void);
 /* Maximum swapfile size supported for the arch (not inclusive). */
--- a/mm/swapfile.c~revert-mm-mark-swap_lock-and-swap_active_head-static
+++ a/mm/swapfile.c
@@ -51,7 +51,7 @@ static bool swap_count_continued(struct
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
 
-static DEFINE_SPINLOCK(swap_lock);
+DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 /*
@@ -77,7 +77,7 @@ static const char Unused_offset[] = "Unu
  * all active swap_info_structs
  * protected with swap_lock, and ordered by priority.
  */
-static PLIST_HEAD(swap_active_head);
+PLIST_HEAD(swap_active_head);
 
 /*
  * all available (active, not full) swap_info_structs
_

Patches currently in -mm which might be from liushixin2@huawei.com are

revert-frontswap-remove-support-for-multiple-ops.patch
revert-mm-mark-swap_lock-and-swap_active_head-static.patch
revert-frontswap-simplify-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch

