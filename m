Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148E0C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbiKOWca (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238494AbiKOWcE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BB610D8
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 76051CE199B
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC72C433B5;
        Tue, 15 Nov 2022 22:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551519;
        bh=5oqDqP00NfnzHPhnYqo+BMcbsuIvCm2PCUnx5LUj4nU=;
        h=Date:To:From:Subject:From;
        b=upOjA8AHHsbwV7s/IxrRYBsjufVWY3OaedCR2GHuYHSsFSaIwnNL0ZUqf4IMVC2mx
         0eeUB2hLVWqP8fjurtEVzcJyl//n16hV3veNxupy/4BlaY+FLDSzQhNTSnFZpjkRGq
         Me5B1NqBdct/jfe4uaHtPXUAGmIvd5Pbsyb3i4f4=
Date:   Tue, 15 Nov 2022 14:31:59 -0800
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-use-str_enabled_disabled-helper.patch removed from -mm tree
Message-Id: <20221115223159.8AC72C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: panic: use str_enabled_disabled() helper
has been removed from the -mm tree.  Its filename was
     panic-use-str_enabled_disabled-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: panic: use str_enabled_disabled() helper
Date: Sat, 8 Oct 2022 22:59:14 +0300

Use str_enabled_disabled() helper instead of open coding the same.

Link: https://lkml.kernel.org/r/20221008195914.54199-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/panic.c~panic-use-str_enabled_disabled-helper
+++ a/kernel/panic.c
@@ -25,6 +25,7 @@
 #include <linux/kexec.h>
 #include <linux/panic_notifier.h>
 #include <linux/sched.h>
+#include <linux/string_helpers.h>
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
@@ -744,8 +745,8 @@ static int __init panic_on_taint_setup(c
 	if (s && !strcmp(s, "nousertaint"))
 		panic_on_taint_nousertaint = true;
 
-	pr_info("panic_on_taint: bitmask=0x%lx nousertaint_mode=%sabled\n",
-		panic_on_taint, panic_on_taint_nousertaint ? "en" : "dis");
+	pr_info("panic_on_taint: bitmask=0x%lx nousertaint_mode=%s\n",
+		panic_on_taint, str_enabled_disabled(panic_on_taint_nousertaint));
 
 	return 0;
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


