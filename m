Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FABEE49A4
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 21:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjIJV1P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 17:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjIJV1O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 17:27:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804B8B9
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 14:27:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B0EC433C8;
        Sun, 10 Sep 2023 21:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694381230;
        bh=ZutGIpLdUly47Nvc8nUcpOhoUDM3oUVbYVS6SIgSVCY=;
        h=Date:To:From:Subject:From;
        b=GDfsO0pt6VF1lv0Refsx0igBGaATx6NOY1fyV0VCHPmumOdPW1XqzZ3/Jf0mqtRRr
         U7fj0jZ3K4/siApZZwaUqBaMKjugeC6kTtk9xWLK1SDtj6JJIUUtVoh2sI21RYuvE4
         NXx6jQGypwAI3gvHMgendcNT3EVRL7VQB590V1Hc=
Date:   Sun, 10 Sep 2023 14:27:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-duplicated-vma-vm_flags-check-when-expanding-stack.patch added to mm-unstable branch
Message-Id: <20230910212710.13B0EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove duplicated vma->vm_flags check when expanding stack
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-duplicated-vma-vm_flags-check-when-expanding-stack.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-duplicated-vma-vm_flags-check-when-expanding-stack.patch

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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm: remove duplicated vma->vm_flags check when expanding stack
Date: Wed, 6 Sep 2023 10:33:12 +0000

expand_upwards() and expand_downwards() will return -EFAULT if VM_GROWSUP
or VM_GROWSDOWN is not correctly set in vma->vm_flags, however in
!CONFIG_STACK_GROWSUP case, expand_stack_locked() returns -EINVAL first if
!(vma->vm_flags & VM_GROWSDOWN) before calling expand_downwards(), to keep
the consistency with CONFIG_STACK_GROWSUP case, remove this check.

Link: https://lkml.kernel.org/r/20230906103312.645712-1-xiujianfeng@huaweicloud.com
Fixes: f440fa1ac955 ("mm: make find_extend_vma() fail if write lock not held")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mmap.c~mm-remove-duplicated-vma-vm_flags-check-when-expanding-stack
+++ a/mm/mmap.c
@@ -2159,8 +2159,6 @@ struct vm_area_struct *find_extend_vma_l
 #else
 int expand_stack_locked(struct vm_area_struct *vma, unsigned long address)
 {
-	if (unlikely(!(vma->vm_flags & VM_GROWSDOWN)))
-		return -EINVAL;
 	return expand_downwards(vma, address);
 }
 
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-remove-duplicated-vma-vm_flags-check-when-expanding-stack.patch

