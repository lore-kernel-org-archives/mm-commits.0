Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73077FA3747
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJ1VIK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiJ1VHd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB15424A549
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BA762A57
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8524C433D6;
        Fri, 28 Oct 2022 21:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991251;
        bh=6ylVWnITHMChyUMKl7y7Ky+4dt5ep8uWTYRiWgkwQR0=;
        h=Date:To:From:Subject:From;
        b=KR8YFjj46CDITfMrpLEU9gIu1miLNzdmVWRCDzRFzINzqMzJFuSJPqFQS+Sg29P8L
         +/17s0z6Xj8Bba1nIlPR++rXfhC+XrsRrO9dws9J5SK7fYfVoW45TFDLlaI1m+CjAI
         w1PfsHSa3mP9DVTyIHTgTQov+dreWx97NuUYFK+0=
Date:   Fri, 28 Oct 2022 14:07:30 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        hooanon05g@gmail.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmap-fix-remap_file_pages-regression.patch removed from -mm tree
Message-Id: <20221028210731.B8524C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmap: fix remap_file_pages() regression
has been removed from the -mm tree.  Its filename was
     mmap-fix-remap_file_pages-regression.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mmap: fix remap_file_pages() regression
Date: Tue, 25 Oct 2022 16:12:49 +0000

When using the VMA iterator, the final execution will set the variable
'next' to NULL which causes the function to fail out.  Restore the break
in the loop to exit the VMA iterator early without clearing NULL fixes the
issue.

Link: https://lore.kernel.org/lkml/29344.1666681759@jrobl/
Link: https://lkml.kernel.org/r/20221025161222.2634030-1-Liam.Howlett@oracle.com
Fixes: 763ecb035029 (mm: remove the vma linked list)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: "J. R. Okajima" <hooanon05g@gmail.com>
Tested-by: "J. R. Okajima" <hooanon05g@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mmap-fix-remap_file_pages-regression
+++ a/mm/mmap.c
@@ -2852,6 +2852,9 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 			if (next->vm_flags != vma->vm_flags)
 				goto out;
 
+			if (start + size <= next->vm_end)
+				break;
+
 			prev = next;
 		}
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch
maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch
maple_tree-reorganize-testing-to-restore-module-testing.patch
maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch
maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

