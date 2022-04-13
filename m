Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B620EC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 19:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiDMTdK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiDMTcU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 15:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB329FEF
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 12:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25C4561D9C
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 19:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C637C385A4;
        Wed, 13 Apr 2022 19:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649878196;
        bh=TRtKipY3DHI4mdMtPUwhxaeI65s/jeN088xjXslmK0M=;
        h=Date:To:From:Subject:From;
        b=BvH44UaBC7F/vn0chR2Oc7VB4IGYbTh2DbhpLhRydqog6sBYsOacIXvp3Y0WQWWEw
         +sk634UxZU/tRqrn2OdgrZZG2kVXrdn3HTijYuFq4lEaCwOJazfnRcSz7jnTOJRviy
         z0E+002jBvDAt+TvhPDvMw0yPemhNDGa2iYbbUls=
Date:   Wed, 13 Apr 2022 12:29:55 -0700
To:     mm-commits@vger.kernel.org, catalin.marinas@arm.com,
        patrick.wang.shcn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-take-a-full-lowmem-check-in-kmemleak__phys.patch added to -mm tree
Message-Id: <20220413192956.7C637C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: take a full lowmem check in kmemleak_*_phys()
has been added to the -mm tree.  Its filename is
     mm-kmemleak-take-a-full-lowmem-check-in-kmemleak__phys.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-take-a-full-lowmem-check-in-kmemleak__phys.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-take-a-full-lowmem-check-in-kmemleak__phys.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

The kmemleak_*_phys() apis do not check the address for lowmem's min
boundary, while the caller may pass an address below lowmem, which will
trigger an oops:

# echo scan > /sys/kernel/debug/kmemleak
[   54.888353] Unable to handle kernel paging request at virtual address ff5fffffffe00000
[   54.888932] Oops [#1]
[   54.889102] Modules linked in:
[   54.889326] CPU: 2 PID: 134 Comm: bash Not tainted 5.18.0-rc1-next-20220407 #33
[   54.889620] Hardware name: riscv-virtio,qemu (DT)
[   54.889901] epc : scan_block+0x74/0x15c
[   54.890215]  ra : scan_block+0x72/0x15c
[   54.890390] epc : ffffffff801e5806 ra : ffffffff801e5804 sp : ff200000104abc30
[   54.890607]  gp : ffffffff815cd4e8 tp : ff60000004cfa340 t0 : 0000000000000200
[   54.890835]  t1 : 00aaaaaac23954cc t2 : 00000000000003ff s0 : ff200000104abc90
[   54.891024]  s1 : ffffffff81b0ff28 a0 : 0000000000000000 a1 : ff5fffffffe01000
[   54.891201]  a2 : ffffffff81b0ff28 a3 : 0000000000000002 a4 : 0000000000000001
[   54.891377]  a5 : 0000000000000000 a6 : ff200000104abd7c a7 : 0000000000000005
[   54.891552]  s2 : ff5fffffffe00ff9 s3 : ffffffff815cd998 s4 : ffffffff815d0e90
[   54.891727]  s5 : ffffffff81b0ff28 s6 : 0000000000000020 s7 : ffffffff815d0eb0
[   54.891903]  s8 : ffffffffffffffff s9 : ff5fffffffe00000 s10: ff5fffffffe01000
[   54.892078]  s11: 0000000000000022 t3 : 00ffffffaa17db4c t4 : 000000000000000f
[   54.892271]  t5 : 0000000000000001 t6 : 0000000000000000
[   54.892408] status: 0000000000000100 badaddr: ff5fffffffe00000 cause: 000000000000000d
[   54.892643] [<ffffffff801e5a1c>] scan_gray_list+0x12e/0x1a6
[   54.892824] [<ffffffff801e5d3e>] kmemleak_scan+0x2aa/0x57e
[   54.892961] [<ffffffff801e633c>] kmemleak_write+0x32a/0x40c
[   54.893096] [<ffffffff803915ac>] full_proxy_write+0x56/0x82
[   54.893235] [<ffffffff801ef456>] vfs_write+0xa6/0x2a6
[   54.893362] [<ffffffff801ef880>] ksys_write+0x6c/0xe2
[   54.893487] [<ffffffff801ef918>] sys_write+0x22/0x2a
[   54.893609] [<ffffffff8000397c>] ret_from_syscall+0x0/0x2
[   54.894183] ---[ end trace 0000000000000000 ]---

So check the address for lowmem's min boundary.

Link: https://lkml.kernel.org/r/20220413122925.33856-1-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmemleak.c~mm-kmemleak-take-a-full-lowmem-check-in-kmemleak__phys
+++ a/mm/kmemleak.c
@@ -1132,7 +1132,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 			       gfp_t gfp)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_alloc(__va(phys), size, min_count, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
@@ -1146,7 +1146,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_free_part(__va(phys), size);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1158,7 +1158,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_not_leak(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_not_leak_phys);
@@ -1170,7 +1170,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_ignore(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are

mm-kmemleak-take-a-full-lowmem-check-in-kmemleak__phys.patch

