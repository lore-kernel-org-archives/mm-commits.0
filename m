Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C31DC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B91D222200
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881709;
	bh=//oxElJD2uvJESNOQCnvlHQPU7Jqmj2/cjmsufCrHRg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MZ+GwgON/3WDPITJxi0inA4+tv16Ob5Qw0Z/N0uS0rQ5ywpyQUZsAGai/aMRXdn9Z
	 GBQRpmW0m3U7ou/HCKR0NblbL8o88AkHFuaq9YRAZWIheiHdUxUB3BwRM8la43V9JR
	 +1S/YhUsZIRGDPe4F/7gLoXZ6cIbX7LeDwo00Zgs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409433AbgJPUzJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgJPUzJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:55:09 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5CB6221EB;
        Fri, 16 Oct 2020 20:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881707;
        bh=//oxElJD2uvJESNOQCnvlHQPU7Jqmj2/cjmsufCrHRg=;
        h=Date:From:To:Subject:From;
        b=PYBzFhwNKDDK78mCRIkR+TU5e6HUWNOhwgrSoG3mn0m3WLLjZktJOi8xauZO7zdyp
         5JXV0fAt2h90rXrdG6i6zJxNqFCaMNUG9FReuZFziuzHrWjChwiqrTUXkJQN/J2wd+
         /kwNVct6bY5QeY5TEMu8rjbjfZwCgOfbvgDgtsZE=
Date:   Fri, 16 Oct 2020 13:55:06 -0700
From:   akpm@linux-foundation.org
To:     aik@ozlabs.ru, aquini@redhat.com, dianders@chromium.org,
        keescook@chromium.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, tglx@linutronix.de,
        will@kernel.org
Subject:  [merged] panic-dump-registers-on-panic_on_warn.patch
 removed from -mm tree
Message-ID: <20201016205506.5UNgtLz2G%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: dump registers on panic_on_warn
has been removed from the -mm tree.  Its filename was
     panic-dump-registers-on-panic_on_warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: panic: dump registers on panic_on_warn

Currently we print stack and registers for ordinary warnings but we do not
for panic_on_warn which looks as oversight - panic() will reboot the
machine but won't print registers.

This moves printing of registers and modules earlier.

This does not move the stack dumping as panic() dumps it.

Link: https://lkml.kernel.org/r/20200804095054.68724-1-aik@ozlabs.ru
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/panic.c~panic-dump-registers-on-panic_on_warn
+++ a/kernel/panic.c
@@ -589,6 +589,11 @@ void __warn(const char *file, int line,
 	if (args)
 		vprintk(args->fmt, args->args);
 
+	print_modules();
+
+	if (regs)
+		show_regs(regs);
+
 	if (panic_on_warn) {
 		/*
 		 * This thread may hit another WARN() in the panic path.
@@ -600,12 +605,7 @@ void __warn(const char *file, int line,
 		panic("panic_on_warn set ...\n");
 	}
 
-	print_modules();
-
-	if (regs)
-		show_regs(regs);
-	else
-		dump_stack();
+	dump_stack();
 
 	print_irqtrace_events(current);
 
_

Patches currently in -mm which might be from aik@ozlabs.ru are


