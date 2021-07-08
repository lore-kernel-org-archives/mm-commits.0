Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6508C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FD8161CD7
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhGHBLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGHBLE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0034C61CD4;
        Thu,  8 Jul 2021 01:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706503;
        bh=pQgTKXTczuQdlPqc4/XejAaDE2jh0mzB0lTe5/f1AHo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jp5xAYXGssqsdm2qxDbu7zKudVAn55wXH9gh5CQW4pkaYWX0lyO4kSWmtFwMwBQFf
         n4eEb+1+xLQdmF8s/ByQwOAHT7mKhKI8QP/ZPfOyKhUWws+S/Vr12pvfVE+mQJ/hjs
         oVpYJZamfo9BMXZ/KIP+zZwk1IfmFavWDajs6ox8=
Date:   Wed, 07 Jul 2021 18:08:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, catalin.marinas@arm.com,
        christophe.leroy@csgroup.eu, dalias@libc.org, geert@linux-m68k.org,
        gerg@linux-m68k.org, gor@linux.ibm.com, green.hu@gmail.com,
        guoren@kernel.org, hca@linux.ibm.com, jonas@southpole.se,
        jrdr.linux@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        nickhu@andestech.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
        rmk+kernel@armlinux.org.uk, shorne@gmail.com,
        stefan.kristiansson@saunalahti.fi, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgupta@synopsys.com,
        wangkefeng.wang@huawei.com, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  [patch 16/54] mm: add setup_initial_init_mm() helper
Message-ID: <20210708010822.IUD5lxMEc%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add setup_initial_init_mm() helper

Patch series "init_mm: cleanup ARCH's text/data/brk setup code", v3.

Add setup_initial_init_mm() helper, then use it to cleanup the text, data
and brk setup code.


This patch (of 15):

Add setup_initial_init_mm() helper to setup kernel text, data and brk.

Link: https://lkml.kernel.org/r/20210608083418.137226-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20210608083418.137226-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/init-mm.c       |    9 +++++++++
 2 files changed, 12 insertions(+)

--- a/include/linux/mm.h~mm-add-setup_initial_init_mm-helper
+++ a/include/linux/mm.h
@@ -238,6 +238,9 @@ int __add_to_page_cache_locked(struct pa
 
 #define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
 
+void setup_initial_init_mm(void *start_code, void *end_code,
+			   void *end_data, void *brk);
+
 /*
  * Linux kernel virtual memory manager primitives.
  * The idea being to have a "virtual" mm in the same way
--- a/mm/init-mm.c~mm-add-setup_initial_init_mm-helper
+++ a/mm/init-mm.c
@@ -40,3 +40,12 @@ struct mm_struct init_mm = {
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
 };
+
+void setup_initial_init_mm(void *start_code, void *end_code,
+			   void *end_data, void *brk)
+{
+	init_mm.start_code = (unsigned long)start_code;
+	init_mm.end_code = (unsigned long)end_code;
+	init_mm.end_data = (unsigned long)end_data;
+	init_mm.brk = (unsigned long)brk;
+}
_
