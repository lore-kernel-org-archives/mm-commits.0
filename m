Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170B1C25B0E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 05:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343947AbiHSFS7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 01:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238595AbiHSFS6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 01:18:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18635C3F6F
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 22:18:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F22AB82569
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 05:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19461C433D6;
        Fri, 19 Aug 2022 05:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660886334;
        bh=eWcyVsy+S3kHH/N9ktk2DRt6fWIeFRYJUsXE/1LH61A=;
        h=Date:To:From:Subject:From;
        b=Lf1pJBkEql3dlhkhccS1DcfQsBWS886coP0ybXvTN6dtTFEgA5h9HfZVOFRGwwgNO
         v9ARxwKpaU3FgVqsHausYJP9/cDyDwDdJC2gZhgFy7YoGkkI3Ej4gXD/qWJnHd0v+H
         nLNPB9+XxsvAcFK80FYFDfJcAmMPfaO48U2E+56c=
Date:   Thu, 18 Aug 2022 22:18:53 -0700
To:     mm-commits@vger.kernel.org, josh@joshtriplett.org,
        adobriyan@gmail.com, deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-fault-dump-command-line-of-faulting-process-to-syslog.patch added to mm-nonmm-unstable branch
Message-Id: <20220819051854.19461C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/fault: dump command line of faulting process to syslog
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-fault-dump-command-line-of-faulting-process-to-syslog.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-fault-dump-command-line-of-faulting-process-to-syslog.patch

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
Subject: x86/fault: dump command line of faulting process to syslog
Date: Mon, 8 Aug 2022 15:09:16 +0200

If a process segfaults, include the command line of the faulting process
in the syslog.

In the example below, the "crash" program (which simply writes zero to
address 0) was called with the parameters "this is a test":

 crash[2326]: segfault at 0 ip 0000561a7969c12e sp 00007ffe97a05630 error = 6 in crash[561a7969c000+1000]
 crash[2326] cmdline: ./crash this is a test
 Code: 68 ff ff ff c6 05 19 2f 00 00 01 5d c3 0f 1f 80 00 00 00 00 c3 0f 1f ...

Link: https://lkml.kernel.org/r/20220808130917.30760-4-deller@gmx.de
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/mm/fault.c~x86-fault-dump-command-line-of-faulting-process-to-syslog
+++ a/arch/x86/mm/fault.c
@@ -784,6 +784,8 @@ show_signal_msg(struct pt_regs *regs, un
 
 	printk(KERN_CONT "\n");
 
+	dump_stack_print_cmdline(loglvl);
+
 	show_opcodes(regs, loglvl);
 }
 
_

Patches currently in -mm which might be from deller@gmx.de are

proc-add-get_task_cmdline_kernel-function.patch
lib-dump_stack-add-dump_stack_print_cmdline-and-wire-up-in-dump_stack_print_info.patch
x86-fault-dump-command-line-of-faulting-process-to-syslog.patch
arc-use-generic-dump_stack_print_cmdline-implementation.patch

