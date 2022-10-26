Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A2EC38A02
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 02:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiJZCUv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 22:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiJZCUt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 22:20:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B89356ED
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 19:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1097F61C39
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 02:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569C2C433D7;
        Wed, 26 Oct 2022 02:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666750847;
        bh=YgsCIvEG+iQoL1jVnzpgwjD/NmBo8gJ8XTbi4Q/XUxY=;
        h=Date:To:From:Subject:From;
        b=h7blG84ABMGy2UKjqnEJOhMuLRNdpd0BiVVrIASqRSja/uXCWLGSXDxAUk+Ah05dM
         japEExzRcaZL7mkkVOMzPI24yxOeIBYHxpPdjhCCEcF3xqmD9eopb/BFidmj1zfwRm
         uMjveKWxp62VR+Bh1rJsM4BwX3z7ncebTO/6NlW0=
Date:   Tue, 25 Oct 2022 19:20:46 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        hooanon05g@gmail.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-fix-remap_file_pages-regression.patch added to mm-hotfixes-unstable branch
Message-Id: <20221026022047.569C2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: fix remap_file_pages() regression
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmap-fix-remap_file_pages-regression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-fix-remap_file_pages-regression.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mmap-fix-remap_file_pages-regression.patch
maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch

