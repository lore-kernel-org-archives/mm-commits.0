Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3567E7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjJDURP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjJDURO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09806AD
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684CBC433C7;
        Wed,  4 Oct 2023 20:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450630;
        bh=jM21kcQ3cHY8iKevs3NUpGlpmCDxhkVmy3v6yBC/QpY=;
        h=Date:To:From:Subject:From;
        b=byQADSLOk2fXyiF8YQtyaw6UndNWn6krS5y0FDsdVC8v8tigH7qkbm+Ibu/adIBkE
         vCF1SyT9KxFoUGO3owNQhCn6nc35TNw8BRJeN63X2aznZChMAzxOqq7hXYeb5kS/ZV
         t8Y2/XWlQMvbTegmEGOR9RMr30oklaAShOPw/I4w=
Date:   Wed, 04 Oct 2023 13:17:08 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch removed from -mm tree
Message-Id: <20231004201710.684CBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-shrinker-convert-shrinker_rwsem-to-mutex-fix
has been removed from the -mm tree.  Its filename was
     mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch

This patch was dropped because it was folded into mm-shrinker-convert-shrinker_rwsem-to-mutex.patch

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
mm-shrinker-convert-shrinker_rwsem-to-mutex.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix.patch
kthread-add-kthread_stop_put-v2-fix.patch

