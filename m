Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E05C05027
	for <mm-commits@archiver.kernel.org>; Sun, 29 Jan 2023 22:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbjA2WBL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Jan 2023 17:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjA2WBK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 Jan 2023 17:01:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DDD1BD8
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 14:01:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 150D360E55
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 22:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBC4C433D2;
        Sun, 29 Jan 2023 22:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675029666;
        bh=evesjpjbDebT7/1U9rFd5uY0bl2oQk0h/vgc37tuPW0=;
        h=Date:To:From:Subject:From;
        b=SRx21SMsARoIAWxKdegV2nmIAjE9bY4NZ7qoMlR5YTZn+YPlasePuWbPcAXmOQCi0
         2p9+GydGKODRuPa9RGyyLohxkl1ntZf61TFJquO55iowW9Z1OSKbG3jacZ5VKVAqOT
         p2k9TpDM5bIimHDPAEz8NDDsvDx0H0HReyWIHsy4=
Date:   Sun, 29 Jan 2023 14:01:05 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        vbabka@suse.cz, rdunlap@infradead.org, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, geert+renesas@glider.be,
        dan.j.williams@intel.com, ye.xingchen@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kconfigdebug-fix-sched_debug-dependency.patch added to mm-nonmm-unstable branch
Message-Id: <20230129220106.5CBC4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: fix SCHED_DEBUG dependency
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kconfigdebug-fix-sched_debug-dependency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kconfigdebug-fix-sched_debug-dependency.patch

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
From: ye xingchen <ye.xingchen@zte.com.cn>
Subject: Kconfig.debug: fix SCHED_DEBUG dependency
Date: Sun, 29 Jan 2023 11:10:09 +0800 (CST)

The path for SCHED_DEBUG is /sys/kernel/debug/sched.  So, SCHED_DEBUG
should depend on DEBUG_FS, not PROC_FS.

Link: https://lkml.kernel.org/r/202301291110098787982@zte.com.cn
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


--- a/lib/Kconfig.debug~kconfigdebug-fix-sched_debug-dependency
+++ a/lib/Kconfig.debug
@@ -1134,7 +1134,7 @@ menu "Scheduler Debugging"
 
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
-	depends on DEBUG_KERNEL && PROC_FS
+	depends on DEBUG_KERNEL && DEBUG_FS
 	default y
 	help
 	  If you say Y here, the /sys/kernel/debug/sched file will be provided
_

Patches currently in -mm which might be from ye.xingchen@zte.com.cn are

kconfigdebug-fix-the-help-description-in-sched_debug.patch
kconfigdebug-fix-sched_debug-dependency.patch

