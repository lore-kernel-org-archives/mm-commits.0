Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF76EE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjHUUrb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjHUUrQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9264E1B3
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6433E649F4
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC880C433C7;
        Mon, 21 Aug 2023 20:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650831;
        bh=/ZODdHozJMB1uMhFRypRUNSWTBHi/KRzFo29rsDwcWg=;
        h=Date:To:From:Subject:From;
        b=yYtcSHGzUI7G+59pwpN8o+3CSt/HgTQKcJIfvhCgfP3gl64xBV/QYbG1pfjOVGaWr
         229hdip0ghG9chySxDsvM0dzzqpLfSgXobstlMotls8jZE7t7VokBWl33LBUSFoHSe
         91KLjpbB83updfAOV8FXXa8e7a1qVL+cQaUjgZHU=
Date:   Mon, 21 Aug 2023 13:47:11 -0700
To:     mm-commits@vger.kernel.org, rafael@kernel.org,
        peterz@infradead.org, linux@roeck-us.net,
        gregkh@linuxfoundation.org, bp@suse.de, deller@gmx.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lockdep-fix-static-memory-detection-even-more.patch removed from -mm tree
Message-Id: <20230821204711.BC880C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lockdep: fix static memory detection even more
has been removed from the -mm tree.  Its filename was
     lockdep-fix-static-memory-detection-even-more.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: lockdep: fix static memory detection even more
Date: Tue, 15 Aug 2023 00:31:09 +0200

On the parisc architecture, lockdep reports for all static objects which
are in the __initdata section (e.g. "setup_done" in devtmpfs,
"kthreadd_done" in init/main.c) this warning:

	INFO: trying to register non-static key.

The warning itself is wrong, because those objects are in the __initdata
section, but the section itself is on parisc outside of range from
_stext to _end, which is why the static_obj() functions returns a wrong
answer.

While fixing this issue, I noticed that the whole existing check can
be simplified a lot.
Instead of checking against the _stext and _end symbols (which include
code areas too) just check for the .data and .bss segments (since we check a
data object). This can be done with the existing is_kernel_core_data()
macro.

In addition objects in the __initdata section can be checked with
init_section_contains(), and is_kernel_rodata() allows keys to be in the
_ro_after_init section.

This partly reverts and simplifies commit bac59d18c701 ("x86/setup: Fix static
memory detection").

Link: https://lkml.kernel.org/r/ZNqrLRaOi/3wPAdp@p100
Fixes: bac59d18c701 ("x86/setup: Fix static memory detection")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/sections.h |   18 ---------------
 kernel/locking/lockdep.c        |   36 +++++++++++-------------------
 2 files changed, 14 insertions(+), 40 deletions(-)

--- a/arch/x86/include/asm/sections.h~lockdep-fix-static-memory-detection-even-more
+++ a/arch/x86/include/asm/sections.h
@@ -2,8 +2,6 @@
 #ifndef _ASM_X86_SECTIONS_H
 #define _ASM_X86_SECTIONS_H
 
-#define arch_is_kernel_initmem_freed arch_is_kernel_initmem_freed
-
 #include <asm-generic/sections.h>
 #include <asm/extable.h>
 
@@ -18,20 +16,4 @@ extern char __end_of_kernel_reserve[];
 
 extern unsigned long _brk_start, _brk_end;
 
-static inline bool arch_is_kernel_initmem_freed(unsigned long addr)
-{
-	/*
-	 * If _brk_start has not been cleared, brk allocation is incomplete,
-	 * and we can not make assumptions about its use.
-	 */
-	if (_brk_start)
-		return 0;
-
-	/*
-	 * After brk allocation is complete, space between _brk_end and _end
-	 * is available for allocation.
-	 */
-	return addr >= _brk_end && addr < (unsigned long)&_end;
-}
-
 #endif	/* _ASM_X86_SECTIONS_H */
--- a/kernel/locking/lockdep.c~lockdep-fix-static-memory-detection-even-more
+++ a/kernel/locking/lockdep.c
@@ -819,34 +819,26 @@ static int very_verbose(struct lock_clas
  * Is this the address of a static object:
  */
 #ifdef __KERNEL__
-/*
- * Check if an address is part of freed initmem. After initmem is freed,
- * memory can be allocated from it, and such allocations would then have
- * addresses within the range [_stext, _end].
- */
-#ifndef arch_is_kernel_initmem_freed
-static int arch_is_kernel_initmem_freed(unsigned long addr)
-{
-	if (system_state < SYSTEM_FREEING_INITMEM)
-		return 0;
-
-	return init_section_contains((void *)addr, 1);
-}
-#endif
-
 static int static_obj(const void *obj)
 {
-	unsigned long start = (unsigned long) &_stext,
-		      end   = (unsigned long) &_end,
-		      addr  = (unsigned long) obj;
+	unsigned long addr = (unsigned long) obj;
 
-	if (arch_is_kernel_initmem_freed(addr))
-		return 0;
+	if (is_kernel_core_data(addr))
+		return 1;
+
+	/*
+	 * keys are allowed in the __ro_after_init section.
+	 */
+	if (is_kernel_rodata(addr))
+		return 1;
 
 	/*
-	 * static variable?
+	 * in initdata section and used during bootup only?
+	 * NOTE: On some platforms the initdata section is
+	 * outside of the _stext ... _end range.
 	 */
-	if ((addr >= start) && (addr < end))
+	if (system_state < SYSTEM_FREEING_INITMEM &&
+		init_section_contains((void *)addr, 1))
 		return 1;
 
 	/*
_

Patches currently in -mm which might be from deller@gmx.de are


