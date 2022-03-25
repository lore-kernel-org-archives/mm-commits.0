Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03E2C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355964AbiCYBhI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357504AbiCYBfy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640E93525F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D6FF4CE2837
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45330C340ED;
        Fri, 25 Mar 2022 01:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172036;
        bh=gOhkj9GYUgoYTHVQj+eSX0yqxya+T50X7DIWMJCXouA=;
        h=Date:To:From:Subject:From;
        b=dlnG3CpuTuk9SaavglFm18qd0rQ0VLqJW67Sg0k4D4fZVr374StiWBhDmIiIRoEtT
         jMW6XQ7otloU0vCc7HbpV3NeIoek+oknapz2p+HcYGnfcbupKc3Y2kak/Zus4x3kyV
         Yoz6k63qBOBfzFgAcqvRdV9uS3RwQq01GH3OKEn8=
Date:   Thu, 24 Mar 2022 18:33:55 -0700
To:     mm-commits@vger.kernel.org, yj.chiang@mediatek.com,
        wangkefeng.wang@huawei.com, vbabka@suse.cz,
        valentin.schneider@arm.com, rostedt@goodmis.org,
        peterz@infradead.org, mhiramat@kernel.org, matthias.bgg@gmail.com,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        ahalaney@redhat.com, mark-pk.tsai@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] init-use-ktime_us_delta-to-make-initcall_debug-log-more-precise.patch removed from -mm tree
Message-Id: <20220325013356.45330C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: use ktime_us_delta() to make initcall_debug log more precise
has been removed from the -mm tree.  Its filename was
     init-use-ktime_us_delta-to-make-initcall_debug-log-more-precise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from mark-pk.tsai@mediatek.com are


