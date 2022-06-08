Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838E4C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 18:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbiFHScy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 14:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiFHScw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 14:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6872A2E09A
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 11:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0335C61B4C
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 18:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5790EC34116;
        Wed,  8 Jun 2022 18:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654713168;
        bh=4bhdy5lVM5PENzD/SZd+p/q8zDydCE0tPQcLqrUB/tQ=;
        h=Date:To:From:Subject:From;
        b=hHsgaQT1qHoGWGVmPT//3uOE5pDV6pevus18GxW9KlbXrv635JDBG7dBuDB4gGhj2
         fw7IqV3gMEy5qDpYQPn8jcqSl0v6umq++OlHqPIyXzDkFSH0q4SNFhKm6yrWPkgC+e
         n7jjdycOcyz3qmswVFtTN7A2xtzQH/Y/3pnn7a2Q=
Date:   Wed, 08 Jun 2022 11:32:47 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-fix-possible-data-races-of-inuse_pages.patch added to mm-unstable branch
Message-Id: <20220608183248.5790EC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: fix possible data races of inuse_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-fix-possible-data-races-of-inuse_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-fix-possible-data-races-of-inuse_pages.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: fix possible data races of inuse_pages
Date: Wed, 8 Jun 2022 22:40:30 +0800

si->inuse_pages could still be accessed concurrently now.  The plain reads
outside si->lock critical section, i.e.  swap_show and si_swapinfo, which
results in data races.  But these should be ok because they're just used
for showing swap info.

Link: https://lkml.kernel.org/r/20220608144031.829-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-possible-data-races-of-inuse_pages
+++ a/mm/swapfile.c
@@ -2646,7 +2646,7 @@ static int swap_show(struct seq_file *sw
 	}
 
 	bytes = si->pages << (PAGE_SHIFT - 10);
-	inuse = si->inuse_pages << (PAGE_SHIFT - 10);
+	inuse = READ_ONCE(si->inuse_pages) << (PAGE_SHIFT - 10);
 
 	file = si->swap_file;
 	len = seq_file_path(swap, file, " \t\n\\");
@@ -3265,7 +3265,7 @@ void si_swapinfo(struct sysinfo *val)
 		struct swap_info_struct *si = swap_info[type];
 
 		if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
-			nr_to_be_unused += si->inuse_pages;
+			nr_to_be_unused += READ_ONCE(si->inuse_pages);
 	}
 	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;
 	val->totalswap = total_swap_pages + nr_to_be_unused;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch

