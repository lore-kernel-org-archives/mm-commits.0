Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C37C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 21:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbiBKV74 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 16:59:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiBKV7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 16:59:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69C2C70
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 13:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7375A611C0
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 21:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3654C340E9;
        Fri, 11 Feb 2022 21:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644616792;
        bh=DOLtFETWs3Rj5PYQbrfQ+zvufZOpf0CG6j7s/84Drxw=;
        h=Date:To:From:Subject:From;
        b=fKtRxyFRe+TozmUQPUl1SRKOB+Y6fA3bLv1ejiviqtGDEhRZHtqvggPgRIx2SxyfZ
         dt1C/YKjQAyYgX/v2oztIfw0zUiABa8URXW+eOBWO+f8HediuiqAxdaGVwqPBccnFl
         fSzEioddkZdGdAX/qOjc/lBdKYUvCVGLhfgL4064=
Date:   Fri, 11 Feb 2022 13:59:52 -0800
To:     mm-commits@vger.kernel.org, yj.chiang@mediatek.com,
        wangkefeng.wang@huawei.com, vbabka@suse.cz,
        valentin.schneider@arm.com, rostedt@goodmis.org,
        peterz@infradead.org, mhiramat@kernel.org, matthias.bgg@gmail.com,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        ahalaney@redhat.com, mark-pk.tsai@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-use-ktime_us_delta-to-make-initcall_debug-log-more-precise.patch added to -mm tree
Message-Id: <20220211215952.C3654C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: use ktime_us_delta() to make initcall_debug log more precise
has been added to the -mm tree.  Its filename is
     init-use-ktime_us_delta-to-make-initcall_debug-log-more-precise.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-use-ktime_us_delta-to-make-initcall_debug-log-more-precise.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-use-ktime_us_delta-to-make-initcall_debug-log-more-precise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: init: use ktime_us_delta() to make initcall_debug log more precise

Use ktime_us_delta() to make the initcall_debug log more precise than
right shifting the result of ktime_to_ns() by 10 bits.

Link: https://lkml.kernel.org/r/20220209053350.15771-1-mark-pk.tsai@mediatek.com
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Tested-by: Andrew Halaney <ahalaney@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: YJ Chiang <yj.chiang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/init/main.c~init-use-ktime_us_delta-to-make-initcall_debug-log-more-precise
+++ a/init/main.c
@@ -1246,15 +1246,11 @@ trace_initcall_start_cb(void *data, init
 static __init_or_module void
 trace_initcall_finish_cb(void *data, initcall_t fn, int ret)
 {
-	ktime_t *calltime = (ktime_t *)data;
-	ktime_t delta, rettime;
-	unsigned long long duration;
+	ktime_t rettime, *calltime = (ktime_t *)data;
 
 	rettime = ktime_get();
-	delta = ktime_sub(rettime, *calltime);
-	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
 	printk(KERN_DEBUG "initcall %pS returned %d after %lld usecs\n",
-		 fn, ret, duration);
+		 fn, ret, (unsigned long long)ktime_us_delta(rettime, *calltime));
 }
 
 static ktime_t initcall_calltime;
_

Patches currently in -mm which might be from mark-pk.tsai@mediatek.com are

init-use-ktime_us_delta-to-make-initcall_debug-log-more-precise.patch

