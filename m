Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD29C6369E
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B78D722277
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtFGwxpu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgKNGwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 01:52:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgKNGwV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Nov 2020 01:52:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC932073C;
        Sat, 14 Nov 2020 06:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336740;
        bh=ObAOBqZNtreQ5iTbc4vp4rnvs0bMjsVLb9Qrf9oukh4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OtFGwxpuQZ95UjewASbhRR+QpV2gJUWg2Nc/Y8XqrL4Jfq5XYwMJ02bojprnh3TFb
         /ocu5xemGHKlsK1oXRD8s+RNpCCSMdXeQBP3K+uhWZjQzr1o+Q7xHTWB8sAYktjtKe
         f8D5ihRaNQScjwTj1CduMmcBzh+NFin1Yq7hQ2cM=
Date:   Fri, 13 Nov 2020 22:52:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aik@ozlabs.ru, akpm@linux-foundation.org,
        christophe.leroy@csgroup.eu, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com
Subject:  [patch 13/14] panic: don't dump stack twice on warn
Message-ID: <20201114065220._M2ijwOkQ%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: panic: don't dump stack twice on warn

Before commit 3f388f28639f ("panic: dump registers on panic_on_warn"),
__warn() was calling show_regs() when regs was not NULL, and show_stack()
otherwise.

After that commit, show_stack() is called regardless of whether
show_regs() has been called or not, leading to duplicated Call Trace:

[    7.112617] ------------[ cut here ]------------
[    7.117041] WARNING: CPU: 0 PID: 1 at arch/powerpc/mm/nohash/8xx.c:186 mmu_mark_initmem_nx+0x24/0x94
[    7.126021] CPU: 0 PID: 1 Comm: swapper Not tainted 5.10.0-rc2-s3k-dev-01375-gf46ec0d3ecbd-dirty #4092
[    7.135202] NIP:  c00128b4 LR: c0010228 CTR: 00000000
[    7.140205] REGS: c9023e40 TRAP: 0700   Not tainted  (5.10.0-rc2-s3k-dev-01375-gf46ec0d3ecbd-dirty)
[    7.149131] MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 24000424  XER: 00000000
[    7.155760]
[    7.155760] GPR00: c0010228 c9023ef8 c2100000 0074c000 ffffffff 00000000 c2151000 c07b3880
[    7.155760] GPR08: ff000900 0074c000 c8000000 c33b53a8 24000822 00000000 c0003a20 00000000
[    7.155760] GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    7.155760] GPR24: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00800000
[    7.191092] NIP [c00128b4] mmu_mark_initmem_nx+0x24/0x94
[    7.196333] LR [c0010228] free_initmem+0x20/0x58
[    7.200855] Call Trace:
[    7.203319] [c9023f18] [c0010228] free_initmem+0x20/0x58
[    7.208564] [c9023f28] [c0003a3c] kernel_init+0x1c/0x114
[    7.213813] [c9023f38] [c000f184] ret_from_kernel_thread+0x14/0x1c
[    7.219869] Instruction dump:
[    7.222805] 7d291850 7d234b78 4e800020 9421ffe0 7c0802a6 bfc10018 3fe0c060 3bff0000
[    7.230462] 3fff4080 3bffffff 90010024 57ff0010 <0fe00000> 392001cd 7c3e0b78 953e0008
[    7.238327] CPU: 0 PID: 1 Comm: swapper Not tainted 5.10.0-rc2-s3k-dev-01375-gf46ec0d3ecbd-dirty #4092
[    7.247500] Call Trace:
[    7.249977] [c9023dc0] [c001e070] __warn+0x8c/0xd8 (unreliable)
[    7.255815] [c9023de0] [c05e0e5c] report_bug+0x11c/0x154
[    7.261085] [c9023e10] [c0009ea4] program_check_exception+0x1dc/0x6e0
[    7.267430] [c9023e30] [c000f43c] ret_from_except_full+0x0/0x4
[    7.273238] --- interrupt: 700 at mmu_mark_initmem_nx+0x24/0x94
[    7.273238]     LR = free_initmem+0x20/0x58
[    7.283155] [c9023ef8] [00000000] 0x0 (unreliable)
[    7.287913] [c9023f18] [c0010228] free_initmem+0x20/0x58
[    7.293160] [c9023f28] [c0003a3c] kernel_init+0x1c/0x114
[    7.298410] [c9023f38] [c000f184] ret_from_kernel_thread+0x14/0x1c
[    7.304479] ---[ end trace 31702cd2a9570752 ]---

Only call show_stack() when regs is NULL.

Link: https://lkml.kernel.org/r/e8c055458b080707f1bc1a98ff8bea79d0cec445.1604748361.git.christophe.leroy@csgroup.eu
Fixes: 3f388f28639f ("panic: dump registers on panic_on_warn")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/panic.c~panic-dont-dump-stack-twice-on-warn
+++ a/kernel/panic.c
@@ -605,7 +605,8 @@ void __warn(const char *file, int line,
 		panic("panic_on_warn set ...\n");
 	}
 
-	dump_stack();
+	if (!regs)
+		dump_stack();
 
 	print_irqtrace_events(current);
 
_
