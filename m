Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A184DC4707F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387635AbiBHWZ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386460AbiBHUgH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 15:36:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48327C0613CB
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 12:36:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1319FB81D09
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 20:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9547C004E1;
        Tue,  8 Feb 2022 20:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644352563;
        bh=ZkukbrgUvEr7dUZd6Rs0VslebL2m3fkxWAoJWvakszI=;
        h=Date:To:From:Subject:From;
        b=QbnbseMqcXQuyvuMB4s8VVPHnIkjPJZ8Wt3Quj4sVWS9GRrgV8Ev6OjuJVC+BZ7sZ
         8HmGnXAxiytHe/tlqV5r+/NB/OCf6oE39VFlDxPtcYQVXpmz23yk7mN+is97qE+R9Q
         jwvWvU5Co0S42Sc1qn3d8vrEmaNaU4QhIQEX3y+M=
Date:   Tue, 08 Feb 2022 12:36:03 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        lixuefeng@loongson.cn, elver@google.com, corbet@lwn.net,
        bhe@redhat.com, yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-unset-panic_on_warn-inside-panic.patch added to -mm tree
Message-Id: <20220208203603.C9547C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: unset panic_on_warn inside panic()
has been added to the -mm tree.  Its filename is
     panic-unset-panic_on_warn-inside-panic.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/panic-unset-panic_on_warn-inside-panic.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/panic-unset-panic_on_warn-inside-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: panic: unset panic_on_warn inside panic()

In the current code, the following three places need to unset
panic_on_warn before calling panic() to avoid recursive panics:

kernel/kcsan/report.c: print_report()
kernel/sched/core.c: __schedule_bug()
mm/kfence/report.c: kfence_report_error()

In order to avoid copy-pasting "panic_on_warn = 0" all over the places, it
is better to move it inside panic() and then remove it from the other
places.

Link: https://lkml.kernel.org/r/1644324666-15947-4-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/kernel/panic.c~panic-unset-panic_on_warn-inside-panic
+++ a/kernel/panic.c
@@ -185,6 +185,16 @@ void panic(const char *fmt, ...)
 	int old_cpu, this_cpu;
 	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
+	}
+
 	/*
 	 * Disable local interrupts. This will prevent panic_smp_self_stop
 	 * from deadlocking the first cpu that invokes the panic, since
@@ -576,16 +586,8 @@ void __warn(const char *file, int line,
 	if (regs)
 		show_regs(regs);
 
-	if (panic_on_warn) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn)
 		panic("panic_on_warn set ...\n");
-	}
 
 	if (!regs)
 		dump_stack();
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

docs-kdump-update-description-about-sysfs-file-system-support.patch
docs-kdump-add-scp-example-to-write-out-the-dump-file.patch
panic-unset-panic_on_warn-inside-panic.patch
ubsan-no-need-to-unset-panic_on_warn-in-ubsan_epilogue.patch
kasan-no-need-to-unset-panic_on_warn-in-end_report.patch

