Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32ABE732E5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 16:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjI1QH6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjI1QH5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 12:07:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22B5D6
        for <mm-commits@vger.kernel.org>; Thu, 28 Sep 2023 09:07:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C90C433C7;
        Thu, 28 Sep 2023 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695917275;
        bh=3c1XLjpFrd4vdcQnDgrjM/9tH3a5KKYn6oP1DCBgAZE=;
        h=Date:To:From:Subject:From;
        b=Xv8DCJuotZEDyGC99kTrd1rxbPFRsJEt7din2um/pdso7ldPd5AyoSfCx1oAAg0SW
         9bMZhik48JdsOOJiqwu/9Hk1b/6bfohyO+YxKQuK3rumjjZNMmQYASeMonjUowNf5r
         hF1ajR+afV7dG33HG3aa2mIV0YCgKVe5OvZeaW0U=
Date:   Thu, 28 Sep 2023 09:07:54 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230928160755.41C90C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shrinker-convert-shrinker_rwsem-to-mutex-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch

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
Subject: mm-shrinker-convert-shrinker_rwsem-to-mutex-fix
Date: Thu Sep 28 09:06:40 AM PDT 2023

update the fix to alloc_shrinker_info()

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shrinker.c~mm-shrinker-convert-shrinker_rwsem-to-mutex-fix
+++ a/mm/shrinker.c
@@ -96,7 +96,7 @@ int alloc_shrinker_info(struct mem_cgrou
 	return ret;
 
 err:
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 	free_shrinker_info(memcg);
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
kthread-add-kthread_stop_put-v2-fix.patch
mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch

