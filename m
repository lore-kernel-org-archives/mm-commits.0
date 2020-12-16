Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E00C2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B2223339
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgLPEpl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgLPEpk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:40 -0500
Date:   Tue, 15 Dec 2020 20:45:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093925;
        bh=Es/wrTINbDbFSwXL6qYwYmt8q1LtAh0Y6ZLXi8FWakY=;
        h=From:To:Subject:In-Reply-To:From;
        b=NwErUFn7vFGQcUr/UebBtPJE9NY6cBDXam2ap8r6pGnX8hojx0ROvnf55pqe3BhG7
         lO4d8I0RnmKdll1Rem6hgNSVOc2givDGQVxwHIVlduIca2blJa3Ft1lJxLY2ycjI2F
         +dEnjFFDf8CckV1C13yWN/oga5LllEA3K2vENaDs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 57/95] checkpatch: add printk_once and
 printk_ratelimit to prefer pr_<level> warning
Message-ID: <20201216044524.oQR3pUNXd%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: add printk_once and printk_ratelimit to prefer pr_<level> warning

Add the _once and _ratelimited variants to the test for
printk(KERN_<LEVEL> that should prefer pr_<level>.

Miscellanea:

o Add comment description for the conversions

[joe@perches.com: fixlet]
  Link: https://lkml.kernel.org/r/32260871d4718ba7f48a8e9e07452bb76de300db.camel@perches.comLink: https://lkml.kernel.org/r/993b72b2ef91a57c5e725b52971ce3fd31375061.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning
+++ a/scripts/checkpatch.pl
@@ -4543,16 +4543,23 @@ sub process {
 			     "printk() should include KERN_<LEVEL> facility level\n" . $herecurr);
 		}
 
-		if ($line =~ /\bprintk\s*\(\s*KERN_([A-Z]+)/) {
-			my $orig = $1;
+# prefer variants of (subsystem|netdev|dev|pr)_<level> to printk(KERN_<LEVEL>
+		if ($line =~ /\b(printk(_once|_ratelimited)?)\s*\(\s*KERN_([A-Z]+)/) {
+			my $printk = $1;
+			my $modifier = $2;
+			my $orig = $3;
+			$modifier = "" if (!defined($modifier));
 			my $level = lc($orig);
 			$level = "warn" if ($level eq "warning");
 			my $level2 = $level;
 			$level2 = "dbg" if ($level eq "debug");
+			$level .= $modifier;
+			$level2 .= $modifier;
 			WARN("PREFER_PR_LEVEL",
-			     "Prefer [subsystem eg: netdev]_$level2([subsystem]dev, ... then dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
+			     "Prefer [subsystem eg: netdev]_$level2([subsystem]dev, ... then dev_$level2(dev, ... then pr_$level(...  to $printk(KERN_$orig ...\n" . $herecurr);
 		}
 
+# prefer dev_<level> to dev_printk(KERN_<LEVEL>
 		if ($line =~ /\bdev_printk\s*\(\s*KERN_([A-Z]+)/) {
 			my $orig = $1;
 			my $level = lc($orig);
_
