Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50472C55179
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D8EF22273
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279269;
	bh=dXtlmzYLyKYO+5BDW5WMGMMhzyNVHeHIzJ8oO5uOUbQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=FRVhIzqmgE7gfdesQkuJA86oaZ9ICjHL8UwD2HMmyW8Ds7MnmB/3DHCPuwW62TPhn
	 j+fGkBlpHxkdHBeENN7ixYtcXBWkzQPQV8zvGcAWb9dy1emxr2x+N4AA368vViQiKc
	 IgW7tRhjSkBMXLvRsLGv944zAOb6jgGVl1z7fDcs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgKBBHs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBHs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:48 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F9192224E;
        Mon,  2 Nov 2020 01:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279268;
        bh=dXtlmzYLyKYO+5BDW5WMGMMhzyNVHeHIzJ8oO5uOUbQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k5UdlYzr1Nke11TACOFJ+CgblO6+rjMyRKHMwOmdld9VOKKbEv8fM8k/7kTP79mRd
         nxxXTaUOR19f8C5yw4EHUDqInnfZ5+/TvF4t4vdU1W0/1VfYI89vQ/JHz2/WUaJ0KN
         +acGQRoprADHQrgXY9JPvFKRpWSnHBv6w2zHJcMA=
Date:   Sun, 01 Nov 2020 17:07:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/15] lib/crc32test: remove extra
 local_irq_disable/enable
Message-ID: <20201102010747.MBqCP6PAv%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>
Subject: lib/crc32test: remove extra local_irq_disable/enable

Commit 4d004099a668 ("lockdep: Fix lockdep recursion") uncovered the
following issue in lib/crc32test reported on s390:

BUG: using __this_cpu_read() in preemptible [00000000] code: swapper/0/1
caller is lockdep_hardirqs_on_prepare+0x48/0x270
CPU: 6 PID: 1 Comm: swapper/0 Not tainted 5.9.0-next-20201015-15164-g03d992bd2de6 #19
Hardware name: IBM 3906 M04 704 (LPAR)
Call Trace:
 [<0000000000d54870>] show_stack+0x90/0xf8
 [<0000000000d675d2>] dump_stack+0xa2/0xd8
 [<0000000000d6c9ac>] check_preemption_disabled+0xe4/0xe8
 [<00000000001d6098>] lockdep_hardirqs_on_prepare+0x48/0x270
 [<00000000002ac274>] trace_hardirqs_on+0x9c/0x1b8
 [<0000000001441430>] crc32_test.isra.0+0x170/0x1c0
 [<0000000001441764>] crc32test_init+0x1c/0x40
 [<0000000000100cd0>] do_one_initcall+0x40/0x130
 [<0000000001411586>] do_initcalls+0x126/0x150
 [<0000000001411826>] kernel_init_freeable+0x1f6/0x230
 [<0000000000d6cc92>] kernel_init+0x22/0x150
 [<0000000000d7bcc4>] ret_from_fork+0x24/0x2c
no locks held by swapper/0/1.

Remove extra local_irq_disable/local_irq_enable helpers calls.

Link: https://lkml.kernel.org/r/patch.git-4369da00c06e.your-ad-here.call-01602859837-ext-1679@work.hours
Fixes: 5fb7f87408f1 ("lib: add module support to crc32 tests")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32test.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/lib/crc32test.c~lib-crc32test-remove-extra-local_irq_disable-enable
+++ a/lib/crc32test.c
@@ -683,7 +683,6 @@ static int __init crc32c_test(void)
 
 	/* reduce OS noise */
 	local_irq_save(flags);
-	local_irq_disable();
 
 	nsec = ktime_get_ns();
 	for (i = 0; i < 100; i++) {
@@ -694,7 +693,6 @@ static int __init crc32c_test(void)
 	nsec = ktime_get_ns() - nsec;
 
 	local_irq_restore(flags);
-	local_irq_enable();
 
 	pr_info("crc32c: CRC_LE_BITS = %d\n", CRC_LE_BITS);
 
@@ -768,7 +766,6 @@ static int __init crc32_test(void)
 
 	/* reduce OS noise */
 	local_irq_save(flags);
-	local_irq_disable();
 
 	nsec = ktime_get_ns();
 	for (i = 0; i < 100; i++) {
@@ -783,7 +780,6 @@ static int __init crc32_test(void)
 	nsec = ktime_get_ns() - nsec;
 
 	local_irq_restore(flags);
-	local_irq_enable();
 
 	pr_info("crc32: CRC_LE_BITS = %d, CRC_BE BITS = %d\n",
 		 CRC_LE_BITS, CRC_BE_BITS);
_
