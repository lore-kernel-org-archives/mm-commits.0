Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF04C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271642087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817924;
	bh=rLlJSTd/jaZP9BY5EqjGjcK1DFidff+fwX7ncfrLHRg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fmoo8bVpfMBjIQ6dA6keje545uwe9ufAOr2vpDp5Y+4+wBuUmsIe1YbOfj6GCgp1q
	 mkOg9fY5jspuT08u8gfOkfm37RkoAWt6MMGxGGmdthaoCaAVSSV5P6c80jZT1L/fWi
	 78zhsv624xpOOUiGHLSaRJEuES1t2wP5/v7iIo8M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbgJPDMD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDMD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFC8F20789;
        Fri, 16 Oct 2020 03:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817923;
        bh=rLlJSTd/jaZP9BY5EqjGjcK1DFidff+fwX7ncfrLHRg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tDADuLV/eMMt5RD9DadKfeuCaiSsbVfBktM/W2hyjubU7aWUgwQl4r2YFqd5zO22K
         /jXLdRPRWH05WCBw4AIepZN/RiP6jByD1yoppABva6xpHXx3IeDElEk3Ho0vNdUu9c
         N7iHIU7QjF6oJ+KLFBAXi2QXUZEwb5pIUKKmAmZg=
Date:   Thu, 15 Oct 2020 20:12:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, drinkcat@chromium.org, joe@perches.com,
        mm-commits@vger.kernel.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org
Subject:  [patch 125/156] checkpatch: warn if trace_printk and
 friends are called
Message-ID: <20201016031202.lHx72T837%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>
Subject: checkpatch: warn if trace_printk and friends are called

trace_printk is meant as a debugging tool, and should not be compiled into
production code without specific debug Kconfig options enabled, or source
code changes, as indicated by the warning that shows up on boot if any
trace_printk is called:

 **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
 **                                                      **
 ** trace_printk() being used. Allocating extra memory.  **
 **                                                      **
 ** This means that this is a DEBUG kernel and it is     **
 ** unsafe for production use.                           **

Let's warn developers when they try to submit such a change.

Link: https://lkml.kernel.org/r/20200825193600.v2.1.I723c43c155f02f726c97501be77984f1e6bb740a@changeid
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-warn-if-trace_printk-and-friends-are-called
+++ a/scripts/checkpatch.pl
@@ -4274,6 +4274,12 @@ sub process {
 			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
 		}
 
+# trace_printk should not be used in production code.
+		if ($line =~ /\b(trace_printk|trace_puts|ftrace_vprintk)\s*\(/) {
+			WARN("TRACE_PRINTK",
+			     "Do not use $1() in production code (this can be ignored if built only with a debug config option)\n" . $herecurr);
+		}
+
 # ENOSYS means "bad syscall nr" and nothing else.  This will have a small
 # number of false positives, but assembly files are not checked, so at
 # least the arch entry code will not trigger this warning.
_
