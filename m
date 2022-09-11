Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34B4C6FA83
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiIKXXQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIKXXH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:23:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0A424F3D
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 16:23:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1A8161029
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 23:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED75AC4347C;
        Sun, 11 Sep 2022 23:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938586;
        bh=erPeQVm0b2OtiwVY4RWX15tRka7gVYx6I7tL+qfoa5k=;
        h=Date:To:From:Subject:From;
        b=TJeYK//hBy8siy1FaCGgejXTvPAL82vbo9F7eiYtqW9Dy760f82v2YMsGoIJ1RAJ8
         ULnFvCv8TPg/luCHLFpP3Jx6fzvDGizEGmlrPbsrZeSSwVf26HRhe/Ij1cIgySE+rc
         8XPVdVFmtC2H2/TbnN5YobIJXmKwlQgVk4oF4b2o=
Date:   Sun, 11 Sep 2022 16:23:05 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, luto@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de,
        anshuman.khandual@arm.com, naohiro.aota@wdc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-mm-disable-instrumentations-of-mm-pgprotc.patch removed from -mm tree
Message-Id: <20220911232305.ED75AC4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/mm: disable instrumentations of mm/pgprot.c
has been removed from the -mm tree.  Its filename was
     x86-mm-disable-instrumentations-of-mm-pgprotc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: x86/mm: disable instrumentations of mm/pgprot.c
Date: Wed, 24 Aug 2022 17:47:26 +0900

Commit 4867fbbdd6b3 ("x86/mm: move protection_map[] inside the platform")
moved accesses to protection_map[] from mem_encrypt_amd.c to pgprot.c.  As
a result, the accesses are now targets of KASAN (and other
instrumentations), leading to the crash during the boot process.

Disable the instrumentations for pgprot.c like commit 67bb8e999e0a
("x86/mm: Disable various instrumentations of mm/mem_encrypt.c and
mm/tlb.c").

Before this patch, my AMD machine cannot boot since v6.0-rc1 with KASAN
enabled, without anything printed.  After the change, it successfully
boots up.

Fixes: 4867fbbdd6b3 ("x86/mm: move protection_map[] inside the platform")
Link: https://lkml.kernel.org/r/20220824084726.2174758-1-naohiro.aota@wdc.com
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/mm/Makefile~x86-mm-disable-instrumentations-of-mm-pgprotc
+++ a/arch/x86/mm/Makefile
@@ -4,10 +4,12 @@ KCOV_INSTRUMENT_tlb.o			:= n
 KCOV_INSTRUMENT_mem_encrypt.o		:= n
 KCOV_INSTRUMENT_mem_encrypt_amd.o	:= n
 KCOV_INSTRUMENT_mem_encrypt_identity.o	:= n
+KCOV_INSTRUMENT_pgprot.o		:= n
 
 KASAN_SANITIZE_mem_encrypt.o		:= n
 KASAN_SANITIZE_mem_encrypt_amd.o	:= n
 KASAN_SANITIZE_mem_encrypt_identity.o	:= n
+KASAN_SANITIZE_pgprot.o		:= n
 
 # Disable KCSAN entirely, because otherwise we get warnings that some functions
 # reference __initdata sections.
@@ -17,6 +19,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_mem_encrypt.o		= -pg
 CFLAGS_REMOVE_mem_encrypt_amd.o		= -pg
 CFLAGS_REMOVE_mem_encrypt_identity.o	= -pg
+CFLAGS_REMOVE_pgprot.o			= -pg
 endif
 
 obj-y				:=  init.o init_$(BITS).o fault.o ioremap.o extable.o mmap.o \
_

Patches currently in -mm which might be from naohiro.aota@wdc.com are


