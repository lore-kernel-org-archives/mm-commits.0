Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91CFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 18:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhLNS3I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Dec 2021 13:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbhLNS3I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Dec 2021 13:29:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442C4C061574
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 10:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D793061692
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 18:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082ADC34600;
        Tue, 14 Dec 2021 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639506547;
        bh=+hd+vA8TcaOiZymFtsrqnY7K9Nq2TfH5GM69Ee4yn4Q=;
        h=Date:From:To:Subject:From;
        b=pf6wfpigMSnjyaCjS4H4SQauM6j19o4AnLUTvxMHj8kruro8jdb8aBFOSNMslJYIH
         qoaBUIiWF9LQVVVS/vFCEo2m0qEK2zk0jnu/lf0zdOuGNkYoJQTCTR1KQAD6ihLIAH
         9/HyRJpoSGWOKC2+4YyK8CmQx2Kab/j2Fpb2x7/s=
Date:   Tue, 14 Dec 2021 10:29:06 -0800
From:   akpm@linux-foundation.org
To:     feng.tang@intel.com, gpiccoli@igalia.com, keescook@chromium.org,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        siglesias@igalia.com, yzaikin@google.com
Subject:  +
 panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch added to
 -mm tree
Message-ID: <20211214182906.zC5KArbyV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: add option to dump all CPUs backtraces in panic_print
has been added to the -mm tree.  Its filename is
     panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: panic: add option to dump all CPUs backtraces in panic_print

Currently the "panic_print" parameter/sysctl allows some interesting debug
information to be printed during a panic event.  This is useful for
example in cases the user cannot kdump due to resource limits, or if the
user collects panic logs in a serial output (or pstore) and prefers a fast
reboot instead of a kdump.

Happens that currently there's no way to see all CPUs backtraces in a
panic using "panic_print" on architectures that support that.  We do have
"oops_all_cpu_backtrace" sysctl, but although partially overlapping in the
functionality, they are orthogonal in nature: "panic_print" is a panic
tuning (and we have panics without oopses, like direct calls to panic() or
maybe other paths that don't go through oops_enter() function), and the
original purpose of "oops_all_cpu_backtrace" is to provide more
information on oopses for cases in which the users desire to continue
running the kernel even after an oops, i.e., used in non-panic scenarios.

So, we hereby introduce an additional bit for "panic_print" to allow
dumping the CPUs backtraces during a panic event.

Link: https://lkml.kernel.org/r/20211109202848.610874-3-gpiccoli@igalia.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    1 +
 Documentation/admin-guide/sysctl/kernel.rst     |    1 +
 kernel/panic.c                                  |    4 ++++
 3 files changed, 6 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~panic-add-option-to-dump-all-cpus-backtraces-in-panic_print
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3704,6 +3704,7 @@
 			bit 3: print locks info if CONFIG_LOCKDEP is on
 			bit 4: print ftrace buffer
 			bit 5: print all printk messages in buffer
+			bit 6: print all CPUs backtrace (if available in the arch)
 
 	panic_on_taint=	Bitmask for conditionally calling panic() in add_taint()
 			Format: <hex>[,nousertaint]
--- a/Documentation/admin-guide/sysctl/kernel.rst~panic-add-option-to-dump-all-cpus-backtraces-in-panic_print
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -796,6 +796,7 @@ bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
 bit 5: print all printk messages in buffer
+bit 6: print all CPUs backtrace (if available in the arch)
 =====  ============================================
 
 So for example to print tasks and memory info on panic, user can::
--- a/kernel/panic.c~panic-add-option-to-dump-all-cpus-backtraces-in-panic_print
+++ a/kernel/panic.c
@@ -66,6 +66,7 @@ EXPORT_SYMBOL_GPL(panic_timeout);
 #define PANIC_PRINT_LOCK_INFO		0x00000008
 #define PANIC_PRINT_FTRACE_INFO		0x00000010
 #define PANIC_PRINT_ALL_PRINTK_MSG	0x00000020
+#define PANIC_PRINT_ALL_CPU_BT		0x00000040
 unsigned long panic_print;
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
@@ -152,6 +153,9 @@ static void panic_print_sys_info(void)
 	if (panic_print & PANIC_PRINT_ALL_PRINTK_MSG)
 		console_flush_on_panic(CONSOLE_REPLAY_ALL);
 
+	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
+		trigger_all_cpu_backtrace();
+
 	if (panic_print & PANIC_PRINT_TASK_INFO)
 		show_state();
 
_

Patches currently in -mm which might be from gpiccoli@igalia.com are

docs-sysctl-kernel-add-missing-bit-to-panic_print.patch
panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch
panic-allow-printing-extra-panic-information-on-kdump.patch

