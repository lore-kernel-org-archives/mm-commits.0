Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592AFC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DA7620759
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595022155;
	bh=qL9GAadLbSdkl4MH6GHolHmOCbCyQzu4O68/XY6tWdA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=K1tOE+iMw+zqcg6YlBvWatA/4qE8C57L4B8UTwBRQOZgvVAQHM8diSWDdBpF7B9jj
	 H/KifZLRLfrgDS8mlngfYHPeSk5Qz2KzSGRP6YxfGZnDO5RO2muS/+BNxJ4A/jzR5u
	 05bCzcuJsVp19QPev5p97TmTsP6iJ6LBazl02Xr0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGQVme (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgGQVme (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 17:42:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A342D2064B;
        Fri, 17 Jul 2020 21:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595022153;
        bh=qL9GAadLbSdkl4MH6GHolHmOCbCyQzu4O68/XY6tWdA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qb1ApQsFbyjnTpNgHaYK+pm+YUMYeVkCmhGx1JuEavF9vg8ST00CVMpUMeGSwNdLx
         hM188XKEtcEsVVJhIr3REijTfLzwQSXs7EZshJ4vUSuUfWeu4APEJ1FSB+BWRVJVhJ
         eGZh5ue7xe8ycapw8vKckAnYhlV1mj3dTzVZSCVI=
Date:   Fri, 17 Jul 2020 14:42:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     geert@linux-m68k.org, green.hu@gmail.com, hch@lst.de,
        mark.rutland@arm.com, mm-commits@vger.kernel.org
Subject:  + uaccess-add-force_uaccess_beginend-helpers-v2.patch
 added to -mm tree
Message-ID: <20200717214233.9LHPdipV7%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: uaccess-add-force_uaccess_beginend-helpers-v2
has been added to the -mm tree.  Its filename is
     uaccess-add-force_uaccess_beginend-helpers-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uaccess-add-force_uaccess_beginend-helpers-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uaccess-add-force_uaccess_beginend-helpers-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
uaccess-add-force_uaccess_beginend-helpers-v2.patch
exec-use-force_uaccess_begin-during-exec-and-exit.patch

