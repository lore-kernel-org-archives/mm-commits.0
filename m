Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FDCC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiATCKW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiATCKW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228A4C061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6728B81CA0
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F972C004E1;
        Thu, 20 Jan 2022 02:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644619;
        bh=TXPg2izwNFFwk/Qtfdn6rY5yc7l771bViwUiOOGGtKc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ybiNBd3v9l/xSsBt4MK3M7sCM94QIbNezy8gEzZDuoq36jIJfpPRJyWj5jO0rwGQz
         5CTODL74txiZak+LyW05Oj3mKCPb7MEmtatHwcKZhAgifhkgq2A9DktjnsDd+KC4+b
         ZWrekaA7tnymLUA+dUenY5fZzVir7nbZGpHEKQMg=
Date:   Wed, 19 Jan 2022 18:10:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daniel.thompson@linaro.org,
        dvyukov@google.com, elver@google.com, linux-mm@kvack.org,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, paulmck@kernel.org,
        quic_qiancai@quicinc.com, rdunlap@infradead.org,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org
Subject:  [patch 49/55] configs: introduce debug.config for CI-like
 setup
Message-ID: <20220120021018.vKJjaK6LS%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qian Cai <quic_qiancai@quicinc.com>
Subject: configs: introduce debug.config for CI-like setup

Some general debugging features like kmemleak, KASAN, lockdep, UBSAN etc
help fix many viruses like a microscope.  On the other hand, those
features are scatter around and mixed up with more situational debugging
options making them difficult to consume properly.  This cold help amplify
the general debugging/testing efforts and help establish sensitive default
values for those options across the broad.  This could also help different
distros to collaborate on maintaining debug-flavored kernels.

The config is based on years' experiences running daily CI inside the
largest enterprise Linux distro company to seek regressions on linux-next
builds on different bare-metal and virtual platforms.  It can be used for
example,

$ make ARCH=arm64 defconfig debug.config

Since KASAN and KCSAN can't be enabled together, we will need to create a
separate one for KCSAN later as well.

Link: https://lkml.kernel.org/r/20211115134754.7334-1-quic_qiancai@quicinc.com
Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/debug.config |  105 ++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

--- /dev/null
+++ a/kernel/configs/debug.config
@@ -0,0 +1,105 @@
+# The config is based on running daily CI for enterprise Linux distros to
+# seek regressions on linux-next builds on different bare-metal and virtual
+# platforms. It can be used for example,
+#
+# $ make ARCH=arm64 defconfig debug.config
+#
+# Keep alphabetically sorted inside each section.
+#
+# printk and dmesg options
+#
+CONFIG_DEBUG_BUGVERBOSE=y
+CONFIG_DYNAMIC_DEBUG=y
+CONFIG_PRINTK_CALLER=y
+CONFIG_PRINTK_TIME=y
+CONFIG_SYMBOLIC_ERRNAME=y
+#
+# Compile-time checks and compiler options
+#
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_SECTION_MISMATCH=y
+CONFIG_FRAME_WARN=2048
+CONFIG_SECTION_MISMATCH_WARN_ONLY=y
+#
+# Generic Kernel Debugging Instruments
+#
+# CONFIG_UBSAN_ALIGNMENT is not set
+# CONFIG_UBSAN_DIV_ZERO is not set
+# CONFIG_UBSAN_TRAP is not set
+# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
+CONFIG_DEBUG_FS=y
+CONFIG_DEBUG_FS_ALLOW_ALL=y
+CONFIG_DEBUG_IRQFLAGS=y
+CONFIG_UBSAN=y
+CONFIG_UBSAN_BOOL=y
+CONFIG_UBSAN_BOUNDS=y
+CONFIG_UBSAN_ENUM=y
+CONFIG_UBSAN_SHIFT=y
+CONFIG_UBSAN_UNREACHABLE=y
+#
+# Memory Debugging
+#
+# CONFIG_DEBUG_PAGEALLOC is not set
+# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
+# CONFIG_DEBUG_RODATA_TEST is not set
+# CONFIG_DEBUG_WX is not set
+# CONFIG_KFENCE is not set
+# CONFIG_PAGE_POISONING is not set
+# CONFIG_SLUB_STATS is not set
+CONFIG_PAGE_EXTENSION=y
+CONFIG_PAGE_OWNER=y
+CONFIG_DEBUG_KMEMLEAK=y
+CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
+CONFIG_DEBUG_OBJECTS_FREE=y
+CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_DEBUG_OBJECTS_TIMERS=y
+CONFIG_DEBUG_OBJECTS_WORK=y
+CONFIG_DEBUG_PER_CPU_MAPS=y
+CONFIG_DEBUG_STACK_USAGE=y
+CONFIG_DEBUG_VIRTUAL=y
+CONFIG_DEBUG_VM=y
+CONFIG_DEBUG_VM_PGFLAGS=y
+CONFIG_DEBUG_VM_RB=y
+CONFIG_DEBUG_VM_VMACACHE=y
+CONFIG_GENERIC_PTDUMP=y
+CONFIG_KASAN=y
+CONFIG_KASAN_GENERIC=y
+CONFIG_KASAN_INLINE=y
+CONFIG_KASAN_VMALLOC=y
+CONFIG_PTDUMP_DEBUGFS=y
+CONFIG_SCHED_STACK_END_CHECK=y
+CONFIG_SLUB_DEBUG_ON=y
+#
+# Debug Oops, Lockups and Hangs
+#
+# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
+# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
+CONFIG_DEBUG_ATOMIC_SLEEP=y
+CONFIG_DETECT_HUNG_TASK=y
+CONFIG_PANIC_ON_OOPS=y
+CONFIG_PANIC_TIMEOUT=0
+CONFIG_SOFTLOCKUP_DETECTOR=y
+#
+# Lock Debugging (spinlocks, mutexes, etc...)
+#
+# CONFIG_PROVE_RAW_LOCK_NESTING is not set
+CONFIG_PROVE_LOCKING=y
+#
+# Debug kernel data structures
+#
+CONFIG_BUG_ON_DATA_CORRUPTION=y
+#
+# RCU Debugging
+#
+CONFIG_PROVE_RCU=y
+CONFIG_PROVE_RCU_LIST=y
+#
+# Tracers
+#
+CONFIG_BRANCH_PROFILE_NONE=y
+CONFIG_DYNAMIC_FTRACE=y
+CONFIG_FTRACE=y
+CONFIG_FUNCTION_TRACER=y
_
