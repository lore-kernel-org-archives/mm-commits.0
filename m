Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7698BEB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 18:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjGDSLy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 14:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjGDSLx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 14:11:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18BEDD
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 11:11:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EAD061329
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 18:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98382C433C7;
        Tue,  4 Jul 2023 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688494310;
        bh=TMM13x2WhyzaZBHATrlBRr3kkx5Mjbv2RpcANomy9qw=;
        h=Date:To:From:Subject:From;
        b=pekgIHK5hU+ZFe2HwnmkB08potHeAP/2wG8WeFRLo9kNN/X/98FlVsp1wP3kbmmOH
         N07ufkiGAkbjC6WiLSUiwWzt1k1LWQoXTQZeH1/MzxOZMKrdbdNpbgLmJR5mX91CxM
         MasCDXx67KdmE0wPd04CaVf/0HZPqdbYKEKRZw18=
Date:   Tue, 04 Jul 2023 11:11:49 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, thuth@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-ia64-include-remove-config_ia64_debug_cmpxchg-from-uapi-header.patch added to mm-nonmm-unstable branch
Message-Id: <20230704181150.98382C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/include: remove CONFIG_IA64_DEBUG_CMPXCHG from uapi header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arch-ia64-include-remove-config_ia64_debug_cmpxchg-from-uapi-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-ia64-include-remove-config_ia64_debug_cmpxchg-from-uapi-header.patch

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

arch-ia64-include-remove-config_ia64_debug_cmpxchg-from-uapi-header.patch

