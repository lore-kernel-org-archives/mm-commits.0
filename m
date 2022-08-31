Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2CDECAAA1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 00:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiHaAqG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 20:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiHaAph (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 20:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E63AB2CEB
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 17:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 447586183D
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 00:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D356C433D6;
        Wed, 31 Aug 2022 00:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661906612;
        bh=WpDZ0J+q2S0tUUkgJ7ypEF8YIAr+xyvuED+yg1yY9Co=;
        h=Date:To:From:Subject:From;
        b=GW6EIMJYeaGvSWsMllVfwB3wpqX6sRtTsOZMb45wuWy03JU1/3qbb8Arvi2DSB54T
         afE0xoTnfEWRC8NXKgCg1ADcIv1JHuo5A9RASehwqDdmUiKbdzyqGXjXtZOOIkozgw
         55tpXBnSrgz9Szkyju+Yt5QM8oIW808AmEjE+XCQ=
Date:   Tue, 30 Aug 2022 17:43:31 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, luto@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de,
        anshuman.khandual@arm.com, naohiro.aota@wdc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-disable-instrumentations-of-mm-pgprotc.patch added to mm-hotfixes-unstable branch
Message-Id: <20220831004332.8D356C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm: disable instrumentations of mm/pgprot.c
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-mm-disable-instrumentations-of-mm-pgprotc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-disable-instrumentations-of-mm-pgprotc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
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

x86-mm-disable-instrumentations-of-mm-pgprotc.patch

