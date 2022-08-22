Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8B2C32793
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 21:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbiHVVCQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 17:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237724AbiHVVCL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 17:02:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E14A5005D
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 14:02:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFDB0B81910
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 21:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547C9C433B5;
        Mon, 22 Aug 2022 21:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661202128;
        bh=K89Z9IIJUsEad2hvq2TBjRM/Frab5ya+TjvnzHUOD44=;
        h=Date:To:From:Subject:From;
        b=J36aECYE6sl6Ohee/dSzC0cfSxYpzBpaCuXI8peTidTkv+sWXMAFA1wCY9P2xckl6
         ebfqQ9FHNV5bU6E4mft4b8k0tovKQoWEVNPOtVFeNFOYeym7A872P6h9FuxgL+10/5
         5QA8gEJ5+bSh1Lzu+gQjfoYjsl4sPzuX36RIzOHM=
Date:   Mon, 22 Aug 2022 14:02:07 -0700
To:     mm-commits@vger.kernel.org, josh@joshtriplett.org,
        adobriyan@gmail.com, deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] x86-fault-dump-command-line-of-faulting-process-to-syslog.patch removed from -mm tree
Message-Id: <20220822210208.547C9C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/fault: dump command line of faulting process to syslog
has been removed from the -mm tree.  Its filename was
     x86-fault-dump-command-line-of-faulting-process-to-syslog.patch

This patch was dropped because it had testing failures

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

arc-use-generic-dump_stack_print_cmdline-implementation.patch

