Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4CCC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A113D208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816535;
	bh=rLlJSTd/jaZP9BY5EqjGjcK1DFidff+fwX7ncfrLHRg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IzLYfDczHJ7ZD90scQWT5jYXCpJaIChnt/F+RlayZyHlv5pu3Xk6yu2xGxTMnWowK
	 D3p4dWhnif+/hzpj8LUWeL84W/sIdPSkgf7D6xwCYJjo9neK7XpH9J0W9+iBGlRCnw
	 0tr0LkrV8lwEvKtB2NdWOu0Rz/G05V7v7tuagld0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404377AbgJPCsz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404364AbgJPCsz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE8C120897;
        Fri, 16 Oct 2020 02:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816534;
        bh=rLlJSTd/jaZP9BY5EqjGjcK1DFidff+fwX7ncfrLHRg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fXeaFRRx8zhLrFdqW3dBFDtIBaChMulWCAo4gZK2xeh7JBC+inwxv4Ts4nCWxypsE
         0OMGstwxKQT+VhfQsLLkR6+MQiZNhVDjvDlYr6zlBOeKYC7oft57FRD166+NDskLjC
         a10sCvFrQTdccRyb5/fBlt8nAsN5dQCMgnD97nyM=
Date:   Thu, 15 Oct 2020 19:48:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, drinkcat@chromium.org, joe@perches.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
Subject:  [patch 125/156] checkpatch: warn if trace_printk and
 friends are called
Message-ID: <20201016024853.NXTjAZOIJ%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
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
