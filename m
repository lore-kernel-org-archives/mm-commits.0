Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C30FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 01:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiJUBWy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 21:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJUBWw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 21:22:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC966224AB2
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 18:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 872A061D84
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 01:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1789C433D6;
        Fri, 21 Oct 2022 01:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666315371;
        bh=bXQN77wM3ily2oSIHPMgspPMvVBP0KY4FWYouXAevAg=;
        h=Date:To:From:Subject:From;
        b=Mrg2bWzjVsVKbDD6CvQVw5JgQ08zgMBaQSvC1lFfxZPn3bUCNOKDZt81p04XhYRwT
         PATt+FCtbJMI85eplAXaTJGLybULoWaUopFDETscygVWhA6929yzXgFYuIQBYcAHTe
         lcez/xIIRRRJeeWLAphztKyu2bPmrgfkcw07gdvQ=
Date:   Thu, 20 Oct 2022 18:22:50 -0700
To:     mm-commits@vger.kernel.org, slyich@gmail.com,
        ye.xingchen@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ia64-replace-is_err-with-is_err_value.patch added to mm-nonmm-unstable branch
Message-Id: <20221021012250.E1789C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: replace IS_ERR() with IS_ERR_VALUE()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ia64-replace-is_err-with-is_err_value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ia64-replace-is_err-with-is_err_value.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: ye xingchen <ye.xingchen@zte.com.cn>
Subject: ia64: replace IS_ERR() with IS_ERR_VALUE()
Date: Thu, 20 Oct 2022 11:30:04 +0000

Avoid typecasts that are needed for IS_ERR() and use IS_ERR_VALUE()
instead.

Link: https://lkml.kernel.org/r/20221020113004.400031-1-ye.xingchen@zte.com.cn
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/sys_ia64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/ia64/kernel/sys_ia64.c~ia64-replace-is_err-with-is_err_value
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -140,7 +140,7 @@ asmlinkage unsigned long
 sys_mmap2 (unsigned long addr, unsigned long len, int prot, int flags, int fd, long pgoff)
 {
 	addr = ksys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
-	if (!IS_ERR((void *) addr))
+	if (!IS_ERR_VALUE(addr))
 		force_successful_syscall_return();
 	return addr;
 }
@@ -152,7 +152,7 @@ sys_mmap (unsigned long addr, unsigned l
 		return -EINVAL;
 
 	addr = ksys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
-	if (!IS_ERR((void *) addr))
+	if (!IS_ERR_VALUE(addr))
 		force_successful_syscall_return();
 	return addr;
 }
@@ -162,7 +162,7 @@ ia64_mremap (unsigned long addr, unsigne
 	     unsigned long new_addr)
 {
 	addr = sys_mremap(addr, old_len, new_len, flags, new_addr);
-	if (!IS_ERR((void *) addr))
+	if (!IS_ERR_VALUE(addr))
 		force_successful_syscall_return();
 	return addr;
 }
_

Patches currently in -mm which might be from ye.xingchen@zte.com.cn are

kexec-remove-the-unneeded-result-variable.patch
ia64-replace-is_err-with-is_err_value.patch

