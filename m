Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E351FC636CC
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjBAApz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjBAApl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:45:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5E753B25
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:45:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EC971CE1F6F
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C400C433D2;
        Wed,  1 Feb 2023 00:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212326;
        bh=jHlQDAK8mJkPbUKxK+M0uoPXUVngIpsc8a+1wJ0mbbQ=;
        h=Date:To:From:Subject:From;
        b=1Isa3LqtVb3NIBgUSUaDr9ji9mnCMMqSzGRbOkA1Zil5rTLzjohY/nCcQqUcOam3y
         Iv/2Yr4RR8Kpf6uKk4H6lf4imoKMtbFNEJkRHar/5ISY6FWDgwJ4nKSdbpZtn7nOay
         8MH1mrk8cq66Cfsb5PbaehscUs5MzLJVNZq3R/zU=
Date:   Tue, 31 Jan 2023 16:45:25 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        vbabka@suse.cz, rdunlap@infradead.org, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, geert+renesas@glider.be,
        dan.j.williams@intel.com, ye.xingchen@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kconfigdebug-fix-the-help-description-in-sched_debug.patch removed from -mm tree
Message-Id: <20230201004526.3C400C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Kconfig.debug: fix the help description in SCHED_DEBUG
has been removed from the -mm tree.  Its filename was
     kconfigdebug-fix-the-help-description-in-sched_debug.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


