Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53622C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 20:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiD0UdJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 16:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236854AbiD0Ucz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 16:32:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439EBB42C0
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 13:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D349561C58
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 20:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC67C385A9;
        Wed, 27 Apr 2022 20:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651091381;
        bh=I1gi3IwiRRVnKeXqIJt7dkM7ioD+8++Zca3YsATEXX8=;
        h=Date:To:From:Subject:From;
        b=V7W2p28CqVkfWi/eqGhgmvLBd8o4gAtPtVSHOOq7FtUmZfRGBpo8J3Vn5Y9RehYA0
         +uX9JK0sZ3Ib95YFKnchw2eBPZG0YVNjaeeE0Go0PJbhQCwdgFQMmTTkTQ2UJIbEVG
         AQouDdPeUkZFNyUtqILZFFwaG6u2iCRYHcOniLb4=
Date:   Wed, 27 Apr 2022 13:29:40 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, ryabinin.a.a@gmail.com,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        keescook@chromium.org, iamjoonsoo.kim@lge.com,
        herbert@gondor.apana.org.au, glider@google.com,
        ebiederm@xmission.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, 42.hyeyoo@gmail.com, pcc@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + printk-stop-including-cacheh-from-printkh.patch added to -mm tree
Message-Id: <20220427202941.2DC67C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: printk: stop including cache.h from printk.h
has been added to the -mm tree.  Its filename is
     printk-stop-including-cacheh-from-printkh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/printk-stop-including-cacheh-from-printkh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/printk-stop-including-cacheh-from-printkh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

printk-stop-including-cacheh-from-printkh.patch
mm-make-minimum-slab-alignment-a-runtime-property.patch

