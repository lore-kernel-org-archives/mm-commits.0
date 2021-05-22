Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E123C2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A5761175
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhEVTR5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 15:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231340AbhEVTR4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 15:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8136D61073;
        Sat, 22 May 2021 19:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621710991;
        bh=qL13u5aduULltYlUHQLyHFvl9xPTw4UqKPXUJignAqw=;
        h=Date:From:To:Subject:From;
        b=ltMe8KDMlREhVIvXOp6oqD94qZB3b3eXWelCqVo4j5V5vroDou7b5um4EEPpvrv37
         vAIL5fMD8ejAWs/I0MGlBrqqnXpy9UwBISibBNQ6/hiBkMw6B4DH3ZptotblPbu4E/
         LADK3GPtWBlv4lpg2x5yZ1YJ5/myhLswjoD6ME1M=
Date:   Sat, 22 May 2021 12:16:30 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, colin.king@canonical.com, ddstreet@ieee.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        nathan@kernel.org, sjenning@redhat.com, tiantao6@hisilicon.com,
        vitaly.wool@konsulko.com
Subject:  +
 mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch added to -mm tree
Message-ID: <20210522191630.rrcCzhSvh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap.c: remove unused function zswap_debugfs_exit()
has been added to the -mm tree.  Its filename is
     mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/zswap.c: remove unused function zswap_debugfs_exit()

Patch series "Cleanup and fixup for zswap".

This series contains cleanups to remove unused function and avoid
unnecessary copy-in at map time.  Also this fixes two bugs in the function
zswap_writeback_entry().  More details can be found in the respective
changelogs.


This patch (of 3):

zswap_debugfs_exit() is unused, remove it.

Link: https://lkml.kernel.org/r/20210522092242.3233191-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210522092242.3233191-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/zswap.c~mm-zswapc-remove-unused-function-zswap_debugfs_exit
+++ a/mm/zswap.c
@@ -1427,18 +1427,11 @@ static int __init zswap_debugfs_init(voi
 
 	return 0;
 }
-
-static void __exit zswap_debugfs_exit(void)
-{
-	debugfs_remove_recursive(zswap_debugfs_root);
-}
 #else
 static int __init zswap_debugfs_init(void)
 {
 	return 0;
 }
-
-static void __exit zswap_debugfs_exit(void) { }
 #endif
 
 /*********************************
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

