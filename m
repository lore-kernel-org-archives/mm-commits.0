Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C904BC7EE2F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjFJApn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjFJAph (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87413AA7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EAF2651C3
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DD2C433EF;
        Sat, 10 Jun 2023 00:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357926;
        bh=fRmi5nJUKG6tup3hp3p89uv4209XKbfNBcHKlLOoktQ=;
        h=Date:To:From:Subject:From;
        b=1ezfGeuN447kPeEK6nrdtYT/XOZfVXMkj422jSygDrz1V4W/0CGmZ3ETxvhLP0fGs
         e/zJh68Aks6AMEh01iA/1wMCck7tqz6zwrU40ES3cPHVF7HyzhccNCiAXtmnquDVbN
         CDris0STXBVnx7WjVA1fzaW8NgDysV0csW95ojbU=
Date:   Fri, 09 Jun 2023 17:45:25 -0700
To:     mm-commits@vger.kernel.org, rongtao@cestc.cn, dvyukov@google.com,
        andreyknvl@gmail.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-add-prototypes-for-helper-functions.patch removed from -mm tree
Message-Id: <20230610004526.94DD2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kcov: add prototypes for helper functions
has been removed from the -mm tree.  Its filename was
     kcov-add-prototypes-for-helper-functions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

