Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18C6C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbiEJEWK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbiEJEUh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFFE2497F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40FEFB81B0F
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78C2C385C5;
        Tue, 10 May 2022 04:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156141;
        bh=Jv97Da2oObQ2j38bCJsGO1SEbhk6YDaymR3oEsxu9g4=;
        h=Date:To:From:Subject:From;
        b=AUVk45Pe7Br/8pJoaGcFDQRZ42hwoixB0l+MlnPDGZ5Iai9nKv9JZOZFX8HpnRWL0
         SEli2xScLryp4kROtlCtL+m/70wYUiSEInQ88ia0Jn0jluld8J8kiSftSygibT3mKe
         rzL9BEV2Su86bRi0HNeEi2e3g9mmcUli4laI4H2k=
Date:   Mon, 09 May 2022 21:15:40 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, ryabinin.a.a@gmail.com,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        keescook@chromium.org, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, glider@google.com,
        ebiederm@xmission.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, 42.hyeyoo@gmail.com, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] printk-stop-including-cacheh-from-printkh.patch removed from -mm tree
Message-Id: <20220510041540.E78C2C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: printk: stop including cache.h from printk.h
has been removed from the -mm tree.  Its filename was
     printk-stop-including-cacheh-from-printkh.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: printk: stop including cache.h from printk.h

An inclusion of cache.h in printk.h was added in 2014 in commit
c28aa1f0a847 ("printk/cache: mark printk_once test variable
__read_mostly") in order to bring in the definition of __read_mostly.  The
usage of __read_mostly was later removed in commit 3ec25826ae33 ("printk:
Tie printk_once / printk_deferred_once into .data.once for reset") which
made the inclusion of cache.h unnecessary, so remove it.

We have a small amount of code that depended on the inclusion of cache.h
from printk.h; fix that code to include the appropriate header.

This fixes a circular inclusion on arm64 (linux/printk.h -> linux/cache.h
-> asm/cache.h -> linux/kasan-enabled.h -> linux/static_key.h ->
linux/jump_label.h -> linux/bug.h -> asm/bug.h -> linux/printk.h) that
would otherwise be introduced by the next patch.

Build tested using {allyesconfig,defconfig} x {arm64,x86_64}.

Link: https://linux-review.googlesource.com/id/I8fd51f72c9ef1f2d6afd3b2cbc875aa4792c1fba
Link: https://lkml.kernel.org/r/20220427195820.1716975-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/mte-kasan.h |    1 +
 arch/arm64/include/asm/percpu.h    |    1 +
 arch/csky/include/asm/processor.h  |    2 +-
 drivers/firmware/smccc/kvm_guest.c |    1 +
 include/linux/printk.h             |    1 -
 kernel/bpf/bpf_lru_list.h          |    1 +
 6 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/mte-kasan.h~printk-stop-including-cacheh-from-printkh
+++ a/arch/arm64/include/asm/mte-kasan.h
@@ -6,6 +6,7 @@
 #define __ASM_MTE_KASAN_H
 
 #include <asm/compiler.h>
+#include <asm/cputype.h>
 #include <asm/mte-def.h>
 
 #ifndef __ASSEMBLY__
--- a/arch/arm64/include/asm/percpu.h~printk-stop-including-cacheh-from-printkh
+++ a/arch/arm64/include/asm/percpu.h
@@ -10,6 +10,7 @@
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 #include <asm/stack_pointer.h>
+#include <asm/sysreg.h>
 
 static inline void set_my_cpu_offset(unsigned long off)
 {
--- a/arch/csky/include/asm/processor.h~printk-stop-including-cacheh-from-printkh
+++ a/arch/csky/include/asm/processor.h
@@ -4,9 +4,9 @@
 #define __ASM_CSKY_PROCESSOR_H
 
 #include <linux/bitops.h>
+#include <linux/cache.h>
 #include <asm/ptrace.h>
 #include <asm/current.h>
-#include <asm/cache.h>
 #include <abi/reg_ops.h>
 #include <abi/regdef.h>
 #include <abi/switch_context.h>
--- a/drivers/firmware/smccc/kvm_guest.c~printk-stop-including-cacheh-from-printkh
+++ a/drivers/firmware/smccc/kvm_guest.c
@@ -4,6 +4,7 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/bitmap.h>
+#include <linux/cache.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 
--- a/include/linux/printk.h~printk-stop-including-cacheh-from-printkh
+++ a/include/linux/printk.h
@@ -6,7 +6,6 @@
 #include <linux/init.h>
 #include <linux/kern_levels.h>
 #include <linux/linkage.h>
-#include <linux/cache.h>
 #include <linux/ratelimit_types.h>
 #include <linux/once_lite.h>
 
--- a/kernel/bpf/bpf_lru_list.h~printk-stop-including-cacheh-from-printkh
+++ a/kernel/bpf/bpf_lru_list.h
@@ -4,6 +4,7 @@
 #ifndef __BPF_LRU_LIST_H_
 #define __BPF_LRU_LIST_H_
 
+#include <linux/cache.h>
 #include <linux/list.h>
 #include <linux/spinlock_types.h>
 
_

Patches currently in -mm which might be from pcc@google.com are


