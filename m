Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77566C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjHLWFQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjHLWFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87B01732
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64D9760DF5
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B478EC433C8;
        Sat, 12 Aug 2023 22:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877915;
        bh=N04u77prqbr3fE577zgvPeNaIF+7zcCHM+OHHMLq0f0=;
        h=Date:To:From:Subject:From;
        b=w9HRrJvj37+77kigtdGDwZxPlTGJYXSK/d2UOVb1ltf2r8781tlbx3JP+rXFseage
         T5Xzsaulug0+N67rmlOzFBjkCfRxqGny6o6Cmi8y7oRzlGRvCdlSo/ELstqrj4nkS8
         QPK3soheJMqQwuc5+/oxGxctrDKMbYsy5eoTx+z0=
Date:   Sat, 12 Aug 2023 15:05:15 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, thuth@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arch-ia64-include-remove-config_ia64_debug_cmpxchg-from-uapi-header.patch removed from -mm tree
Message-Id: <20230812220515.B478EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arch/ia64/include: remove CONFIG_IA64_DEBUG_CMPXCHG from uapi header
has been removed from the -mm tree.  Its filename was
     arch-ia64-include-remove-config_ia64_debug_cmpxchg-from-uapi-header.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Huth <thuth@redhat.com>
Subject: arch/ia64/include: remove CONFIG_IA64_DEBUG_CMPXCHG from uapi header
Date: Wed, 26 Apr 2023 08:50:32 +0200

CONFIG_* switches should not be exposed in uapi headers.  The macros that
are defined here are also only useful for the kernel code, so let's move
them to asm/cmpxchg.h instead.

The only two files that are using these macros are the headers
arch/ia64/include/asm/bitops.h and arch/ia64/include/asm/atomic.h and
these include asm/cmpxchg.h via asm/intrinsics.h, so this movement should
not cause any trouble.

Link: https://lkml.kernel.org/r/20230426065032.517693-1-thuth@redhat.com
Signed-off-by: Thomas Huth <thuth@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/cmpxchg.h      |   17 +++++++++++++++++
 arch/ia64/include/uapi/asm/cmpxchg.h |   17 -----------------
 scripts/headers_install.sh           |    1 -
 3 files changed, 17 insertions(+), 18 deletions(-)

--- a/arch/ia64/include/asm/cmpxchg.h~arch-ia64-include-remove-config_ia64_debug_cmpxchg-from-uapi-header
+++ a/arch/ia64/include/asm/cmpxchg.h
@@ -13,4 +13,21 @@
 #define arch_cmpxchg_local		arch_cmpxchg
 #define arch_cmpxchg64_local		arch_cmpxchg64
 
+#ifdef CONFIG_IA64_DEBUG_CMPXCHG
+# define CMPXCHG_BUGCHECK_DECL	int _cmpxchg_bugcheck_count = 128;
+# define CMPXCHG_BUGCHECK(v)						\
+do {									\
+	if (_cmpxchg_bugcheck_count-- <= 0) {				\
+		void *ip;						\
+		extern int _printk(const char *fmt, ...);		\
+		ip = (void *) ia64_getreg(_IA64_REG_IP);		\
+		_printk("CMPXCHG_BUGCHECK: stuck at %p on word %p\n", ip, (v));\
+		break;							\
+	}								\
+} while (0)
+#else /* !CONFIG_IA64_DEBUG_CMPXCHG */
+# define CMPXCHG_BUGCHECK_DECL
+# define CMPXCHG_BUGCHECK(v)
+#endif /* !CONFIG_IA64_DEBUG_CMPXCHG */
+
 #endif /* _ASM_IA64_CMPXCHG_H */
--- a/arch/ia64/include/uapi/asm/cmpxchg.h~arch-ia64-include-remove-config_ia64_debug_cmpxchg-from-uapi-header
+++ a/arch/ia64/include/uapi/asm/cmpxchg.h
@@ -133,23 +133,6 @@ extern long ia64_cmpxchg_called_with_bad
 #define cmpxchg64_local		cmpxchg64
 #endif
 
-#ifdef CONFIG_IA64_DEBUG_CMPXCHG
-# define CMPXCHG_BUGCHECK_DECL	int _cmpxchg_bugcheck_count = 128;
-# define CMPXCHG_BUGCHECK(v)						\
-do {									\
-	if (_cmpxchg_bugcheck_count-- <= 0) {				\
-		void *ip;						\
-		extern int _printk(const char *fmt, ...);		\
-		ip = (void *) ia64_getreg(_IA64_REG_IP);		\
-		_printk("CMPXCHG_BUGCHECK: stuck at %p on word %p\n", ip, (v));\
-		break;							\
-	}								\
-} while (0)
-#else /* !CONFIG_IA64_DEBUG_CMPXCHG */
-# define CMPXCHG_BUGCHECK_DECL
-# define CMPXCHG_BUGCHECK(v)
-#endif /* !CONFIG_IA64_DEBUG_CMPXCHG */
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _UAPI_ASM_IA64_CMPXCHG_H */
--- a/scripts/headers_install.sh~arch-ia64-include-remove-config_ia64_debug_cmpxchg-from-uapi-header
+++ a/scripts/headers_install.sh
@@ -76,7 +76,6 @@ arch/arc/include/uapi/asm/swab.h:CONFIG_
 arch/arm/include/uapi/asm/ptrace.h:CONFIG_CPU_ENDIAN_BE8
 arch/hexagon/include/uapi/asm/ptrace.h:CONFIG_HEXAGON_ARCH_VERSION
 arch/hexagon/include/uapi/asm/user.h:CONFIG_HEXAGON_ARCH_VERSION
-arch/ia64/include/uapi/asm/cmpxchg.h:CONFIG_IA64_DEBUG_CMPXCHG
 arch/m68k/include/uapi/asm/ptrace.h:CONFIG_COLDFIRE
 arch/nios2/include/uapi/asm/swab.h:CONFIG_NIOS2_CI_SWAB_NO
 arch/nios2/include/uapi/asm/swab.h:CONFIG_NIOS2_CI_SWAB_SUPPORT
_

Patches currently in -mm which might be from thuth@redhat.com are


