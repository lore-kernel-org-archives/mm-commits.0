Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92250C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4474D20FC3
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816620;
	bh=A0ChrCDCJhPaDEnC2n0JcMIBX/9RljacmUDs2z2DTAA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=uqWECAGHcRTdx8jPPu4j6WgBJd/pc/gaTlJxfnNRsut3hMl8VlDvG4PTWciK/WvZI
	 ELz1/AUvO5+mytjlAErt0x3opzOAMYBc8IiL7XC476Aa4SGyM4jjdKVsCzo3ef3wYg
	 vQMJ5E6/idl51C38ivCWug+dKUn4lD5o7r/K2r9w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404397AbgJPCuU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404125AbgJPCuT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:50:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4E1321556;
        Fri, 16 Oct 2020 02:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816619;
        bh=A0ChrCDCJhPaDEnC2n0JcMIBX/9RljacmUDs2z2DTAA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fOiSUgSkEkAek9c2x2JvqoL/hTRrNfxBkioqu93oDr/Tzqa1lvtJTicV5VL9KT8V3
         cC1x0uKFlDSA//LyIhtxH0Qy2dx1mSnnFpOPN5w57z7dzp519tiKLNxhwSBaZiZ8Wz
         joJ5IqYivdq9Ghrdir/dJpIqzzPx0EtnZ+tKuH3s=
Date:   Thu, 15 Oct 2020 19:50:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aik@ozlabs.ru, akpm@linux-foundation.org, aquini@redhat.com,
        dianders@chromium.org, keescook@chromium.org, linux-mm@kvack.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, npiggin@gmail.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 148/156] panic: dump registers on panic_on_warn
Message-ID: <20201016025018.o2XSfGQXU%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
