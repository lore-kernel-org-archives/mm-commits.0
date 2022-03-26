Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9361C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 00:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiCZAVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 20:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiCZAVs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 20:21:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B02B35
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 17:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75B4E61842
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 00:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD52FC2BBE4;
        Sat, 26 Mar 2022 00:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648254011;
        bh=I+MbXF3VB7zmrqZVM4BJMZQyxw/XDqNOrxCjh1ixJuw=;
        h=Date:To:From:Subject:From;
        b=X2PommGstnAV3zGl96rtLKTx84vYvzX8MUuZSMt4CWv9n+JNhm0adb2IUuMfypYre
         qA0VBI13640UM0Dop0cR0GYHqXS9qJvgU5MNEEuNQPxMmWl6o+yqKKWjxsnVE8icMx
         /tg4lb1RtFNDUdlIfMkxtbNkZJi61zjjjVD74030=
Date:   Fri, 25 Mar 2022 17:20:10 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-use-helper-mlock_future_check.patch added to -mm tree
Message-Id: <20220326002011.BD52FC2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: use helper mlock_future_check()
has been added to the -mm tree.  Its filename is
     mm-mremap-use-helper-mlock_future_check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-use-helper-mlock_future_check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-use-helper-mlock_future_check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mremap: use helper mlock_future_check()

Use helper mlock_future_check() to check whether it's safe to resize the
locked_vm to simplify the code.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220322112004.27380-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-helper-mlock_future_check
+++ a/mm/mremap.c
@@ -763,14 +763,8 @@ static struct vm_area_struct *vma_to_res
 	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
 		return ERR_PTR(-EFAULT);
 
-	if (vma->vm_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = mm->locked_vm << PAGE_SHIFT;
-		lock_limit = rlimit(RLIMIT_MEMLOCK);
-		locked += new_len - old_len;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return ERR_PTR(-EAGAIN);
-	}
+	if (mlock_future_check(mm, vma->vm_flags, new_len - old_len))
+		return ERR_PTR(-EAGAIN);
 
 	if (!may_expand_vm(mm, vma->vm_flags,
 				(new_len - old_len) >> PAGE_SHIFT))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mremap-use-helper-mlock_future_check.patch

