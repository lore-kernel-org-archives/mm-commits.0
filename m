Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220ECC77B7A
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 21:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjEQVGG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 17:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjEQVGF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 17:06:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7927ABF
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 14:06:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A236064B54
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 21:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D16C4339B;
        Wed, 17 May 2023 21:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684357560;
        bh=mQYOXzBdte0Nj+tNMLK5Bh2pXjaYN1ykHfHnhDmslZ0=;
        h=Date:To:From:Subject:From;
        b=qnxMfCIhjjHbvARQQYNFtDJrdNberzIk4l3DtH4ETINHcPqfPQxpd3IFyqk0MY4UH
         rcqy69aK1Xpk6x2GBfFl0xvf7qoODlxnKg0SSjurZ0hcjUuD6B4AY5tg4fRZ28yqHx
         PM7AuZGxA5gY/eFEL4bGRgUcibcr2X5/Tp2X+IcA=
Date:   Wed, 17 May 2023 14:05:59 -0700
To:     mm-commits@vger.kernel.org, rongtao@cestc.cn, dvyukov@google.com,
        andreyknvl@gmail.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-add-prototypes-for-helper-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20230517210600.04D16C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: add prototypes for helper functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-add-prototypes-for-helper-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-add-prototypes-for-helper-functions.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: kcov: add prototypes for helper functions
Date: Wed, 17 May 2023 14:49:25 +0200

A number of internal functions in kcov are only called from generated code
and don't technically need a declaration, but 'make W=1' warns about
global symbols without a prototype:

kernel/kcov.c:199:14: error: no previous prototype for '__sanitizer_cov_trace_pc' [-Werror=missing-prototypes]
kernel/kcov.c:264:14: error: no previous prototype for '__sanitizer_cov_trace_cmp1' [-Werror=missing-prototypes]
kernel/kcov.c:270:14: error: no previous prototype for '__sanitizer_cov_trace_cmp2' [-Werror=missing-prototypes]
kernel/kcov.c:276:14: error: no previous prototype for '__sanitizer_cov_trace_cmp4' [-Werror=missing-prototypes]
kernel/kcov.c:282:14: error: no previous prototype for '__sanitizer_cov_trace_cmp8' [-Werror=missing-prototypes]
kernel/kcov.c:288:14: error: no previous prototype for '__sanitizer_cov_trace_const_cmp1' [-Werror=missing-prototypes]
kernel/kcov.c:295:14: error: no previous prototype for '__sanitizer_cov_trace_const_cmp2' [-Werror=missing-prototypes]
kernel/kcov.c:302:14: error: no previous prototype for '__sanitizer_cov_trace_const_cmp4' [-Werror=missing-prototypes]
kernel/kcov.c:309:14: error: no previous prototype for '__sanitizer_cov_trace_const_cmp8' [-Werror=missing-prototypes]
kernel/kcov.c:316:14: error: no previous prototype for '__sanitizer_cov_trace_switch' [-Werror=missing-prototypes]

Adding prototypes for these in a header solves that problem, but now there
is a mismatch between the built-in type and the prototype on 64-bit
architectures because they expect some functions to take a 64-bit
'unsigned long' argument rather than an 'unsigned long long' u64 type:

include/linux/kcov.h:84:6: error: conflicting types for built-in function '__sanitizer_cov_trace_switch'; expected 'void(long long unsigned int,  void *)' [-Werror=builtin-declaration-mismatch]
   84 | void __sanitizer_cov_trace_switch(u64 val, u64 *cases);
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Avoid this as well with a custom type definition.

Link: https://lkml.kernel.org/r/20230517124944.929997-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Rong Tao <rongtao@cestc.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcov.h |   17 +++++++++++++++++
 kernel/kcov.c        |    7 ++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/include/linux/kcov.h~kcov-add-prototypes-for-helper-functions
+++ a/include/linux/kcov.h
@@ -72,6 +72,23 @@ static inline void kcov_remote_stop_soft
 		kcov_remote_stop();
 }
 
+#ifdef CONFIG_64BIT
+typedef unsigned long kcov_u64;
+#else
+typedef unsigned long long kcov_u64;
+#endif
+
+void __sanitizer_cov_trace_pc(void);
+void __sanitizer_cov_trace_cmp1(u8 arg1, u8 arg2);
+void __sanitizer_cov_trace_cmp2(u16 arg1, u16 arg2);
+void __sanitizer_cov_trace_cmp4(u32 arg1, u32 arg2);
+void __sanitizer_cov_trace_cmp8(kcov_u64 arg1, kcov_u64 arg2);
+void __sanitizer_cov_trace_const_cmp1(u8 arg1, u8 arg2);
+void __sanitizer_cov_trace_const_cmp2(u16 arg1, u16 arg2);
+void __sanitizer_cov_trace_const_cmp4(u32 arg1, u32 arg2);
+void __sanitizer_cov_trace_const_cmp8(kcov_u64 arg1, kcov_u64 arg2);
+void __sanitizer_cov_trace_switch(kcov_u64 val, void *cases);
+
 #else
 
 static inline void kcov_task_init(struct task_struct *t) {}
--- a/kernel/kcov.c~kcov-add-prototypes-for-helper-functions
+++ a/kernel/kcov.c
@@ -279,7 +279,7 @@ void notrace __sanitizer_cov_trace_cmp4(
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_cmp4);
 
-void notrace __sanitizer_cov_trace_cmp8(u64 arg1, u64 arg2)
+void notrace __sanitizer_cov_trace_cmp8(kcov_u64 arg1, kcov_u64 arg2)
 {
 	write_comp_data(KCOV_CMP_SIZE(3), arg1, arg2, _RET_IP_);
 }
@@ -306,16 +306,17 @@ void notrace __sanitizer_cov_trace_const
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp4);
 
-void notrace __sanitizer_cov_trace_const_cmp8(u64 arg1, u64 arg2)
+void notrace __sanitizer_cov_trace_const_cmp8(kcov_u64 arg1, kcov_u64 arg2)
 {
 	write_comp_data(KCOV_CMP_SIZE(3) | KCOV_CMP_CONST, arg1, arg2,
 			_RET_IP_);
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp8);
 
-void notrace __sanitizer_cov_trace_switch(u64 val, u64 *cases)
+void notrace __sanitizer_cov_trace_switch(kcov_u64 val, void *arg)
 {
 	u64 i;
+	u64 *cases = arg;
 	u64 count = cases[0];
 	u64 size = cases[1];
 	u64 type = KCOV_CMP_CONST;
_

Patches currently in -mm which might be from arnd@arndb.de are

radix-tree-move-declarations-to-header.patch
decompressor-provide-missing-prototypes.patch
kasan-add-kasan_tag_mismatch-prototype.patch
kasan-use-internal-prototypes-matching-gcc-13-builtins.patch
mm-percpu-unhide-pcpu_embed_first_chunk-prototype.patch
mm-page_poison-always-declare-__kernel_map_pages-function.patch
mm-sparse-mark-populate_section_memmap-static.patch
lib-devmem_is_allowed-include-linux-ioh.patch
locking-add-lockevent_read-prototype.patch
panic-hide-unused-global-functions.patch
panic-make-function-declarations-visible.patch
kunit-include-debugfs-header-file.patch
init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch
kcov-add-prototypes-for-helper-functions.patch

