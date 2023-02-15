Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04D1C636CC
	for <mm-commits@archiver.kernel.org>; Wed, 15 Feb 2023 20:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBOUXO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Feb 2023 15:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjBOUXJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2023 15:23:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D532D168
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 12:23:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB6F161D71
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2023 20:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533D5C433EF;
        Wed, 15 Feb 2023 20:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676492587;
        bh=MV9x2nkYMmXcq1zWNb1XZG8xeCvLadXU6dG7wYoaCHA=;
        h=Date:To:From:Subject:From;
        b=HX9Tz6Woa8bLOXOf3lsYSzeuwh/1hbutSTCZQn4IBDd36litt09KLcPb0Z+kl1llR
         4OCrfutyEjgZHYEkOUh5Fw0Sa33Duv3oSOZVM+Rhsxg42T4BI3lXD7rOKEU0dKRXnE
         xWFU/DH+BAqiLdBNMCQk2yExmubk2V/kpQPq/u3I=
Date:   Wed, 15 Feb 2023 12:23:06 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, peterz@infradead.org,
        Kuan-Ying.Lee@mediatek.com, jpoimboe@kernel.org, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-disable-ftrace-in-kmsan-core-code.patch added to mm-unstable branch
Message-Id: <20230215202307.533D5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: disable ftrace in kmsan core code
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-disable-ftrace-in-kmsan-core-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-disable-ftrace-in-kmsan-core-code.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 mm/kmsan/Makefile |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

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

maple_tree-reduce-stack-usage-with-gcc-9-and-earlier.patch
kasan-mark-addr_has_metadata-__always_inline.patch
kmsan-disable-ftrace-in-kmsan-core-code.patch
objtool-add-uaccess-exceptions-for-__tsan_volatile_read-write.patch

