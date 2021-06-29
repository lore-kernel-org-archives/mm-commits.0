Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC43C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94DD661D12
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhF2Cm5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2Cmz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63D2761D12;
        Tue, 29 Jun 2021 02:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934427;
        bh=ennVxsdrnIN5AcDKUsHs7PKyicT0GbcfzLgIJJ7EsJU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bmsOdrKbb9ZpddlIWfRtb3ACsg0r1KcqqFGd21WIYXAJKyUSAe3If8yzvN3Yg7O1h
         r5eeJ/ADj6M29x4KffvFoT/tIS8VQ4zQ/AwfuQXH1GdEudUIoOQHHMrVaNCg/IwS8E
         6UdL0TpH2dIYjW+w73VGLbB1GIGoQHplhtjaovK0=
Date:   Mon, 28 Jun 2021 19:40:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aquini@redhat.com, atomlin@redhat.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 137/192] mm: vmalloc: add cond_resched() in
 __vunmap()
Message-ID: <20210629024027.tmU5aE_Lh%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rafael Aquini <aquini@redhat.com>
Subject: mm: vmalloc: add cond_resched() in __vunmap()

On non-preemptible kernel builds the watchdog can complain about soft
lockups when vfree() is called against large vmalloc areas:

[  210.851798] kvmalloc-test: vmalloc(2199023255552) succeeded
[  238.654842] watchdog: BUG: soft lockup - CPU#181 stuck for 26s! [rmmod:5203]
[  238.662716] Modules linked in: kvmalloc_test(OE-) ...
[  238.772671] CPU: 181 PID: 5203 Comm: rmmod Tainted: G S         OE     5.13.0-rc7+ #1
[  238.781413] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS PLYXCRB1.86B.0553.D01.1809190614 09/19/2018
[  238.792383] RIP: 0010:free_unref_page+0x52/0x60
[  238.797447] Code: 48 c1 fd 06 48 89 ee e8 9c d0 ff ff 84 c0 74 19 9c 41 5c fa 48 89 ee 48 89 df e8 b9 ea ff ff 41 f7 c4 00 02 00 00 74 01 fb 5b <5d> 41 5c c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 f0 29 77
[  238.818406] RSP: 0018:ffffb4d87868fe98 EFLAGS: 00000206
[  238.824236] RAX: 0000000000000000 RBX: 000000001da0c945 RCX: ffffb4d87868fe40
[  238.832200] RDX: ffffd79d3beed108 RSI: ffffd7998501dc08 RDI: ffff9c6fbffd7010
[  238.840166] RBP: 000000000d518cbd R08: ffffd7998501dc08 R09: 0000000000000001
[  238.848131] R10: 0000000000000000 R11: ffffd79d3beee088 R12: 0000000000000202
[  238.856095] R13: ffff9e5be3eceec0 R14: 0000000000000000 R15: 0000000000000000
[  238.864059] FS:  00007fe082c2d740(0000) GS:ffff9f4c69b40000(0000) knlGS:0000000000000000
[  238.873089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  238.879503] CR2: 000055a000611128 CR3: 000000f6094f6006 CR4: 00000000007706e0
[  238.887467] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  238.895433] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  238.903397] PKRU: 55555554
[  238.906417] Call Trace:
[  238.909149]  __vunmap+0x17c/0x220
[  238.912851]  __x64_sys_delete_module+0x13a/0x250
[  238.918008]  ? syscall_trace_enter.isra.20+0x13c/0x1b0
[  238.923746]  do_syscall_64+0x39/0x80
[  238.927740]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Like in other range zapping routines that iterate over a large list, lets
just add cond_resched() within __vunmap()'s page-releasing loop in order
to avoid the watchdog splats.

Link: https://lkml.kernel.org/r/20210622225030.478384-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-add-cond_resched-in-__vunmap
+++ a/mm/vmalloc.c
@@ -2567,6 +2567,7 @@ static void __vunmap(const void *addr, i
 
 			BUG_ON(!page);
 			__free_pages(page, page_order);
+			cond_resched();
 		}
 		atomic_long_sub(area->nr_pages, &nr_vmalloc_pages);
 
_
