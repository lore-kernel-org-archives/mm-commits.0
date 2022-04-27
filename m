Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C92BC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 17:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbiD0Rv7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 13:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbiD0Rv7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 13:51:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA3F3B292
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 10:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0886161E9A
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 17:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557F5C385AC;
        Wed, 27 Apr 2022 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651081725;
        bh=AWWpstmJTAG2a3b6vbr8pWM35IePDTuJ4qhprctE/zk=;
        h=Date:To:From:Subject:From;
        b=QWLYp5L7LCY3ccOlQl0cYy4nu4785VYeb28ZhMxOW5cZoUPQAMQNSd909UHGpCGgU
         hIby2jwzUbRk5FOF5DoX6AC1HzgBqHm/KKo2CDJUGnvlvjdIahnVZ/vKwYq7/9whXE
         cgfZrBIEtmdGfiiQkOlpT1CFM2ty1EdmabQB8W/g=
Date:   Wed, 27 Apr 2022 10:48:44 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        quic_qiancai@quicinc.com, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-use-vma-iterator-and-instead-of-vma-linked-list-fix.patch added to -mm tree
Message-Id: <20220427174845.557F5C385AC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: use maple state in apply_mlockall_flags()
has been added to the -mm tree.  Its filename is
     mm-mlock-use-vma-iterator-and-instead-of-vma-linked-list-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-use-vma-iterator-and-instead-of-vma-linked-list-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-use-vma-iterator-and-instead-of-vma-linked-list-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mlock: use maple state in apply_mlockall_flags()

The vma iterator is for simple cases.  Since mlock_fixup() can cause the
tree to change and thus requires the maple state to be reset,
apply_mlockall_flags() is not a simple case.  Use a maple state and call
mas_pause() instead.

Link: https://lkml.kernel.org/r/20220427165139.5s3qcj2u5vqrvwlc@revolver
Fixes: 0d43186b36c1 (mm/mlock: use vma iterator and instead of vma linked list)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mlock.c~mm-mlock-use-vma-iterator-and-instead-of-vma-linked-list-fix
+++ a/mm/mlock.c
@@ -660,7 +660,7 @@ SYSCALL_DEFINE2(munlock, unsigned long,
  */
 static int apply_mlockall_flags(int flags)
 {
-	VMA_ITERATOR(vmi, current->mm, 0);
+	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
 	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
@@ -681,7 +681,7 @@ static int apply_mlockall_flags(int flag
 			to_add |= VM_LOCKONFAULT;
 	}
 
-	for_each_vma(vmi, vma) {
+	mas_for_each(&mas, vma, ULONG_MAX) {
 		vm_flags_t newflags;
 
 		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
@@ -689,6 +689,7 @@ static int apply_mlockall_flags(int flag
 
 		/* Ignore errors */
 		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
+		mas_pause(&mas);
 		cond_resched();
 	}
 out:
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch
mm-mlock-use-vma-iterator-and-instead-of-vma-linked-list-fix.patch

