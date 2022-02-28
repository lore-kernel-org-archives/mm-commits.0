Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674B2C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 20:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiB1UDY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiB1UDY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 15:03:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405E13C72F
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 12:02:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D99E760A5C
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 20:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E65C340F2;
        Mon, 28 Feb 2022 20:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646078564;
        bh=dCx6ZMTDrag9HdXd9+gdX9C8uiwWVMA9O7LgBQcJEcU=;
        h=Date:To:From:Subject:From;
        b=AWJvdbsoaLuicI2ttHNa6M2TM//7f2cjRAmfVhty2/izgC773fDAn3fmv7wLUaw1m
         GXMxduF+sn9qoEWQegf+gfksxTGIldw4YfhcUkSFWmtGF8wbOCx3SSxkxbFvOEUWQz
         2Y3kwMAlZRpA7kavJ6q/rB0v7aCcJWT34sFkc48Y=
Date:   Mon, 28 Feb 2022 12:02:43 -0800
To:     mm-commits@vger.kernel.org, v.narang@samsung.com,
        lukas.bulwahn@gmail.com, joe@perches.com, dwaipayanray1@gmail.com,
        maninder1.s@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning.patch added to -mm tree
Message-Id: <20220228200244.39E65C340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/checkpatch.pl: remove _deferred and _deferred_once false warning
has been added to the -mm tree.  Its filename is
     scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: scripts/checkpatch.pl: remove _deferred and _deferred_once false warning

With commit 98e35f5894cf ("printk: git rid of [sched_delayed] message for
printk_deferred") printk_deferred and printk_deferred_once requires
LOGLEVEL in argument, but checkpatch.pl was not fixed and still reports it
as warning:

WARNING: Possible unnecessary KERN_ALERT
printk_deferred(KERN_ALERT "checking deferred\n");

Link: https://lkml.kernel.org/r/20220228073708.1610603-1-maninder1.s@samsung.com
Co-developed-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning
+++ a/scripts/checkpatch.pl
@@ -6312,7 +6312,7 @@ sub process {
 		}
 
 # check for logging functions with KERN_<LEVEL>
-		if ($line !~ /printk(?:_ratelimited|_once)?\s*\(/ &&
+		if ($line !~ /printk(?:_ratelimited|_once|_deferred|_deferred_once)?\s*\(/ &&
 		    $line =~ /\b$logFunctions\s*\(.*\b(KERN_[A-Z]+)\b/) {
 			my $level = $1;
 			if (WARN("UNNECESSARY_KERN_LEVEL",
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning.patch
kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled.patch
kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled.patch

