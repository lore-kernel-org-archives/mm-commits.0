Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4BBC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357388AbiCYBfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357430AbiCYBeu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402A5BF951
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E67A5B82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A24C340ED;
        Fri, 25 Mar 2022 01:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171950;
        bh=8/4U22rWhJyvs4GeiGgjBwQa6YI6rTpX+36zPueE+Os=;
        h=Date:To:From:Subject:From;
        b=aIO1KJoCimE8BvUJHpHurAsH19RT74R3Prz47ViEKQgffXf1t78pHPq1pk+eAQBi9
         tjTJruRxRR/u7MX6MOBDKbwtbriUvbWvC68BSrAH3tLmIog7bA1R3J12Qw93BVP8wp
         U4duLCRrzffu13iR+YaWoH/+ZH/nMOjADmqNiiK0=
Date:   Thu, 24 Mar 2022 18:32:30 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-madvise-use-vma_lookup-instead-of-find_vma.patch removed from -mm tree
Message-Id: <20220325013230.A2A24C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: use vma_lookup() instead of find_vma()
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-vma_lookup-instead-of-find_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/madvise: use vma_lookup() instead of find_vma()

Using vma_lookup() verifies the start address is contained in the found
vma.  This results in easier to read the code.

Link: https://lkml.kernel.org/r/20220311082731.63513-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-vma_lookup-instead-of-find_vma
+++ a/mm/madvise.c
@@ -849,8 +849,8 @@ static long madvise_populate(struct vm_a
 		 * our VMA might have been split.
 		 */
 		if (!vma || start >= vma->vm_end) {
-			vma = find_vma(mm, start);
-			if (!vma || start < vma->vm_start)
+			vma = vma_lookup(mm, start);
+			if (!vma)
 				return -ENOMEM;
 		}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

