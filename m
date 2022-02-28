Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627BCC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 18:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbiB1Sup (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 13:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiB1Suo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 13:50:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01764BFC2
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 10:50:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5569CB81626
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 18:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7D1C340F1;
        Mon, 28 Feb 2022 18:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646074203;
        bh=6AjRqMHMnAwKheQIonsuQwREPJE5olu0oSBX25bMDEM=;
        h=Date:To:From:Subject:From;
        b=y+Klc3ra8eTM+wEF06lYy3ixBJg53TEx6vwKlSm0Bac7YVp8iGLRZy+2/elLWCkUB
         lBIXwCkcz3b0o4cEqddu2RF4haeqdrLS0snHLG3JRhyAsXl2iWlZL6pD2u5NDdvEs5
         udo9NbGZEqV5LG04ISMxnvG7PduPhI9kgv9uEjlg=
Date:   Mon, 28 Feb 2022 10:50:02 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        pmladek@suse.com, feng.tang@intel.com, bhe@redhat.com,
        gpiccoli@igalia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-move-panic_print-before-kmsg-dumpers.patch added to -mm tree
Message-Id: <20220228185002.EF7D1C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: move panic_print before kmsg dumpers
has been added to the -mm tree.  Its filename is
     panic-move-panic_print-before-kmsg-dumpers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/panic-move-panic_print-before-kmsg-dumpers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/panic-move-panic_print-before-kmsg-dumpers.patch

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
Subject: panic: move panic_print before kmsg dumpers

The panic_print setting allows users to collect more information in a
panic event, like memory stats, tasks, CPUs backtraces, etc.
This is an interesting debug mechanism, but currently the print event
happens *after* kmsg_dump(), meaning that pstore, for example, cannot
collect a dmesg with the panic_print extra information.

This patch changes that in 2 steps:

(a) The panic_print setting allows to replay the existing kernel log
    buffer to the console (bit 5), besides the extra information dump. 
    This functionality makes sense only at the end of the panic()
    function.  So, we hereby allow to distinguish the two situations by a
    new boolean parameter in the function panic_print_sys_info().

(b) With the above change, we can safely call panic_print_sys_info()
    before kmsg_dump(), allowing to dump the extra information when using
    pstore or other kmsg dumpers.

The additional messages from panic_print could overwrite the oldest
messages when the buffer is full.  The only reasonable solution is to use
a large enough log buffer, hence we added an advice into the kernel
parameters documentation about that.

Link: https://lkml.kernel.org/r/20220214141308.841525-1-gpiccoli@igalia.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Acked-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    4 ++++
 kernel/panic.c                                  |   13 +++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~panic-move-panic_print-before-kmsg-dumpers
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3727,6 +3727,10 @@
 			bit 4: print ftrace buffer
 			bit 5: print all printk messages in buffer
 			bit 6: print all CPUs backtrace (if available in the arch)
+			*Be aware* that this option may print a _lot_ of lines,
+			so there are risks of losing older messages in the log.
+			Use this option carefully, maybe worth to setup a
+			bigger log buffer with "log_buf_len" along with this.
 
 	panic_on_taint=	Bitmask for conditionally calling panic() in add_taint()
 			Format: <hex>[,nousertaint]
--- a/kernel/panic.c~panic-move-panic_print-before-kmsg-dumpers
+++ a/kernel/panic.c
@@ -148,10 +148,13 @@ void nmi_panic(struct pt_regs *regs, con
 }
 EXPORT_SYMBOL(nmi_panic);
 
-static void panic_print_sys_info(void)
+static void panic_print_sys_info(bool console_flush)
 {
-	if (panic_print & PANIC_PRINT_ALL_PRINTK_MSG)
-		console_flush_on_panic(CONSOLE_REPLAY_ALL);
+	if (console_flush) {
+		if (panic_print & PANIC_PRINT_ALL_PRINTK_MSG)
+			console_flush_on_panic(CONSOLE_REPLAY_ALL);
+		return;
+	}
 
 	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
 		trigger_all_cpu_backtrace();
@@ -286,6 +289,8 @@ void panic(const char *fmt, ...)
 	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
+	panic_print_sys_info(false);
+
 	kmsg_dump(KMSG_DUMP_PANIC);
 
 	/*
@@ -316,7 +321,7 @@ void panic(const char *fmt, ...)
 	debug_locks_off();
 	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
 
-	panic_print_sys_info();
+	panic_print_sys_info(true);
 
 	if (!panic_blink)
 		panic_blink = no_blink;
_

Patches currently in -mm which might be from gpiccoli@igalia.com are

docs-sysctl-kernel-add-missing-bit-to-panic_print.patch
panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch
panic-move-panic_print-before-kmsg-dumpers.patch

