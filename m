Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3AEC4743C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D92861405
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFDUxS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 16:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231320AbhFDUxR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 16:53:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E89F613FF;
        Fri,  4 Jun 2021 20:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622839891;
        bh=+nEsy+bln3SwPDIdRVgQEAkbT6Dmr4HYZ2KOZIJm2IA=;
        h=Date:From:To:Subject:From;
        b=NvTRe+pVxYRzpMEXroTmSYq07cy0oLitTr9UulrOTsSFpeZBulY6xFsQJjiDh5zsc
         jXS5t4+d0LReOsa/P/CD1uz3UdiY1K3Cilk3g4clXD0i1YjfmWWRrf49ZAVnXvHSe8
         3ckFr0aHJCwfKXi0lqL1cqWlfTqOQpJZ9GDJhUjg=
Date:   Fri, 04 Jun 2021 13:51:29 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, borntraeger@de.ibm.com,
        catalin.marinas@arm.com, dalias@libc.org, geert@linux-m68k.org,
        gerg@linux-m68k.org, gor@linux.ibm.com, green.hu@gmail.com,
        guoren@kernel.org, hca@linux.ibm.com, jonas@southpole.se,
        ley.foon.tan@intel.com, linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        nickhu@andestech.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
        shorne@gmail.com, stefan.kristiansson@saunalahti.fi,
        tglx@linutronix.de, vgupta@synopsys.com,
        wangkefeng.wang@huawei.com, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  + mm-add-setup_initial_init_mm-helper.patch added to -mm
 tree
Message-ID: <20210604205129.m-X18nSxE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add setup_initial_init_mm() helper
has been added to the -mm tree.  Its filename is
     mm-add-setup_initial_init_mm-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-setup_initial_init_mm-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-setup_initial_init_mm-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add setup_initial_init_mm() helper

Patch series "init_mm: cleanup ARCH's text/data/brk setup code", v2.

Add setup_initial_init_mm() helper, then use it to cleanup the text, data
and brk setup code.


This patch (of 15):

Add setup_initial_init_mm() helper to setup kernel text, data and brk.

Link: https://lkml.kernel.org/r/20210604070633.32363-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20210604070633.32363-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/mm_types.h~mm-add-setup_initial_init_mm-helper
+++ a/include/linux/mm_types.h
@@ -562,6 +562,14 @@ struct mm_struct {
 };
 
 extern struct mm_struct init_mm;
+static inline void setup_initial_init_mm(void *start_code, void *end_code,
+					 void *end_data, void *brk)
+{
+	init_mm.start_code = (unsigned long)start_code;
+	init_mm.end_code = (unsigned long)end_code;
+	init_mm.end_data = (unsigned long)end_data;
+	init_mm.brk = (unsigned long)brk;
+}
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
 static inline void mm_init_cpumask(struct mm_struct *mm)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
mm-add-setup_initial_init_mm-helper.patch
arc-convert-to-setup_initial_init_mm.patch
arm-convert-to-setup_initial_init_mm.patch
arm64-convert-to-setup_initial_init_mm.patch
csky-convert-to-setup_initial_init_mm.patch
h8300-convert-to-setup_initial_init_mm.patch
m68k-convert-to-setup_initial_init_mm.patch
nds32-convert-to-setup_initial_init_mm.patch
nios2-convert-to-setup_initial_init_mm.patch
openrisc-convert-to-setup_initial_init_mm.patch
powerpc-convert-to-setup_initial_init_mm.patch
riscv-convert-to-setup_initial_init_mm.patch
s390-convert-to-setup_initial_init_mm.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

