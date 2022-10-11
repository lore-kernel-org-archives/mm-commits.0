Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EF5C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 23:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiJKXyn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 19:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJKXyl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 19:54:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8CB6475
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 16:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9AC3B818AE
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 23:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79ED7C433D6;
        Tue, 11 Oct 2022 23:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665532477;
        bh=wbqNa3Og2iZVhACqYeUQlZU7BUTbZ/lG3LoIapVAKQw=;
        h=Date:To:From:Subject:From;
        b=BgcrC21qKEAFHSK7S6xQhA9sfMOoNmsUE07U0zbOKkfojY5iuoEXjRLf+npRzcgAM
         6bhJ1uTPrsXlTD9P/pfBJJ8ZsxgpFUZfpcDEML9aWWb0N9b+oG/5vAUeT4JmHLd333
         LH/fXMTuxSGa4nIfrHVjUXUHF2YXWMTTLED8u8tY=
Date:   Tue, 11 Oct 2022 16:54:36 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-fix-copy_vma-failure-path.patch added to mm-unstable branch
Message-Id: <20221011235437.79ED7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap: fix copy_vma() failure path
has been added to the -mm mm-unstable branch.  Its filename is
     mmap-fix-copy_vma-failure-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmap-fix-copy_vma-failure-path.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mmap: fix copy_vma() failure path
Date: Tue, 11 Oct 2022 20:36:51 +0000

The anon vma was not unlinked and the file was not closed in the failure
path when the machine runs out of memory during the maple tree
modification.  This caused a memory leak of the anon vma chain and vma
since neither would be freed.

Link: https://lkml.kernel.org/r/20221011203621.1446507-1-Liam.Howlett@oracle.com
Fixes: 524e00b36e8c (mm: remove rb tree.)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/mmap.c~mmap-fix-copy_vma-failure-path
+++ a/mm/mmap.c
@@ -3240,6 +3240,11 @@ struct vm_area_struct *copy_vma(struct v
 out_vma_link:
 	if (new_vma->vm_ops && new_vma->vm_ops->close)
 		new_vma->vm_ops->close(new_vma);
+
+	if (new_vma->vm_file)
+		fput(new_vma->vm_file);
+
+	unlink_anon_vmas(new_vma);
 out_free_mempol:
 	mpol_put(vma_policy(new_vma));
 out_free_vma:
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mmap-fix-copy_vma-failure-path.patch

