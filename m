Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDA5C47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A66936124B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhFHA2u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhFHA2u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:28:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8820E6101A;
        Tue,  8 Jun 2021 00:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112002;
        bh=/rz4KAtWfyoG2v3MNTgqXEF75H+VQUBUhnB7V7mVark=;
        h=Date:From:To:Subject:From;
        b=kkrMs6ybw2ll/jN4BsoNQlHCXohgVIigopGvBgPExgZAnpqkMhI4Crf0d9anRJnwS
         sawydTLn++fx+TB31D0SBY/ymtm9gK3PbHuk6LO6tWSQNLzNG7BvEg+GsqKIEQwWXz
         rfOjWllLZk3G6INZHTVdaEpogVULCLNMjabMdimw=
Date:   Mon, 07 Jun 2021 17:26:41 -0700
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
Subject:  [failures] mm-add-setup_initial_init_mm-helper.patch
 removed from -mm tree
Message-ID: <20210608002641.Yb3UrQjXG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add setup_initial_init_mm() helper
has been removed from the -mm tree.  Its filename was
     mm-add-setup_initial_init_mm-helper.patch

This patch was dropped because it had testing failures

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
mm-add-setup_initial_init_mm-helper-v3.patch
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

