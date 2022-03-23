Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D72DC43219
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345419AbiCWXI3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345436AbiCWXI0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BC490CF0
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88178B8214D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224FAC340E8;
        Wed, 23 Mar 2022 23:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076812;
        bh=fuOGKRKSSVApUKrrDtWBJXdPhJs/H587LuUnAeOtRZ0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=L39T/rhn+DSYaf/tD/+3Gb6gRzcaVA9t0I2I0dIB9r7e/h5sNMHYGEV1km1A/PZ3f
         4mUdsjkal2M9SygQTvniMU+PwQUgwdVhr5epMkMPeYy3jGs0Hb00+Xbc36bBBpnwND
         Y30kutLNDg+rd0ahUw7e7SQmL9N65T8b79wO5B60=
Date:   Wed, 23 Mar 2022 16:06:51 -0700
To:     ryabinin.a.a@gmail.com, lixuefeng@loongson.cn, elver@google.com,
        corbet@lwn.net, bhe@redhat.com, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 31/41] panic: unset panic_on_warn inside panic()
Message-Id: <20220323230652.224FAC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: panic: unset panic_on_warn inside panic()

In the current code, the following three places need to unset
panic_on_warn before calling panic() to avoid recursive panics:

kernel/kcsan/report.c: print_report()
kernel/sched/core.c: __schedule_bug()
mm/kfence/report.c: kfence_report_error()

In order to avoid copy-pasting "panic_on_warn = 0" all over the places, it
is better to move it inside panic() and then remove it from the other
places.

Link: https://lkml.kernel.org/r/1644324666-15947-4-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/kernel/panic.c~panic-unset-panic_on_warn-inside-panic
+++ a/kernel/panic.c
@@ -185,6 +185,16 @@ void panic(const char *fmt, ...)
 	int old_cpu, this_cpu;
 	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
+	}
+
 	/*
 	 * Disable local interrupts. This will prevent panic_smp_self_stop
 	 * from deadlocking the first cpu that invokes the panic, since
@@ -576,16 +586,8 @@ void __warn(const char *file, int line,
 	if (regs)
 		show_regs(regs);
 
-	if (panic_on_warn) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn)
 		panic("panic_on_warn set ...\n");
-	}
 
 	if (!regs)
 		dump_stack();
_
