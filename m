Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519A7C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B87B2074A
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598401211;
	bh=OimV6nzmLuH6PFCLsi837IMGNrNcdSBdfv0IiukY//U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=G4o5R3VBWWeyrO6OxJfT1dAnqkak+JJHeR/BnnLGncBjtJgDNXaSFBzT99juWWgpv
	 QjpyfVdqogFK2qTWIRAc4ncnWs83cFU4T7RFi0u2H1m++y7iBdVYzlCOFU0g1Pf11S
	 jenhMoR8tzL8EXssrEMKG85RLBAQjhsGP04Ly6IM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgHZAUJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 20:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgHZAUI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 20:20:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A74820738;
        Wed, 26 Aug 2020 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598401206;
        bh=OimV6nzmLuH6PFCLsi837IMGNrNcdSBdfv0IiukY//U=;
        h=Date:From:To:Subject:From;
        b=gFc4gsaoqmQxIjWJ1GyeCj7ZKTLlUA5fKmxVcMnmeUuUApV/+q6u9DEWT0mW0ijHv
         9oU2TdpSCynR72TNhir+RahvbEoGp45xxMdgYgWjUcC/CzOBCE3DwSmkhPIQiUAM9A
         orJKsSqh8VvuI/1efiXA0cEsQQH3VgpdF5S5yAi8=
Date:   Tue, 25 Aug 2020 17:20:06 -0700
From:   akpm@linux-foundation.org
To:     drinkcat@chromium.org, joe@perches.com, mm-commits@vger.kernel.org,
        rostedt@goodmis.org
Subject:  +
 checkpatch-warn-if-trace_printk-and-friends-are-called.patch added to -mm
 tree
Message-ID: <20200826002006.ouQbepvq_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn if trace_printk and friends are called
has been added to the -mm tree.  Its filename is
     checkpatch-warn-if-trace_printk-and-friends-are-called.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-warn-if-trace_printk-and-friends-are-called.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-warn-if-trace_printk-and-friends-are-called.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -4276,6 +4276,12 @@ sub process {
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

Patches currently in -mm which might be from drinkcat@chromium.org are

checkpatch-warn-if-trace_printk-and-friends-are-called.patch

