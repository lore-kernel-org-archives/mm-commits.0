Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F42C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1997823407
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgLPRMH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgLPRMH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:07 -0500
Date:   Wed, 16 Dec 2020 09:11:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138687;
        bh=RDcDw5s2X1kCamW6Mc2Ct+59C+sc946KzxvPmjdBsTE=;
        h=From:To:Subject:From;
        b=KR3C/0mui71cTaUP3IvlPptHAHhRpXfR2HYFbHnSd1UPymubsbA2S9krz6JOL8NkV
         z0OeCGnh05hAN/If/7F7Q1ohDedJCbyR0dSOC1XpEa0x6QzQ5OauuYNQDw+XKPakDt
         JYOPCFgqnxeCkVIYXfAlLOJL9NzoUSU3aUGpCj9Y=
From:   akpm@linux-foundation.org
To:     ardb@kernel.org, arnd@arndb.de, aryabinin@virtuozzo.com,
        dvyukov@google.com, elver@google.com, georgepope@android.com,
        herbert@gondor.apana.org.au, keescook@chromium.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, oberpar@linux.ibm.com,
        rdunlap@infradead.org, sfr@canb.auug.org.au,
        torvalds@linux-foundation.org
Subject:  [merged] ubsan-enable-for-allconfig-builds.patch removed
 from -mm tree
Message-ID: <20201216171126.e2ctRZkSG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: enable for all*config builds
has been removed from the -mm tree.  Its filename was
     ubsan-enable-for-allconfig-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: enable for all*config builds

With UBSAN_OBJECT_SIZE disabled for GCC, only UBSAN_ALIGNMENT remained a
noisy UBSAN option.  Disable it for COMPILE_TEST so the rest of UBSAN can
be used for full all*config builds or other large combinations.

[sfr@canb.auug.org.au: add .data..Lubsan_data*/.data..Lubsan_type* sections explicitly]
  Link: https://lkml.kernel.org/r/20201208230157.42c42789@canb.auug.org.au
Link: https://lore.kernel.org/lkml/CAHk-=wgXW=YLxGN0QVpp-1w5GDd2pf1W-FqY15poKzoVfik2qA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20201203004437.389959-6-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: George Popescu <georgepope@android.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vmlinux.lds.S |    4 ++++
 lib/Kconfig.ubsan                 |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/vmlinux.lds.S~ubsan-enable-for-allconfig-builds
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -313,6 +313,10 @@ SECTIONS
 #else
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		DATA_DATA
+#ifdef CONFIG_UBSAN
+		*(.data..Lubsan_data*)
+		*(.data..Lubsan_type*)
+#endif
 		*(.data.rel*)
 		*(.toc1)
 		*(.branch_lt)
--- a/lib/Kconfig.ubsan~ubsan-enable-for-allconfig-builds
+++ a/lib/Kconfig.ubsan
@@ -130,7 +130,6 @@ config UBSAN_ENUM
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
 	depends on ARCH_HAS_UBSAN_SANITIZE_ALL
-	depends on !COMPILE_TEST
 	default y
 	help
 	  This option activates instrumentation for the entire kernel.
@@ -142,7 +141,7 @@ config UBSAN_SANITIZE_ALL
 config UBSAN_ALIGNMENT
 	bool "Enable checks for pointers alignment"
 	default !HAVE_EFFICIENT_UNALIGNED_ACCESS
-	depends on !UBSAN_TRAP
+	depends on !UBSAN_TRAP && !COMPILE_TEST
 	depends on $(cc-option,-fsanitize=alignment)
 	help
 	  This option enables the check of unaligned memory accesses.
_

Patches currently in -mm which might be from keescook@chromium.org are


