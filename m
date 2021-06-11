Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A802CC48BD1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 00:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85EA5613FF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 00:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhFKALW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 20:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231255AbhFKALW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 20:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49C7A613CF;
        Fri, 11 Jun 2021 00:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623370154;
        bh=/otHKkuDtMyjVDpw8+Q4dZ+CZ3MLg/Y4J6eeiA4IXYE=;
        h=Date:From:To:Subject:From;
        b=NY3YcK0zbqo3sT1TE7CrMYA01ZumX4hegLsJUYyNS3LjzoVBE4oesL4uIEEMc9z97
         pV462IRBwOx5tzmbnIB36cefyWQuqmDZGsgHFtTIxhmcCVylRp48Wgt3Ianvc6Y/GB
         PEwlmZSaP3EMesQTOYcI7JAc2zxQjpIDKae0QUD4=
Date:   Thu, 10 Jun 2021 17:09:12 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, borntraeger@de.ibm.com,
        catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
        dalias@libc.org, geert@linux-m68k.org, gerg@linux-m68k.org,
        gor@linux.ibm.com, green.hu@gmail.com, guoren@kernel.org,
        hca@linux.ibm.com, jonas@southpole.se, jrdr.linux@gmail.com,
        ley.foon.tan@intel.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        nickhu@andestech.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
        rmk+kernel@armlinux.org.uk, shorne@gmail.com,
        stefan.kristiansson@saunalahti.fi, tglx@linutronix.de,
        vgupta@synopsys.com, wangkefeng.wang@huawei.com, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  + mm-add-setup_initial_init_mm-helper.patch added to -mm
 tree
Message-ID: <20210611000912.n40bKwVne%akpm@linux-foundation.org>
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

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch
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

