Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA16C25B0E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 05:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343577AbiHSFSt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 01:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238595AbiHSFSs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 01:18:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E2EBC12D
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 22:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 196A6615A1
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 05:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6944EC433D6;
        Fri, 19 Aug 2022 05:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660886313;
        bh=cvb5o3QSzBFdMgBl2BYoi9dLuLqAWRpkfweZK1Lvro0=;
        h=Date:To:From:Subject:From;
        b=fl1CdH4+JpR5F3Bx77fzfapI06biwwNVhXjH6Wv2NI6Pp8a8EHd1mJDjvUvrVBVoZ
         gRI5p6jdP2KltVJfTem+cR14Ioo8U4QJ6qNT4QfaAz1G7tmg7HBPcP+6WLyVJFmKkp
         6VkzN63/HQPmZTbxnZflsuZ70X2d0/xg+gdVJFCQ=
Date:   Thu, 18 Aug 2022 22:18:32 -0700
To:     mm-commits@vger.kernel.org, josh@joshtriplett.org,
        adobriyan@gmail.com, deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arc-use-generic-dump_stack_print_cmdline-implementation.patch added to mm-nonmm-unstable branch
Message-Id: <20220819051833.6944EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arc: use generic dump_stack_print_cmdline() implementation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arc-use-generic-dump_stack_print_cmdline-implementation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arc-use-generic-dump_stack_print_cmdline-implementation.patch

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

proc-add-get_task_cmdline_kernel-function.patch
lib-dump_stack-add-dump_stack_print_cmdline-and-wire-up-in-dump_stack_print_info.patch
x86-fault-dump-command-line-of-faulting-process-to-syslog.patch
arc-use-generic-dump_stack_print_cmdline-implementation.patch

