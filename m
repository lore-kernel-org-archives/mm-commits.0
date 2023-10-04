Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5FDE936E2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245127AbjJDUYD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244876AbjJDUXO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E3BD8
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76549C433C8;
        Wed,  4 Oct 2023 20:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450990;
        bh=ZnEb8A15jW9bQFDLf+2BRxAU2k+o3pGNza/jYtusHWI=;
        h=Date:To:From:Subject:From;
        b=TieKdn4gdmQnFom9iZrNwr+ebAIWEpg2I4/nTBTYdZDceUdv+tMV3KrOZoFsOwual
         yzgVyD7u+cTBSaQCK707gUTPt293FbyeQ108P60hOPDi9uhm5CohJfkO4Nuen7leLy
         vYNpVVgi+RoNFJ4LCKER3OfrOjcHYsHaXyMg1wes=
Date:   Wed, 04 Oct 2023 13:23:09 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code-fix.patch removed from -mm tree
Message-Id: <20231004202310.76549C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86: kdump: move crash_low_size_default() code into <asm/crash_core.h>
has been removed from the -mm tree.  Its filename was
     x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code-fix.patch

This patch was dropped because it was folded into x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: x86: kdump: move crash_low_size_default() code into <asm/crash_core.h>
Content-type: text/plain

LKP reported below error with 'W=1' and randconfig.
=========
>> arch/x86/kernel/setup.c:476:15: warning: no previous prototype for function 'crash_low_size_default'
[-Wmissing-prototypes]
   unsigned long crash_low_size_default(void)
                 ^
   arch/x86/kernel/setup.c:476:1: note: declare 'static' if the function is not intended to be used outside of this
translation unit
   unsigned long crash_low_size_default(void)
   ^
   static
   1 warning generated.
=========

In that config, CONFIG_KEXEC is not set. So all KEXEC/CRASH related
configs depending on CONFIG_KEXEC are all unset. Then the declaration
in <asm/crash_core.h> won't be seen. Finally the warning is caused.

So move the code of crash_low_size_default() into x86's
<asm/crash_core.h>, and make it static inline to fix the warning.

Link: https://lkml.kernel.org/r/ZQpeAjOmuMJBFw1/@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309141534.moH4dTcz-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/crash_core.h |   10 +++++++++-
 arch/x86/kernel/setup.c           |   12 ------------
 2 files changed, 9 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/crash_core.h~x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code-fix
+++ a/arch/x86/include/asm/crash_core.h
@@ -18,6 +18,7 @@
  * no good way to detect the paging mode of the target kernel which will be
  * loaded for dumping.
  */
+extern unsigned long swiotlb_size_or_default(void);
 
 #ifdef CONFIG_X86_32
 # define CRASH_ADDR_LOW_MAX     SZ_512M
@@ -29,6 +30,13 @@
 
 # define DEFAULT_CRASH_KERNEL_LOW_SIZE crash_low_size_default()
 
-extern unsigned long crash_low_size_default(void);
+static inline unsigned long crash_low_size_default(void)
+{
+#ifdef CONFIG_X86_64
+	return max(swiotlb_size_or_default() + (8UL << 20), 256UL << 20);
+#else
+	return 0;
+#endif
+}
 
 #endif /* _X86_CRASH_CORE_H */
--- a/arch/x86/kernel/setup.c~x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code-fix
+++ a/arch/x86/kernel/setup.c
@@ -466,18 +466,6 @@ static void __init memblock_x86_reserve_
 	}
 }
 
-/*
- * --------- Crashkernel reservation ------------------------------
- */
-unsigned long crash_low_size_default(void)
-{
-#ifdef CONFIG_X86_64
-	return max(swiotlb_size_or_default() + (8UL << 20), 256UL << 20);
-#else
-	return 0;
-#endif
-}
-
 static void __init arch_reserve_crashkernel(void)
 {
 	unsigned long long crash_base, crash_size, low_size = 0;
_

Patches currently in -mm which might be from bhe@redhat.com are

crash_corec-remove-unnecessary-parameter-of-function.patch
crash_core-change-the-prototype-of-function-parse_crashkernel.patch
crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch
crash_core-add-generic-function-to-do-reservation.patch
crash_core-move-crashk_res-definition-into-crash_corec.patch
x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code.patch
arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash_corec-remove-unneeded-functions.patch

