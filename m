Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C2CC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BA720882
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597871657;
	bh=/p8Y8Vvrubcq1mhUVaQ9KFw7Es68Mwgz4KlNKACvdJM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=TqXkTEYUh5fbKba6dnbv/MbMqVoYW2pq97RiXI7r7jKaHXcYTMR0tRpIiKRRbKCH/
	 wRiZUAmi3F42OGo0QLvnGWVBb7uad4++WPIJ5GRj3/aHvf9le59hXGqHf/pPwtbop5
	 T0Fe2mcknBeMmSyLPZnD4ig14iK3GiBKd2fk9lrs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgHSVOR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSVOQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 17:14:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D66BF207FF;
        Wed, 19 Aug 2020 21:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597871655;
        bh=/p8Y8Vvrubcq1mhUVaQ9KFw7Es68Mwgz4KlNKACvdJM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hIeI2g1f8KsxqiiwUWGvHurHC9CUo7fDaQafc4q8O3O4xSYNfW+4D2ttATtxNFAg9
         bvyP5PC2psrt7OKeQKNZRexQNsK0IpLRyvl+Z1W1XhAD5XcK6+PZJC/6wdwSVQMAZ9
         Q9g53qN006Qp+wxxqMjzETHIbhvYL3ss7y4QmHz0=
Date:   Wed, 19 Aug 2020 14:14:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aik@ozlabs.ru, aquini@redhat.com, dianders@chromium.org,
        keescook@chromium.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, tglx@linutronix.de,
        will@kernel.org
Subject:  + panic-dump-registers-on-panic_on_warn.patch added to
 -mm tree
Message-ID: <20200819211414.9DAh-zfFa%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: dump registers on panic_on_warn
has been added to the -mm tree.  Its filename is
     panic-dump-registers-on-panic_on_warn.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/panic-dump-registers-on-panic_on_warn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/panic-dump-registers-on-panic_on_warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

panic-dump-registers-on-panic_on_warn.patch

