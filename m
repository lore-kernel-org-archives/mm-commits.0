Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15628C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 17:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiBPR6Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 12:58:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiBPR6X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 12:58:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B449F27AFDF
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 09:58:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 409726115D
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 17:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB07C004E1;
        Wed, 16 Feb 2022 17:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645034289;
        bh=NF5PUEA1ieuYN94rCN1I2uBnZtgOdsbIPPpgg7NEJvI=;
        h=Date:To:From:Subject:From;
        b=pZVpqzCalmrV6sVfYQRQJdmzeGEbwy8fnHMpJio0xj46p3j1z445Hfpqpy6Uem71o
         VCBSHcDtg/3BOWuajtUDgGL8HYd3HL169DP81a1uSGSsDA1t5NoMrgEC3VehgE/mqt
         AUvXduH7tDBNfj0sk6+89NyGxU3mKE9SY/htVp0o=
Date:   Wed, 16 Feb 2022 09:58:08 -0800
To:     mm-commits@vger.kernel.org, v.narang@samsung.com,
        rostedt@goodmis.org, markus@trippelsdorf.de,
        lukas.bulwahn@gmail.com, jack@suse.cz, dwaipayanray1@gmail.com,
        apw@canonical.com, maninder1.s@samsung.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning.patch removed from -mm tree
Message-Id: <20220216175809.8FB07C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/checkpatch.pl: remove _deferred and _deferred_once false warning
has been removed from the -mm tree.  Its filename was
     scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: scripts/checkpatch.pl: remove _deferred and _deferred_once false warning

With commit 98e35f5894cf ("printk: git rid of [sched_delayed] message for
printk_deferred") printk_deferred and printk_deferred_once require
LOGLEVEL in argument, but checkpatch.pl was not fixed and still reports it
as warning:

WARNING: Possible unnecessary KERN_ALERT
printk_deferred(KERN_ALERT "checking deferred
");

As suggested by Andy, made 2 functions from logFunction.

1. logFunction: with all checks
2. logFunctionCore: without printk(?:_ratelimited|_once|_deferred) checking

and call logFunctionCore instead of logFunction for checking of loglevel,
which will exclude checking of printk(?:_ratelimited|_once|_deferred).

This way, there is no need to maintain same stanza at multiple places for
removing printk flavours.

Link: https://lkml.kernel.org/r/20220202103309.1914992-1-maninder1.s@samsung.com
Co-developed-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning
+++ a/scripts/checkpatch.pl
@@ -584,8 +584,7 @@ our $typeTypedefs = qr{(?x:
 
 our $zero_initializer = qr{(?:(?:0[xX])?0+$Int_type?|NULL|false)\b};
 
-our $logFunctions = qr{(?x:
-	printk(?:_ratelimited|_once|_deferred_once|_deferred|)|
+our $logFunctionsCore = qr{(?x:
 	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
 	TP_printk|
 	WARN(?:_RATELIMIT|_ONCE|)|
@@ -594,6 +593,11 @@ our $logFunctions = qr{(?x:
 	seq_vprintf|seq_printf|seq_puts
 )};
 
+our $logFunctions = qr{(?x:
+	printk(?:_ratelimited|_once|_deferred_once|_deferred|)|
+	$logFunctionsCore
+)};
+
 our $allocFunctions = qr{(?x:
 	(?:(?:devm_)?
 		(?:kv|k|v)[czm]alloc(?:_array)?(?:_node)? |
@@ -6312,8 +6316,7 @@ sub process {
 		}
 
 # check for logging functions with KERN_<LEVEL>
-		if ($line !~ /printk(?:_ratelimited|_once)?\s*\(/ &&
-		    $line =~ /\b$logFunctions\s*\(.*\b(KERN_[A-Z]+)\b/) {
+		if ($line =~ /\b$logFunctionsCore\s*\(.*\b(KERN_[A-Z]+)\b/) {
 			my $level = $1;
 			if (WARN("UNNECESSARY_KERN_LEVEL",
 				 "Possible unnecessary $level\n" . $herecurr) &&
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled.patch

