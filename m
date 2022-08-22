Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D1FC28D13
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 21:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbiHVVCP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbiHVVCL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 17:02:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F04F4F1BC
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 14:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B0F76068B
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 21:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A61C433D6;
        Mon, 22 Aug 2022 21:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661202129;
        bh=kZ11ezIrm6/kOgW06/UfCZQw4oy5Nualb7GgjYapfaI=;
        h=Date:To:From:Subject:From;
        b=Tt2sUV30GhAZVFNr6Ea+u2Mh44lTlXnzpszxSWiN7FUathpe5uFDCskTCsiKQgTCE
         yG8vesBK8Sp7mA0ItzWxFn6M7GCqXKwyYltBldZysAmEbZjSlr1vqxzoDYlpxgPeq2
         eHonnb12YY3lLa5OWaQa51el6jrv6b3Ry8Q4Rk80=
Date:   Mon, 22 Aug 2022 14:02:08 -0700
To:     mm-commits@vger.kernel.org, josh@joshtriplett.org,
        adobriyan@gmail.com, deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] arc-use-generic-dump_stack_print_cmdline-implementation.patch removed from -mm tree
Message-Id: <20220822210209.78A61C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arc: use generic dump_stack_print_cmdline() implementation
has been removed from the -mm tree.  Its filename was
     arc-use-generic-dump_stack_print_cmdline-implementation.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: arc: use generic dump_stack_print_cmdline() implementation
Date: Mon, 8 Aug 2022 15:09:17 +0200

The process program name and command line is now shown in generic code
in dump_stack_print_info(), so drop the arc-specific implementation.

Link: https://lkml.kernel.org/r/20220808130917.30760-5-deller@gmx.de
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/troubleshoot.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/arch/arc/kernel/troubleshoot.c~arc-use-generic-dump_stack_print_cmdline-implementation
+++ a/arch/arc/kernel/troubleshoot.c
@@ -51,29 +51,6 @@ static void print_regs_callee(struct cal
 		regs->r24, regs->r25);
 }
 
-static void print_task_path_n_nm(struct task_struct *tsk)
-{
-	char *path_nm = NULL;
-	struct mm_struct *mm;
-	struct file *exe_file;
-	char buf[ARC_PATH_MAX];
-
-	mm = get_task_mm(tsk);
-	if (!mm)
-		goto done;
-
-	exe_file = get_mm_exe_file(mm);
-	mmput(mm);
-
-	if (exe_file) {
-		path_nm = file_path(exe_file, buf, ARC_PATH_MAX-1);
-		fput(exe_file);
-	}
-
-done:
-	pr_info("Path: %s\n", !IS_ERR(path_nm) ? path_nm : "?");
-}
-
 static void show_faulting_vma(unsigned long address)
 {
 	struct vm_area_struct *vma;
@@ -176,7 +153,6 @@ void show_regs(struct pt_regs *regs)
 	 */
 	preempt_enable();
 
-	print_task_path_n_nm(tsk);
 	show_regs_print_info(KERN_INFO);
 
 	show_ecr_verbose(regs);
_

Patches currently in -mm which might be from deller@gmx.de are


