Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305B8EEAA5D
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 18:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbjINSaS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241247AbjINSaR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 14:30:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC851FD7
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 11:30:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786C9C433C7;
        Thu, 14 Sep 2023 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694716213;
        bh=F6beFAnxZ9dbPKidRJAK2awOG7R4l/py7HQKvke/hJM=;
        h=Date:To:From:Subject:From;
        b=CWGZSa9yNp2JQXyPAjJPmQfzMwGtfIUQYnEBcwGoXjoIzf5d/78GYcg646F0X2Bbv
         uC8g3rFuhrEGJXdKo3+DsvuhlncdM179M2jSy1JIcrkG/WmZxTVEzuRoY6FjDqQVHv
         lVc00CJvBNQnwCoNj3ZNXu18agq2s8BYD61dT7yw=
Date:   Thu, 14 Sep 2023 11:30:12 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, matthias.bgg@gmail.com, glider@google.com,
        dvyukov@google.com, angelogioacchino.delregno@collabora.com,
        andreyknvl@gmail.com, haibo.li@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-access-invalid-shadow-address-when-input-is-illegal.patch added to mm-hotfixes-unstable branch
Message-Id: <20230914183013.786C9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix access invalid shadow address when input is illegal
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-fix-access-invalid-shadow-address-when-input-is-illegal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-access-invalid-shadow-address-when-input-is-illegal.patch

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
Subject: kasan: fix access invalid shadow address when input is illegal
Date: Thu, 14 Sep 2023 16:08:33 +0800

when the input address is illegal,the corresponding shadow address from
kasan_mem_to_shadow may have no mapping in mmu table.  Access such shadow
address causes kernel oops.  Here is a sample about oops on arm64(VA
39bit) with KASAN_SW_TAGS on:

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

To fix it,check shadow address by reading it with no fault.

After this patch,KASAN is able to report invalid memory access
for this case.

Link: https://lkml.kernel.org/r/20230914080833.50026-1-haibo.li@mediatek.com
Signed-off-by: Haibo Li <haibo.li@mediatek.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan.h~kasan-fix-access-invalid-shadow-address-when-input-is-illegal
+++ a/mm/kasan/kasan.h
@@ -304,8 +304,17 @@ static __always_inline bool addr_has_met
 #ifdef __HAVE_ARCH_SHADOW_MAP
 	return (kasan_mem_to_shadow((void *)addr) != NULL);
 #else
-	return (kasan_reset_tag(addr) >=
-		kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
+	u8 *shadow, shadow_val;
+
+	if (kasan_reset_tag(addr) <
+		kasan_shadow_to_mem((void *)KASAN_SHADOW_START))
+		return false;
+	/* use read with nofault to check whether the shadow is accessible */
+	shadow = kasan_mem_to_shadow((void *)addr);
+	__get_kernel_nofault(&shadow_val, shadow, u8, fault);
+	return true;
+fault:
+	return false;
 #endif
 }
 
_

Patches currently in -mm which might be from haibo.li@mediatek.com are

kasan-fix-access-invalid-shadow-address-when-input-is-illegal.patch

