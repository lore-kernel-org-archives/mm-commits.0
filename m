Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2160C05027
	for <mm-commits@archiver.kernel.org>; Sun, 29 Jan 2023 21:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjA2Vh2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Jan 2023 16:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbjA2Vh1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 Jan 2023 16:37:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE8C16AFE
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 13:37:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C018960E33
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 21:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C5EC433D2;
        Sun, 29 Jan 2023 21:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675028244;
        bh=qc3LwQd7mjfqgtRrQ2fufUZg71t5Xbv7Xvs4JqQsBbY=;
        h=Date:To:From:Subject:From;
        b=UzTCA9r4pqO4KHZmSqXg4S7qbMGOrt0jwH7ONHHEw8hwZL4HpSdd1DFdKKTdPRPrq
         VEq42HZ9+xSpgPq3j2gdaVD8q+PhT2hzX5ajwnMpmerHcDsy6ejnRknWMuk1x9/Y8e
         IXNZcFEDF7Ei1RHn/WTAnT+18KLSYyeqF91rsITA=
Date:   Sun, 29 Jan 2023 13:37:23 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        vbabka@suse.cz, rdunlap@infradead.org, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, geert+renesas@glider.be,
        dan.j.williams@intel.com, ye.xingchen@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kconfigdebug-fix-the-help-description-in-sched_debug.patch added to mm-hotfixes-unstable branch
Message-Id: <20230129213724.15C5EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: fix the help description in SCHED_DEBUG
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kconfigdebug-fix-the-help-description-in-sched_debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kconfigdebug-fix-the-help-description-in-sched_debug.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: ye xingchen <ye.xingchen@zte.com.cn>
Subject: Kconfig.debug: fix the help description in SCHED_DEBUG
Date: Sun, 29 Jan 2023 10:13:57 +0800 (CST)

The correct file path for SCHED_DEBUG is /sys/kernel/debug/sched.

Link: https://lkml.kernel.org/r/202301291013573466558@zte.com.cn
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/Kconfig.debug~kconfigdebug-fix-the-help-description-in-sched_debug
+++ a/lib/Kconfig.debug
@@ -1208,7 +1208,7 @@ config SCHED_DEBUG
 	depends on DEBUG_KERNEL && PROC_FS
 	default y
 	help
-	  If you say Y here, the /proc/sched_debug file will be provided
+	  If you say Y here, the /sys/kernel/debug/sched file will be provided
 	  that can help debug the scheduler. The runtime overhead of this
 	  option is minimal.
 
_

Patches currently in -mm which might be from ye.xingchen@zte.com.cn are

kconfigdebug-fix-the-help-description-in-sched_debug.patch

