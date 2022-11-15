Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C32C43217
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238434AbiKOWck (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiKOWcT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB672BFD
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CAEA61A4D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CA4C433D7;
        Tue, 15 Nov 2022 22:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551537;
        bh=5H1va/Q2CDLcNhbMV1188KWIthCwjYlebDY02pReYok=;
        h=Date:To:From:Subject:From;
        b=eMefNHeNwcNbO21Pe60CSSOJxGvf5owFcgClG6RrqJpCbhMD8LW4HdC6oJn06HesV
         094DFfetQg+XPMluuJfPN/V7icCqDRXsxizGY+6rHU4C5B/8TjKWvSpxyR3s3YwL4r
         Ilgx11V8ICd+qu4DM1op0UR8tvSrAr6EU6haAEJc=
Date:   Tue, 15 Nov 2022 14:32:17 -0800
To:     mm-commits@vger.kernel.org, slyich@gmail.com,
        ye.xingchen@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-replace-is_err-with-is_err_value.patch removed from -mm tree
Message-Id: <20221115223217.73CA4C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: replace IS_ERR() with IS_ERR_VALUE()
has been removed from the -mm tree.  Its filename was
     ia64-replace-is_err-with-is_err_value.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


