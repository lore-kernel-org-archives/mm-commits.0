Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51D6C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354482AbiCYBh3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357523AbiCYBf6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C0E3A5FE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A295B82730
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED275C340ED;
        Fri, 25 Mar 2022 01:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172051;
        bh=0bpMZWnIgE+X9jktlKFiKSNrFv+5IG5pnOnEAT4N6I8=;
        h=Date:To:From:Subject:From;
        b=SY6XyQu7/DkYhn2WGJnR8ZgP5pc4pLEfIkJWKv10hWlq1ZBDKsy22sOzBt2uTvNGN
         xiBF5iOGwfaAJRUcC2W+rpCq349W+B507NNpUQNMrYAGvf7UVdmZdWW0QLyvRDRfq0
         izB7pV3qy+UEOtJXIrDxwq5WtXLlADvMGdSWo61o=
Date:   Thu, 24 Mar 2022 18:34:10 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        lixuefeng@loongson.cn, elver@google.com, corbet@lwn.net,
        bhe@redhat.com, yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] panic-unset-panic_on_warn-inside-panic.patch removed from -mm tree
Message-Id: <20220325013410.ED275C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: unset panic_on_warn inside panic()
has been removed from the -mm tree.  Its filename was
     panic-unset-panic_on_warn-inside-panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


