Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AF3C6379F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjBTUrG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjBTUrA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:47:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14247E0
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:46:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0F3AB80DCB
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F0AC4339C;
        Mon, 20 Feb 2023 20:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676926016;
        bh=luXHMjUhdQ271fImJSwHDGuD2Qrq8Apqt9zMR9LTFYc=;
        h=Date:To:From:Subject:From;
        b=vwqDagUmOvHPja02LLjxEkOKDS/bUTren6ODuey/fW8OD/t0g/73GIkfzDyVO4UuX
         ypSoeDrBzWIKGtF1eOMo/KX3s9x/hpJTOsNZFiHyuzoX2BcGEC5V4mnl6cPwZOQZdl
         w8sAbykivo4/NY39TD0kG0VonaAXgsozBbffmMTw=
Date:   Mon, 20 Feb 2023 12:46:55 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, peterz@infradead.org,
        Kuan-Ying.Lee@mediatek.com, jpoimboe@kernel.org, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-disable-ftrace-in-kmsan-core-code.patch removed from -mm tree
Message-Id: <20230220204656.61F0AC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: disable ftrace in kmsan core code
has been removed from the -mm tree.  Its filename was
     kmsan-disable-ftrace-in-kmsan-core-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kmsan: disable ftrace in kmsan core code
Date: Wed, 15 Feb 2023 14:00:57 +0100

objtool warns about some suspicous code inside of kmsan:

vmlinux.o: warning: objtool: __msan_metadata_ptr_for_load_n+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_metadata_ptr_for_store_n+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_metadata_ptr_for_load_1+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_metadata_ptr_for_store_1+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_metadata_ptr_for_load_2+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_metadata_ptr_for_store_2+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_metadata_ptr_for_load_4+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_metadata_ptr_for_store_4+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_metadata_ptr_for_load_8+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_metadata_ptr_for_store_8+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_instrument_asm_store+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_chain_origin+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_poison_alloca+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_warning+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: __msan_get_context_state+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: kmsan_copy_to_user+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: kmsan_unpoison_memory+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: kmsan_unpoison_entry_regs+0x4: call to __fentry__() with UACCESS enabled
vmlinux.o: warning: objtool: kmsan_report+0x4: call to __fentry__() with UACCESS enabled

The Makefile contained a line to turn off ftrace for the entire directory,
but this does not work. Replace it with individual lines, matching the
approach in kasan.

Link: https://lkml.kernel.org/r/20230215130058.3836177-3-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmsan/Makefile~kmsan-disable-ftrace-in-kmsan-core-code
+++ a/mm/kmsan/Makefile
@@ -14,7 +14,13 @@ CC_FLAGS_KMSAN_RUNTIME := -fno-stack-pro
 CC_FLAGS_KMSAN_RUNTIME += $(call cc-option,-fno-conserve-stack)
 CC_FLAGS_KMSAN_RUNTIME += -DDISABLE_BRANCH_PROFILING
 
-CFLAGS_REMOVE.o = $(CC_FLAGS_FTRACE)
+# Disable ftrace to avoid recursion.
+CFLAGS_REMOVE_core.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_hooks.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_init.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_instrumentation.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_report.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_shadow.o = $(CC_FLAGS_FTRACE)
 
 CFLAGS_core.o := $(CC_FLAGS_KMSAN_RUNTIME)
 CFLAGS_hooks.o := $(CC_FLAGS_KMSAN_RUNTIME)
_

Patches currently in -mm which might be from arnd@arndb.de are


