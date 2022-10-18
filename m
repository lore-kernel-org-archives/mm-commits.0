Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A60C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJRAfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiJRAfH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:35:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E63520B6
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:34:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B151B81B37
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2E5C433D6;
        Tue, 18 Oct 2022 00:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666052469;
        bh=midFtjubg/Z1kDRz2UB0Xddb3AbY+dLfXqnsUFckzbI=;
        h=Date:To:From:Subject:From;
        b=cL0B5BIy3GRQ6xeOYizKuJ1vLnckZiHzaQcjK3uAHvS3q7iev32bKiWZCc3Yscys+
         D5DaO5LDygITlTNjXKqN38rtsPPIz/L0Vl8lQds1jVMlQJRW9z77FbzDsRvGfI/HBU
         NCYTGtCIwxmVLZSKvaZkVGojvLvGamRiA3j2qlS0=
Date:   Mon, 17 Oct 2022 17:21:08 -0700
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-use-str_enabled_disabled-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20221018002109.BB2E5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: use str_enabled_disabled() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-use-str_enabled_disabled-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-use-str_enabled_disabled-helper.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

panic-use-str_enabled_disabled-helper.patch

