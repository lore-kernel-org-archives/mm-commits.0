Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF75CD68E0
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 00:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379272AbjJJAvf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 20:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379274AbjJJAve (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 20:51:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CA8CA
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 17:51:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D34C433C7;
        Tue, 10 Oct 2023 00:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696899091;
        bh=a9pCEk4SXTS0e5xofns/P21bWmI+T7RNogu7efz4yS8=;
        h=Date:To:From:Subject:From;
        b=MFlKOD5Oj2txnKGFnvGGm9zWrMkPt81LhywGBmG/yVqXfRaDtKhuM6iPsaZWe3UUx
         m1b6jnnrqkPcXdOBP4E7e14En+NRDkeXWGRkUfzig/kkEjMZg7zKK2cAoDU1IIAed/
         ep+8WpbpFlyl6YhHTYL9CFkNYbjhWh/QpWo5DfhU=
Date:   Mon, 09 Oct 2023 17:51:11 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, matthias.bgg@gmail.com, glider@google.com,
        dvyukov@google.com, angelogioacchino.delregno@collabora.com,
        andreyknvl@gmail.com, haibo.li@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-print-the-original-fault-addr-when-access-invalid-shadow.patch added to mm-hotfixes-unstable branch
Message-Id: <20231010005119.C0D34C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: print the original fault addr when access invalid shadow
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-print-the-original-fault-addr-when-access-invalid-shadow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-print-the-original-fault-addr-when-access-invalid-shadow.patch

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
From: Haibo Li <haibo.li@mediatek.com>
Subject: kasan: print the original fault addr when access invalid shadow
Date: Mon, 9 Oct 2023 15:37:48 +0800

when the checked address is illegal,the corresponding shadow address from
kasan_mem_to_shadow may have no mapping in mmu table.  Access such shadow
address causes kernel oops.  Here is a sample about oops on arm64(VA
39bit) with KASAN_SW_TAGS and KASAN_OUTLINE on:

[ffffffb80aaaaaaa] pgd=000000005d3ce003, p4d=000000005d3ce003,
    pud=000000005d3ce003, pmd=0000000000000000
Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
Modules linked in:
CPU: 3 PID: 100 Comm: sh Not tainted 6.6.0-rc1-dirty #43
Hardware name: linux,dummy-virt (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __hwasan_load8_noabort+0x5c/0x90
lr : do_ib_ob+0xf4/0x110
ffffffb80aaaaaaa is the shadow address for efffff80aaaaaaaa.
The problem is reading invalid shadow in kasan_check_range.

The generic kasan also has similar oops.

It only reports the shadow address which causes oops but not
the original address.

Commit 2f004eea0fc8("x86/kasan: Print original address on #GP")
introduce to kasan_non_canonical_hook but limit it to KASAN_INLINE.

This patch extends it to KASAN_OUTLINE mode.

Link: https://lkml.kernel.org/r/20231009073748.159228-1-haibo.li@mediatek.com
Signed-off-by: Haibo Li <haibo.li@mediatek.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Haibo Li <haibo.li@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    6 +++---
 mm/kasan/report.c     |    4 +---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/kasan.h~kasan-print-the-original-fault-addr-when-access-invalid-shadow
+++ a/include/linux/kasan.h
@@ -466,10 +466,10 @@ static inline void kasan_free_module_sha
 
 #endif /* (CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS) && !CONFIG_KASAN_VMALLOC */
 
-#ifdef CONFIG_KASAN_INLINE
+#ifdef CONFIG_KASAN
 void kasan_non_canonical_hook(unsigned long addr);
-#else /* CONFIG_KASAN_INLINE */
+#else /* CONFIG_KASAN */
 static inline void kasan_non_canonical_hook(unsigned long addr) { }
-#endif /* CONFIG_KASAN_INLINE */
+#endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
--- a/mm/kasan/report.c~kasan-print-the-original-fault-addr-when-access-invalid-shadow
+++ a/mm/kasan/report.c
@@ -621,9 +621,8 @@ void kasan_report_async(void)
 }
 #endif /* CONFIG_KASAN_HW_TAGS */
 
-#ifdef CONFIG_KASAN_INLINE
 /*
- * With CONFIG_KASAN_INLINE, accesses to bogus pointers (outside the high
+ * With CONFIG_KASAN, accesses to bogus pointers (outside the high
  * canonical half of the address space) cause out-of-bounds shadow memory reads
  * before the actual access. For addresses in the low canonical half of the
  * address space, as well as most non-canonical addresses, that out-of-bounds
@@ -659,4 +658,3 @@ void kasan_non_canonical_hook(unsigned l
 	pr_alert("KASAN: %s in range [0x%016lx-0x%016lx]\n", bug_type,
 		 orig_addr, orig_addr + KASAN_GRANULE_SIZE - 1);
 }
-#endif
_

Patches currently in -mm which might be from haibo.li@mediatek.com are

kasan-print-the-original-fault-addr-when-access-invalid-shadow.patch

