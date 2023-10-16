Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1892CDB465
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 22:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbjJPWND (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbjJPWNC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 18:13:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F01A18D
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 15:12:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BE0C433C7;
        Mon, 16 Oct 2023 22:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697494360;
        bh=aoSJbLeFhBlMR61xxmtUDMl5dMszMhjsAGWnCfwNuvY=;
        h=Date:To:From:Subject:From;
        b=TgxWgQkf9sHI1OW8zww1dqv3CmCO2I4Or2Qc44mm1CPCBZn0v5LpCty+HpChs5npW
         8DMbylzHm05zGUOT/8Rn4nXyneHUx0JC2jsDwW3fz0VjK3DSmiP5JtFfOtQMqLhpge
         5l8y0rTMhZ9K0yNo6Oc6WYsNiSJS9x/hmJIMKv4E=
Date:   Mon, 16 Oct 2023 15:12:40 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, matthias.bgg@gmail.com,
        keescook@chromium.org, haibo.li@mediatek.com, glider@google.com,
        dvyukov@google.com, angelogioacchino.delregno@collabora.com,
        andreyknvl@gmail.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-print-the-original-fault-addr-when-access-invalid-shadow-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20231016221240.D0BE0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: disable kasan_non_canonical_hook() for HW tags
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-print-the-original-fault-addr-when-access-invalid-shadow-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-print-the-original-fault-addr-when-access-invalid-shadow-fix.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: kasan: disable kasan_non_canonical_hook() for HW tags
Date: Mon, 16 Oct 2023 22:08:38 +0200

On arm64, building with CONFIG_KASAN_HW_TAGS now causes a compile-time
error:

mm/kasan/report.c: In function 'kasan_non_canonical_hook':
mm/kasan/report.c:637:20: error: 'KASAN_SHADOW_OFFSET' undeclared (first use in this function)
  637 |         if (addr < KASAN_SHADOW_OFFSET)
      |                    ^~~~~~~~~~~~~~~~~~~
mm/kasan/report.c:637:20: note: each undeclared identifier is reported only once for each function it appears in
mm/kasan/report.c:640:77: error: expected expression before ';' token
  640 |         orig_addr = (addr - KASAN_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT;

This was caused by removing the dependency on CONFIG_KASAN_INLINE that
used to prevent this from happening. Use the more specific dependency
on KASAN_SW_TAGS || KASAN_GENERIC to only ignore the function for hwasan
mode.

Link: https://lkml.kernel.org/r/20231016200925.984439-1-arnd@kernel.org
Fixes: 12ec6a919b0f ("kasan: print the original fault addr when access invalid shadow")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Haibo Li <haibo.li@mediatek.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    6 +++---
 mm/kasan/report.c     |    4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/kasan.h~kasan-print-the-original-fault-addr-when-access-invalid-shadow-fix
+++ a/include/linux/kasan.h
@@ -466,10 +466,10 @@ static inline void kasan_free_module_sha
 
 #endif /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 void kasan_non_canonical_hook(unsigned long addr);
-#else /* CONFIG_KASAN */
+#else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 static inline void kasan_non_canonical_hook(unsigned long addr) { }
-#endif /* CONFIG_KASAN */
+#endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
 #endif /* LINUX_KASAN_H */
--- a/mm/kasan/report.c~kasan-print-the-original-fault-addr-when-access-invalid-shadow-fix
+++ a/mm/kasan/report.c
@@ -621,8 +621,9 @@ void kasan_report_async(void)
 }
 #endif /* CONFIG_KASAN_HW_TAGS */
 
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 /*
- * With CONFIG_KASAN, accesses to bogus pointers (outside the high
+ * With CONFIG_KASAN_INLINE, accesses to bogus pointers (outside the high
  * canonical half of the address space) cause out-of-bounds shadow memory reads
  * before the actual access. For addresses in the low canonical half of the
  * address space, as well as most non-canonical addresses, that out-of-bounds
@@ -658,3 +659,4 @@ void kasan_non_canonical_hook(unsigned l
 	pr_alert("KASAN: %s in range [0x%016lx-0x%016lx]\n", bug_type,
 		 orig_addr, orig_addr + KASAN_GRANULE_SIZE - 1);
 }
+#endif
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-print-the-original-fault-addr-when-access-invalid-shadow-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-3.patch

