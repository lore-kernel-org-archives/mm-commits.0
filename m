Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A66C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350491AbiCYBhM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357531AbiCYBf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209D23B573
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B084260A75
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BFEC340EC;
        Fri, 25 Mar 2022 01:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172056;
        bh=cJ4+Eh/hPzpmzvMDfz3MMRiBW9EhElmtbJObyF4zMmE=;
        h=Date:To:From:Subject:From;
        b=m2VASoL6i+BCbtYZAK0IP1E7OYb836y5EWPhv72lv7Xcijwmp6Z4x1uE0BtpZyneV
         Q3wS4MAEbVDUL+lFdoAwOaf6lfK0oa/wsGn6kL9f9sF9zcA80WVs4FtdgaV0w2Euxf
         6oFJa4eZCVzdEjJ6xNVRKXywB5Pu/KiYv59tlHPE=
Date:   Thu, 24 Mar 2022 18:34:15 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        siglesias@igalia.com, mcgrof@kernel.org, keescook@chromium.org,
        feng.tang@intel.com, gpiccoli@igalia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch removed from -mm tree
Message-Id: <20220325013416.14BFEC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: add option to dump all CPUs backtraces in panic_print
has been removed from the -mm tree.  Its filename was
     panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3726,6 +3726,7 @@
 			bit 3: print locks info if CONFIG_LOCKDEP is on
 			bit 4: print ftrace buffer
 			bit 5: print all printk messages in buffer
+			bit 6: print all CPUs backtrace (if available in the arch)
 
 	panic_on_taint=	Bitmask for conditionally calling panic() in add_taint()
 			Format: <hex>[,nousertaint]
--- a/Documentation/admin-guide/sysctl/kernel.rst~panic-add-option-to-dump-all-cpus-backtraces-in-panic_print
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -807,6 +807,7 @@ bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
 bit 5  print all printk messages in buffer
+bit 6  print all CPUs backtrace (if available in the arch)
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


