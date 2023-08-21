Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5102EE49B5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjHUUj2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjHUUjN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D38133
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDFF064A7B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F149C433C7;
        Mon, 21 Aug 2023 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650349;
        bh=jFr3q3Fjfpnr42GZP50CokF2cIYV8RevFAh0/XNiOXY=;
        h=Date:To:From:Subject:From;
        b=Gusoqs/g7dyW6nBW4rz2RYLYK0qteeyTSkkBfzLRSlZ71HucMn5OI+H3skSSzPjKv
         fAkOfLPC+liclDXryWbHREm12jxddSZCLoq01glmFvmQHG5H4ChyPSLGzux0Tia916
         E/+7PiQEnbmAwnji1ScEnLiyblHWYMIHRK8tnnw4=
Date:   Mon, 21 Aug 2023 13:39:08 -0700
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memoryc-fix-some-kernel-doc-comments.patch removed from -mm tree
Message-Id: <20230821203909.1F149C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory.c: fix some kernel-doc comments
has been removed from the -mm tree.  Its filename was
     mm-memoryc-fix-some-kernel-doc-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm/memory.c: fix some kernel-doc comments
Date: Thu, 27 Jul 2023 09:55:58 +0800

Add description of @mas and @tree_end, remove @mt in unmap_vmas().  to
silence the warnings:

mm/memory.c:1837: warning: Function parameter or member 'mas' not described in 'unmap_vmas'
mm/memory.c:1837: warning: Function parameter or member 'tree_end' not described in 'unmap_vmas'
mm/memory.c:1837: warning: Excess function parameter 'mt' description in 'unmap_vmas'

Link: https://lkml.kernel.org/r/20230727015558.69554-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5996
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-fix-some-kernel-doc-comments
+++ a/mm/memory.c
@@ -1693,10 +1693,11 @@ static void unmap_single_vma(struct mmu_
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
- * @mt: the maple tree
+ * @mas: the maple state
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
+ * @tree_end: The maximum index to check
  * @mm_wr_locked: lock flag
  *
  * Unmap all pages in the vma list.
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are


