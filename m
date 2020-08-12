Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2C5C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CE8206F2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194217;
	bh=K+ZFlFBYfRQfFWDYRHfTe3QO7+w0yrE+hkkC5Wokgr8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dYgItm3hDUDIeJN9BpGVBV1qIBckdjk0FLK+PUDXjzmiSqUzUiKMdQlTICH8vrXCQ
	 rEl16dXy5lEmO7rYkR+ndMhRTA9X4pwZRzENLotCvLWpgpI5dxRwlFNRRJ3OUs1EFt
	 3T0oVhiRA5BmeX/AEXKwyhXVuc1zp38tt0zUmL5I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgHLBDh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgHLBDh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:03:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CF08206B5;
        Wed, 12 Aug 2020 01:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194215;
        bh=K+ZFlFBYfRQfFWDYRHfTe3QO7+w0yrE+hkkC5Wokgr8=;
        h=Date:From:To:Subject:From;
        b=MIXm0Jvo4dIO7lkJWFMWLbEcvTxd6z5kpqb7Z3rBTCCRnYNz0AkdO+5BLDMOgYLgc
         UalgdFsWH054EhAzRLnO5Ub8++VoFy4jQ/3qStZZfizmLszo4hilgJgLyCembtH/M5
         Y8rzAxyh3NQqrI9CHyTzVLewkmFUZVboYr/+q0Fg=
Date:   Tue, 11 Aug 2020 18:03:34 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, green.hu@gmail.com, hch@lst.de,
        mark.rutland@arm.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 uaccess-add-force_uaccess_beginend-helpers-v2.patch removed from -mm tree
Message-ID: <20200812010334.tq34cP9lK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: uaccess-add-force_uaccess_beginend-helpers-v2
has been removed from the -mm tree.  Its filename was
     uaccess-add-force_uaccess_beginend-helpers-v2.patch

This patch was dropped because it was folded into uaccess-add-force_uaccess_beginend-helpers.patch

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: uaccess-add-force_uaccess_beginend-helpers-v2

drop two incorrect hunks, fix a commit log typo

Link: http://lkml.kernel.org/r/20200714105505.935079-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greentime Hu <green.hu@gmail.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/tlbflush.h |    6 +++---
 arch/sh/kernel/traps_32.c        |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/m68k/include/asm/tlbflush.h~uaccess-add-force_uaccess_beginend-helpers-v2
+++ a/arch/m68k/include/asm/tlbflush.h
@@ -13,13 +13,13 @@ static inline void flush_tlb_kernel_page
 	if (CPU_IS_COLDFIRE) {
 		mmu_write(MMUOR, MMUOR_CNL);
 	} else if (CPU_IS_040_OR_060) {
-		mm_segment_t old_fs = force_uaccess_begin();
-
+		mm_segment_t old_fs = get_fs();
+		set_fs(KERNEL_DS);
 		__asm__ __volatile__(".chip 68040\n\t"
 				     "pflush (%0)\n\t"
 				     ".chip 68k"
 				     : : "a" (addr));
-		force_uaccess_end(old_fs);
+		set_fs(old_fs);
 	} else if (CPU_IS_020_OR_030)
 		__asm__ __volatile__("pflush #4,#4,(%0)" : : "a" (addr));
 }
--- a/arch/sh/kernel/traps_32.c~uaccess-add-force_uaccess_beginend-helpers-v2
+++ a/arch/sh/kernel/traps_32.c
@@ -538,13 +538,13 @@ uspace_segv:
 		if (regs->pc & 1)
 			die("unaligned program counter", regs, error_code);
 
-		oldfs = force_uaccess_begin();
+		set_fs(KERNEL_DS);
 		if (copy_from_user(&instruction, (void __user *)(regs->pc),
 				   sizeof(instruction))) {
 			/* Argh. Fault on the instruction itself.
 			   This should never happen non-SMP
 			*/
-			force_uaccess_end(oldfs);
+			set_fs(oldfs);
 			die("insn faulting in do_address_error", regs, 0);
 		}
 
@@ -552,7 +552,7 @@ uspace_segv:
 
 		handle_unaligned_access(instruction, regs, &user_mem_access,
 					0, address);
-		force_uaccess_end(oldfs);
+		set_fs(oldfs);
 	}
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

syscalls-use-uaccess_kernel-in-addr_limit_user_check.patch
nds32-use-uaccess_kernel-in-show_regs.patch
riscv-include-asm-pgtableh-in-asm-uaccessh.patch
uaccess-remove-segment_eq.patch
uaccess-add-force_uaccess_beginend-helpers.patch
exec-use-force_uaccess_begin-during-exec-and-exit.patch
kernel-add-a-kernel_wait-helper.patch

