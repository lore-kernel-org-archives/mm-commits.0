Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A58E7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243904AbjJDUSk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244057AbjJDUSi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B19C9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483ACC433C9;
        Wed,  4 Oct 2023 20:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450715;
        bh=acbQgmCvyqhqS++n8J6yviIwzZ/pqJ7UA+fZcJfBiQM=;
        h=Date:To:From:Subject:From;
        b=ZL44fQreAxoY23OEUmYKDyAoPnJMHLvB4H0YKWHkO0VgWkX+lYtDIsKy4z1UIDLLB
         sicPom8DwcFeqTkKVa6ta7U0tiw1WCW6+1+IuaMoxjy2sf9N4UceECq+qOsqEJAtD6
         X0pGvitW/7ywlDl/dD+PLsLlZRydvNQ/Vnq9S2ns=
Date:   Wed, 04 Oct 2023 13:18:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-duplicated-vma-vm_flags-check-when-expanding-stack.patch removed from -mm tree
Message-Id: <20231004201835.483ACC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove duplicated vma->vm_flags check when expanding stack
has been removed from the -mm tree.  Its filename was
     mm-remove-duplicated-vma-vm_flags-check-when-expanding-stack.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm: remove duplicated vma->vm_flags check when expanding stack
Date: Wed, 6 Sep 2023 10:33:12 +0000

expand_upwards() and expand_downwards() will return -EFAULT if VM_GROWSUP
or VM_GROWSDOWN is not correctly set in vma->vm_flags, however in
!CONFIG_STACK_GROWSUP case, expand_stack_locked() returns -EINVAL first if
!(vma->vm_flags & VM_GROWSDOWN) before calling expand_downwards(), to keep
the consistency with CONFIG_STACK_GROWSUP case, remove this check.

The usages of this function are as below:

A:fs/exec.c
ret = expand_stack_locked(vma, stack_base);
if (ret)
	ret = -EFAULT;

or

B:mm/memory.c mm/mmap.c
if (expand_stack_locked(vma, addr))
	return NULL;

which means the return value will not propagate to other places, so I
believe there is no user-visible effects of this change, and it's
unnecessary to backport to earlier versions.

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


