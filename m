Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2359C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABAE3223E4
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgLaSYK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgLaSYK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:24:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64CE222482;
        Thu, 31 Dec 2020 18:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438984;
        bh=6JSEPyAjY0SiMkRkmfMTp4W3vC3ZNDUnTPGSASUsqpU=;
        h=Date:From:To:Subject:From;
        b=DrEM6cM39mK6k5D+TqBrUbPTRLvqxTrvrQUIgmo1YqRzXXu5taFD9Ywkp8d3XR0YH
         cHAuq5FejSXh+9qraZomwuiBRWzqe7ZbHeW4yiilF34kInEGYg/ECdpxbxnntZ8Hpy
         AlUkaihnrRGX9ztK67TqvRnYhxBYyjVp46LzrCpk=
Date:   Thu, 31 Dec 2020 10:23:04 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, axboe@kernel.dk, hch@infradead.org,
        jacquiot.aurelien@gmail.com, ley.foon.tan@intel.com,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        msalter@redhat.com, peterz@infradead.org, rdunlap@infradead.org
Subject:  [merged] local64h-make-asm-local64h-mandatory.patch
 removed from -mm tree
Message-ID: <20201231182304.1a1Y3HPvF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: local64.h: make <asm/local64.h> mandatory
has been removed from the -mm tree.  Its filename was
     local64h-make-asm-local64h-mandatory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: local64.h: make <asm/local64.h> mandatory

Make <asm-generic/local64.h> mandatory in include/asm-generic/Kbuild and
remove all arch/*/include/asm/local64.h arch-specific files since they
only #include <asm-generic/local64.h>.

This fixes build errors on arch/c6x/ and arch/nios2/ for
block/blk-iocost.c.

Build-tested on 21 of 25 arch-es. (tools problems on the others)

Yes, we could even rename <asm-generic/local64.h> to
<linux/local64.h> and change all #includes to use
<linux/local64.h> instead.

Link: https://lkml.kernel.org/r/20201227024446.17018-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/local64.h   |    1 -
 arch/arc/include/asm/Kbuild        |    1 -
 arch/arm/include/asm/Kbuild        |    1 -
 arch/arm64/include/asm/Kbuild      |    1 -
 arch/csky/include/asm/Kbuild       |    1 -
 arch/h8300/include/asm/Kbuild      |    1 -
 arch/hexagon/include/asm/Kbuild    |    1 -
 arch/ia64/include/asm/local64.h    |    1 -
 arch/m68k/include/asm/Kbuild       |    1 -
 arch/microblaze/include/asm/Kbuild |    1 -
 arch/mips/include/asm/Kbuild       |    1 -
 arch/nds32/include/asm/Kbuild      |    1 -
 arch/openrisc/include/asm/Kbuild   |    1 -
 arch/parisc/include/asm/Kbuild     |    1 -
 arch/powerpc/include/asm/Kbuild    |    1 -
 arch/riscv/include/asm/Kbuild      |    1 -
 arch/s390/include/asm/Kbuild       |    1 -
 arch/sh/include/asm/Kbuild         |    1 -
 arch/sparc/include/asm/Kbuild      |    1 -
 arch/x86/include/asm/local64.h     |    1 -
 arch/xtensa/include/asm/Kbuild     |    1 -
 include/asm-generic/Kbuild         |    1 +
 22 files changed, 1 insertion(+), 21 deletions(-)

--- a/arch/alpha/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
--- a/arch/arc/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/arc/include/asm/Kbuild
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 generic-y += extable.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += user.h
--- a/arch/arm64/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/arm64/include/asm/Kbuild
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 generic-y += early_ioremap.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
--- a/arch/arm/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/arm/include/asm/Kbuild
@@ -2,7 +2,6 @@
 generic-y += early_ioremap.h
 generic-y += extable.h
 generic-y += flat.h
-generic-y += local64.h
 generic-y += parport.h
 
 generated-y += mach-types.h
--- a/arch/csky/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/csky/include/asm/Kbuild
@@ -2,7 +2,6 @@
 generic-y += asm-offsets.h
 generic-y += gpio.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += qrwlock.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
--- a/arch/h8300/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/h8300/include/asm/Kbuild
@@ -2,7 +2,6 @@
 generic-y += asm-offsets.h
 generic-y += extable.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += spinlock.h
--- a/arch/hexagon/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/hexagon/include/asm/Kbuild
@@ -2,5 +2,4 @@
 generic-y += extable.h
 generic-y += iomap.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
--- a/arch/ia64/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
--- a/arch/m68k/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/m68k/include/asm/Kbuild
@@ -2,6 +2,5 @@
 generated-y += syscall_table.h
 generic-y += extable.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += spinlock.h
--- a/arch/microblaze/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/microblaze/include/asm/Kbuild
@@ -2,7 +2,6 @@
 generated-y += syscall_table.h
 generic-y += extable.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += syscalls.h
--- a/arch/mips/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/mips/include/asm/Kbuild
@@ -6,7 +6,6 @@ generated-y += syscall_table_64_n64.h
 generated-y += syscall_table_64_o32.h
 generic-y += export.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += qrwlock.h
--- a/arch/nds32/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/nds32/include/asm/Kbuild
@@ -4,6 +4,5 @@ generic-y += cmpxchg.h
 generic-y += export.h
 generic-y += gpio.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += parport.h
 generic-y += user.h
--- a/arch/openrisc/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/openrisc/include/asm/Kbuild
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 generic-y += extable.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += qspinlock_types.h
 generic-y += qspinlock.h
--- a/arch/parisc/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/parisc/include/asm/Kbuild
@@ -3,6 +3,5 @@ generated-y += syscall_table_32.h
 generated-y += syscall_table_64.h
 generated-y += syscall_table_c32.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += user.h
--- a/arch/powerpc/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/powerpc/include/asm/Kbuild
@@ -5,7 +5,6 @@ generated-y += syscall_table_c32.h
 generated-y += syscall_table_spu.h
 generic-y += export.h
 generic-y += kvm_types.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
 generic-y += vtime.h
--- a/arch/riscv/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/riscv/include/asm/Kbuild
@@ -3,6 +3,5 @@ generic-y += early_ioremap.h
 generic-y += extable.h
 generic-y += flat.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
--- a/arch/s390/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/s390/include/asm/Kbuild
@@ -7,5 +7,4 @@ generated-y += unistd_nr.h
 generic-y += asm-offsets.h
 generic-y += export.h
 generic-y += kvm_types.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
--- a/arch/sh/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/sh/include/asm/Kbuild
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 generated-y += syscall_table.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
--- a/arch/sparc/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/sparc/include/asm/Kbuild
@@ -6,5 +6,4 @@ generated-y += syscall_table_64.h
 generated-y += syscall_table_c32.h
 generic-y += export.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
--- a/arch/x86/include/asm/local64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/local64.h>
--- a/arch/xtensa/include/asm/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/arch/xtensa/include/asm/Kbuild
@@ -2,7 +2,6 @@
 generated-y += syscall_table.h
 generic-y += extable.h
 generic-y += kvm_para.h
-generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += param.h
 generic-y += qrwlock.h
--- a/include/asm-generic/Kbuild~local64h-make-asm-local64h-mandatory
+++ a/include/asm-generic/Kbuild
@@ -34,6 +34,7 @@ mandatory-y += kmap_size.h
 mandatory-y += kprobes.h
 mandatory-y += linkage.h
 mandatory-y += local.h
+mandatory-y += local64.h
 mandatory-y += mm-arch-hooks.h
 mandatory-y += mmiowb.h
 mandatory-y += mmu.h
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
lib-linear_ranges-fix-repeated-words-one-typo.patch

