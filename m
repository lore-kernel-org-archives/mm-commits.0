Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA48C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 05:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiCaFIe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 01:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiCaFI0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 01:08:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597E943AD9
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 22:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08F9CB81EDD
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 05:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1875C340ED;
        Thu, 31 Mar 2022 05:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648703196;
        bh=6/WJGe4ejN3nOv5ahRVbI1/v6gMk0DI3rMCHbiuanpo=;
        h=Date:To:From:Subject:From;
        b=ISGQboezVwWER2k+3WTH4arCstrGkLsd4dRyIHn8eWat22h/VL898MlBipPd6mP1y
         OaGROO7aAv+swxFe7TH2mOUxxSpUKQWF+CEZQpIjZxU4FsCHjdS+t2qQYzddnLpKnQ
         3yjsZ5BX1Lmb1BzyyLsTaMkT2pywE0QeEU0+vxdE=
Date:   Wed, 30 Mar 2022 22:06:36 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com, hch@lst.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix.patch added to -mm tree
Message-Id: <20220331050636.A1875C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix
has been added to the -mm tree.  Its filename is
     mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix

fix comment, per hch

Cc: Christoph Hellwig <hch@lst.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix
+++ a/mm/internal.h
@@ -462,7 +462,7 @@ void mlock_page_drain_remote(int cpu);
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /*
- * * Return the start of user virtual address at the specific offset within
+ * Return the start of user virtual address at the specific offset within
  * a vma.
  */
 static inline unsigned long
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

