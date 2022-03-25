Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A95C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346745AbiCYBds (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357426AbiCYBdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2274BF014
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F1D56192B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BEDC340EC;
        Fri, 25 Mar 2022 01:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171863;
        bh=0vzBf4H2OaIBG81j7USwhFZM//9hGtY6gIJd5Gzuj4E=;
        h=Date:To:From:Subject:From;
        b=xiPIw+CUcIBocFAuk6CvkOEfuvHFxwjJMyE3ET9oxnLoZWWo8rnqT/7whmz2IiupU
         79iAmJyWPHKxVRbBjco3A4ijkI7wACJ4/TqxlWG9FiItRZ4CSSp69/mbN5bnfGTiwP
         4JW6jJaGv68v+6FZITMVUNCLcv9cZc9rFg3niBEc=
Date:   Thu, 24 Mar 2022 18:31:03 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-use-helper-function-range_in_vma.patch removed from -mm tree
Message-Id: <20220325013103.D0BEDC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: use helper function range_in_vma()
has been removed from the -mm tree.  Its filename was
     mm-use-helper-function-range_in_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory.c: use helper function range_in_vma()

Use helper function range_in_vma() to check if address, address + size are
within the vma range.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220219021441.29173-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-use-helper-function-range_in_vma
+++ a/mm/memory.c
@@ -1715,7 +1715,7 @@ static void zap_page_range_single(struct
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
-	if (address < vma->vm_start || address + size > vma->vm_end ||
+	if (!range_in_vma(vma, address, address + size) ||
 	    		!(vma->vm_flags & VM_PFNMAP))
 		return;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

