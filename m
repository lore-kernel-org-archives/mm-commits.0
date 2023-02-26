Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CDBC64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 23:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjBZXvJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 18:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBZXvH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 18:51:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468C215CBB
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 15:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D393260CA4
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31148C433EF;
        Sun, 26 Feb 2023 23:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677455465;
        bh=TsRd4scWHhuTTWQ/kvoQtzRQnWDmlWWqcGxkVmzSL2c=;
        h=Date:To:From:Subject:From;
        b=N7M0G+BeqO+AnsXIvwAQw53AgMFcBjuNswkNQAO1R8ZLXE+wfpcSSBj/Nbxb8L10C
         DJYubJa9ypMKfTfdHLMNXchM2tVB0km7+7SGJD2tGytbWK5CUUCC0F6VnYnQM/QDlu
         mtgqQ2T09zKPZHHazA3nLDhYTFRAC1kv5Y3lz9CE=
Date:   Sun, 26 Feb 2023 15:51:04 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        vbabka@suse.cz, rdunlap@infradead.org, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, geert+renesas@glider.be,
        dan.j.williams@intel.com, ye.xingchen@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kconfigdebug-fix-sched_debug-dependency.patch removed from -mm tree
Message-Id: <20230226235105.31148C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Kconfig.debug: fix SCHED_DEBUG dependency
has been removed from the -mm tree.  Its filename was
     kconfigdebug-fix-sched_debug-dependency.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1153,7 +1153,7 @@ menu "Scheduler Debugging"
 
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
-	depends on DEBUG_KERNEL && PROC_FS
+	depends on DEBUG_KERNEL && DEBUG_FS
 	default y
 	help
 	  If you say Y here, the /sys/kernel/debug/sched file will be provided
_

Patches currently in -mm which might be from ye.xingchen@zte.com.cn are


