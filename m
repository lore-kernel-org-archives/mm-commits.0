Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08519C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiKIBir (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiKIBid (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3579F26F6
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAB666181A
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B383C433D7;
        Wed,  9 Nov 2022 01:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957904;
        bh=1NzJ8Lfv1p6RGKzzBlI0tbQP3TQ6gnieZYYG84sCWfM=;
        h=Date:To:From:Subject:From;
        b=OAkZVia9v3TiirXoPEKcvEcD1vC7ssPn1AdVqc7W+sMtGGYGZ22lPMCl1KPJzxMfV
         ZTJ7FvWDzwSl2zMbbjWEaWAxv2t8Re/Jbf77Gw9gTM7G1Q7Cw/I4921hZdn8bKT2i3
         3RePg0QGL9JPJNcQcNEgqJun0uLqjhxxBJpbTsqI=
Date:   Tue, 08 Nov 2022 17:38:23 -0800
To:     mm-commits@vger.kernel.org, wangdeming@inspur.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-vma_lookup-instead-of-find_vma.patch removed from -mm tree
Message-Id: <20221109013824.1B383C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mincore.c: use vma_lookup() instead of find_vma()
has been removed from the -mm tree.  Its filename was
     mm-use-vma_lookup-instead-of-find_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deming Wang <wangdeming@inspur.com>
Subject: mm/mincore.c: use vma_lookup() instead of find_vma()
Date: Thu, 6 Oct 2022 23:03:45 -0400

Using vma_lookup() verifies the start address is contained in the found
vma.  This results in easier to read the code.

Link: https://lkml.kernel.org/r/20221007030345.5029-1-wangdeming@inspur.com
Signed-off-by: Deming Wang <wangdeming@inspur.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mincore.c~mm-use-vma_lookup-instead-of-find_vma
+++ a/mm/mincore.c
@@ -190,8 +190,8 @@ static long do_mincore(unsigned long add
 	unsigned long end;
 	int err;
 
-	vma = find_vma(current->mm, addr);
-	if (!vma || addr < vma->vm_start)
+	vma = vma_lookup(current->mm, addr);
+	if (!vma)
 		return -ENOMEM;
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 	if (!can_do_mincore(vma)) {
_

Patches currently in -mm which might be from wangdeming@inspur.com are

zsmalloc-replace-is_err-with-is_err_value.patch

