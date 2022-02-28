Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B536C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 23:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiB1Xv6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 18:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiB1Xv6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 18:51:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C311412CC39
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 15:51:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FC68B816BC
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 23:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76F8C340EE;
        Mon, 28 Feb 2022 23:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646092275;
        bh=yoqZbjH/gJEW5BmDK6h53Sv0HwBR9nWjxvBQ/VKeyE0=;
        h=Date:To:From:Subject:From;
        b=KFu12mC1F7wK+VigIu3eRCkFbSpgUWtci24BkMGmcPq2h/r1X36yY2EbxwhKGGhE/
         kR6yyfbufm9mofINDDoiVXVEYxNbqRGpZS09Tu1criqx8J5RxlkjJPledaZts9r75n
         +pKGEq3BFe9+OVlO++mhnLSkIC5xozgSm3I8OtDY=
Date:   Mon, 28 Feb 2022 15:51:14 -0800
To:     mm-commits@vger.kernel.org, v.narang@samsung.com,
        lukas.bulwahn@gmail.com, joe@perches.com, dwaipayanray1@gmail.com,
        maninder1.s@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning.patch removed from -mm tree
Message-Id: <20220228235115.A76F8C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/checkpatch.pl: remove _deferred and _deferred_once false warning
has been removed from the -mm tree.  Its filename was
     scripts-checkpatchpl-remove-_deferred-and-_deferred_once-false-warning.patch

This patch was dropped because it was nacked

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

kallsyms-print-module-name-in-%ps-s-case-when-kallsyms-is-disabled.patch
kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled.patch

