Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F03DC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345409AbiCWXHr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345398AbiCWXHk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708769027D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CD85617D5
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F750C340E8;
        Wed, 23 Mar 2022 23:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076769;
        bh=WOojmLJNV9d/aw3/y2VsqeO+V8CmGyRiPq3Qzb2AaXU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=GSFuntTwHN7A86eODiCmkN71zzg2D1RScIIDJtyJRwkXSy8tnkx0keZkZ/qlakm9+
         d/OtZ7+1UgD2ujYxaQjB7l7hJ5PWhOD8pgODOKkm6ESO4IJKzYtomSI6q2074ae/ED
         f2wzURf16/Pm3FDFafW4HQ5VNR6L0n5cNihiNYkQ=
Date:   Wed, 23 Mar 2022 16:06:08 -0700
To:     yj.chiang@mediatek.com, wangkefeng.wang@huawei.com, vbabka@suse.cz,
        valentin.schneider@arm.com, rostedt@goodmis.org,
        peterz@infradead.org, mhiramat@kernel.org, matthias.bgg@gmail.com,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        ahalaney@redhat.com, mark-pk.tsai@mediatek.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 17/41] init: use ktime_us_delta() to make initcall_debug log more precise
Message-Id: <20220323230609.5F750C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

 init/main.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

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
