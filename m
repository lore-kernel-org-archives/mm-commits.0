Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4669EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DFCC60EB6
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344458AbhIXWdP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhIXWdP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:33:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A39D60D07;
        Fri, 24 Sep 2021 22:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632522701;
        bh=gyyd4N7XImB9zxq9uRtDXvf4JW+oxC9b8JZRzUooF/I=;
        h=Date:From:To:Subject:From;
        b=HqDd/O8IwfGyCCTiYFCghsUUa+CaF6W7buE7IeiFQZMgqR7/ZlGTImGejo3JlAlFh
         EcLMS7GqeVS5OIt+vKZ/dpk+S0EfMtN2vWSgYWU74yk9hnnUI3qSoDNQEYw4x7mYhp
         34CMm5BAvEkgNApV+X6WynEmBByZ8R1Y9o/n8HYA=
Date:   Fri, 24 Sep 2021 15:31:41 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        songmuchun@bytedance.com, zhengqi.arch@bytedance.com
Subject:  [folded-merged]
 mm-memory_failure-fix-the-missing-pte_unmap-call-fix.patch removed from -mm
 tree
Message-ID: <20210924223141.fjUUeel-T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_failure-fix-the-missing-pte_unmap-call-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-fix-the-missing-pte_unmap-call-fix.patch

This patch was dropped because it was folded into mm-memory_failure-fix-the-missing-pte_unmap-call.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_failure-fix-the-missing-pte_unmap-call-fix

cleanup

Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-fix-the-missing-pte_unmap-call-fix
+++ a/mm/memory-failure.c
@@ -330,11 +330,8 @@ static unsigned long dev_pagemap_mapping
 	if (pmd_devmap(*pmd))
 		return PMD_SHIFT;
 	pte = pte_offset_map(pmd, address);
-	if (!pte_present(*pte))
-		goto unmap;
-	if (pte_devmap(*pte))
+	if (pte_present(*pte) && pte_devmap(*pte))
 		ret = PAGE_SHIFT;
-unmap:
 	pte_unmap(pte);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_failure-fix-the-missing-pte_unmap-call.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

