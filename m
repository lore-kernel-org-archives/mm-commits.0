Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE9BC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EE4421775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881638;
	bh=2r2k6bYpJCpis7zrx0QKwYEk63DLy8RKAgT69fa2/Xs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jTiiYKCiTtJ3qi5Au+O7D6zZpc6yixT+krLRevHgVp27G77EYkafpjuKSAIm/CaY1
	 08Ulq/mQv2QMaFm8/d9GLcu61bDU4VSDSmzagPjCVD/5vUI8PtU4GGBscTRt4B5SoV
	 KaayNWs/9frUUQl5Anr09vpCNyRbcdM3gfEqqqeY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409223AbgJPUx5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409219AbgJPUx5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE88E2076C;
        Fri, 16 Oct 2020 20:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881636;
        bh=2r2k6bYpJCpis7zrx0QKwYEk63DLy8RKAgT69fa2/Xs=;
        h=Date:From:To:Subject:From;
        b=i6prjtyw7amXlsWY4MrClcNVo3Ewz0lRLNFZNUVUL7woLSKWUDY7XhiglNfJhHVJq
         zBnMFv6N4RHli4ld1886uQLEeb77qF5It3BhtHhjLp13k4Mtg7vBrZPGwA2/J6tToq
         bwg7bMgSuHRZ1ffCjDmo5TFPQi2ON4KV7gXB9IJM=
Date:   Fri, 16 Oct 2020 13:53:56 -0700
From:   akpm@linux-foundation.org
To:     drinkcat@chromium.org, joe@perches.com, mm-commits@vger.kernel.org,
        rostedt@goodmis.org
Subject:  [merged]
 checkpatch-warn-if-trace_printk-and-friends-are-called.patch removed from
 -mm tree
Message-ID: <20201016205356.WYEbTUj_U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn if trace_printk and friends are called
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-if-trace_printk-and-friends-are-called.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from drinkcat@chromium.org are


