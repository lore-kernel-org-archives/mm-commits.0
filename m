Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F693C433E5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AD5C2064B
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595564123;
	bh=u55eDLVxPVqHl6sBpXIjlOc+5tnSyjO5MJuEBa1EYg8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2pnoYYKHAlkqAtYS2rK+80wErOPNCFMMUxoBgEakt8VIB1A9vBCXSOh71TfNNb3QV
	 Q3+CKw2oi1oB59n3Ocyuckx7sE1B+Wef5ZrR4zy7yyZN/8+z8crZJPKTEEE3M1/PGw
	 2MKzvWKVX/JhNFWVF2W7QB1RuZG+34pLp/Frc0AQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGXEPW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGXEPW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 839FE206EB;
        Fri, 24 Jul 2020 04:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564122;
        bh=u55eDLVxPVqHl6sBpXIjlOc+5tnSyjO5MJuEBa1EYg8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vSPEberi0nJFVL/lSmOnww4zbxs/aFtBjYq8+eiSZ/DDm2lsRmuyKXd13hcV7MOYS
         uw2ZFrp/RosbjRpjR012nkImmzYVzHJav+8OnioMZq0gAGtuxU2LQbWl/z1aAqIdDP
         y0sjQ1ZoXZtImuCbKpTaBqDYvDq5gQfXZWVgh5hU=
Date:   Thu, 23 Jul 2020 21:15:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhsharma@redhat.com,
        catalin.marinas@arm.com, hannes@cmpxchg.org, james.morse@arm.com,
        linux-mm@kvack.org, mark.rutland@arm.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, pkushwaha@marvell.com,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com,
        will@kernel.org
Subject:  [patch 05/15] mm/memcontrol: fix OOPS inside
 mem_cgroup_get_nr_swap_pages()
Message-ID: <20200724041521.QuyWRTbix%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: mm/memcontrol: fix OOPS inside mem_cgroup_get_nr_swap_pages()

Prabhakar reported an OOPS inside mem_cgroup_get_nr_swap_pages() function
in a corner case seen on some arm64 boards when kdump kernel runs with
"cgroup_disable=memory" passed to the kdump kernel via bootargs.

The root-cause behind the same is that currently mem_cgroup_swap_init()
function is implemented as a subsys_initcall() call instead of a
core_initcall(), this means 'cgroup_memory_noswap' still remains set to
the default value (false) even when memcg is disabled via
"cgroup_disable=memory" boot parameter.

This may result in premature OOPS inside mem_cgroup_get_nr_swap_pages()
function in corner cases:

  [    0.265617] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000188
  [    0.274495] Mem abort info:
  [    0.277311]   ESR = 0x96000006
  [    0.280389]   EC = 0x25: DABT (current EL), IL = 32 bits
  [    0.285751]   SET = 0, FnV = 0
  [    0.288830]   EA = 0, S1PTW = 0
  [    0.291995] Data abort info:
  [    0.294897]   ISV = 0, ISS = 0x00000006
  [    0.298765]   CM = 0, WnR = 0
  [    0.301757] [0000000000000188] user address but active_mm is swapper
  [    0.308174] Internal error: Oops: 96000006 [#1] SMP
  [    0.313097] Modules linked in:
  <..snip..>
  [    0.331384] pstate: 00400009 (nzcv daif +PAN -UAO BTYPE=--)
  [    0.337014] pc : mem_cgroup_get_nr_swap_pages+0x9c/0xf4
  [    0.342289] lr : mem_cgroup_get_nr_swap_pages+0x68/0xf4
  [    0.347564] sp : fffffe0012b6f800
  [    0.350905] x29: fffffe0012b6f800 x28: fffffe00116b3000
  [    0.356268] x27: fffffe0012b6fb00 x26: 0000000000000020
  [    0.361631] x25: 0000000000000000 x24: fffffc00723ffe28
  [    0.366994] x23: fffffe0010d5b468 x22: fffffe00116bfa00
  [    0.372357] x21: fffffe0010aabda8 x20: 0000000000000000
  [    0.377720] x19: 0000000000000000 x18: 0000000000000010
  [    0.383082] x17: 0000000043e612f2 x16: 00000000a9863ed7
  [    0.388445] x15: ffffffffffffffff x14: 202c303d70617773
  [    0.393808] x13: 6f6e5f79726f6d65 x12: 6d5f70756f726763
  [    0.399170] x11: 2073656761705f70 x10: 6177735f726e5f74
  [    0.404533] x9 : fffffe00100e9580 x8 : fffffe0010628160
  [    0.409895] x7 : 00000000000000a8 x6 : fffffe00118f5e5e
  [    0.415258] x5 : 0000000000000001 x4 : 0000000000000000
  [    0.420621] x3 : 0000000000000000 x2 : 0000000000000000
  [    0.425983] x1 : 0000000000000000 x0 : fffffc0060079000
  [    0.431346] Call trace:
  [    0.433809]  mem_cgroup_get_nr_swap_pages+0x9c/0xf4
  [    0.438735]  shrink_lruvec+0x404/0x4f8
  [    0.442516]  shrink_node+0x1a8/0x688
  [    0.446121]  do_try_to_free_pages+0xe8/0x448
  [    0.450429]  try_to_free_pages+0x110/0x230
  [    0.454563]  __alloc_pages_slowpath.constprop.106+0x2b8/0xb48
  [    0.460366]  __alloc_pages_nodemask+0x2ac/0x2f8
  [    0.464938]  alloc_page_interleave+0x20/0x90
  [    0.469246]  alloc_pages_current+0xdc/0xf8
  [    0.473379]  atomic_pool_expand+0x60/0x210
  [    0.477514]  __dma_atomic_pool_init+0x50/0xa4
  [    0.481910]  dma_atomic_pool_init+0xac/0x158
  [    0.486220]  do_one_initcall+0x50/0x218
  [    0.490091]  kernel_init_freeable+0x22c/0x2d0
  [    0.494489]  kernel_init+0x18/0x110
  [    0.498007]  ret_from_fork+0x10/0x18
  [    0.501614] Code: aa1403e3 91106000 97f82a27 14000011 (f940c663)
  [    0.507770] ---[ end trace 9795948475817de4 ]---
  [    0.512429] Kernel panic - not syncing: Fatal exception
  [    0.517705] Rebooting in 10 seconds..

Link: http://lkml.kernel.org/r/1593641660-13254-2-git-send-email-bhsharma@redhat.com
Fixes: eccb52e78809 ("mm: memcontrol: prepare swap controller setup for integration")
Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
Reported-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-oops-inside-mem_cgroup_get_nr_swap_pages
+++ a/mm/memcontrol.c
@@ -7186,6 +7186,13 @@ static struct cftype memsw_files[] = {
 	{ },	/* terminate */
 };
 
+/*
+ * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
+ * instead of a core_initcall(), this could mean cgroup_memory_noswap still
+ * remains set to false even when memcg is disabled via "cgroup_disable=memory"
+ * boot parameter. This may result in premature OOPS inside
+ * mem_cgroup_get_nr_swap_pages() function in corner cases.
+ */
 static int __init mem_cgroup_swap_init(void)
 {
 	/* No memory control -> no swap control */
@@ -7200,6 +7207,6 @@ static int __init mem_cgroup_swap_init(v
 
 	return 0;
 }
-subsys_initcall(mem_cgroup_swap_init);
+core_initcall(mem_cgroup_swap_init);
 
 #endif /* CONFIG_MEMCG_SWAP */
_
