Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B160C5479D
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbjAKVcA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbjAKVb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 16:31:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F246547
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 13:31:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0885661E9E
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 21:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5698CC433D2;
        Wed, 11 Jan 2023 21:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673472717;
        bh=F3t4hxCGTYgJoMVdHCUQtldMOET0PQXL2Ia2JXYSMx4=;
        h=Date:To:From:Subject:From;
        b=mXulO/VQz5mGZn+z7JJO/lrWVXyge9FZwo7LxQCIJ6C3Hxzz1dCcN4uoOieVLBqq+
         MdAd341zOOWkgTNyDRIKmt/bEIa3bbELOrg16ApvPCJw2Cp0ZiQ15hZKRGr1fHFtk7
         KxY0cxdbH34f7N1O/cVM+OiB7z7ez4c9aBYQ3YVc=
Date:   Wed, 11 Jan 2023 13:31:56 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        qun-wei.lin@mediatek.com, peterz@infradead.org, mingo@redhat.com,
        luto@kernel.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-x86-kmsan-sync-metadata-pages-on-page-fault.patch added to mm-unstable branch
Message-Id: <20230111213157.5698CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "x86: kmsan: sync metadata pages on page fault"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-x86-kmsan-sync-metadata-pages-on-page-fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-x86-kmsan-sync-metadata-pages-on-page-fault.patch

This patch will later appear in the mm-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: Revert "x86: kmsan: sync metadata pages on page fault"
Date: Wed, 11 Jan 2023 11:18:06 +0100

This reverts commit 3f1e2c7a9099c1ed32c67f12cdf432ba782cf51f.

As noticed by Qun-Wei Lin, arch_sync_kernel_mappings() in
arch/x86/mm/fault.c is only used with CONFIG_X86_32, whereas KMSAN is only
supported on x86_64, where this code is not compiled.

The patch in question dates back to downstream KMSAN branch based on
v5.8-rc5, it sneaked into upstream unnoticed in v6.1.

Link: https://lkml.kernel.org/r/20230111101806.3236991-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
  Link: https://github.com/google/kmsan/issues/91
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |   23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

--- a/arch/x86/mm/fault.c~revert-x86-kmsan-sync-metadata-pages-on-page-fault
+++ a/arch/x86/mm/fault.c
@@ -260,7 +260,7 @@ static noinline int vmalloc_fault(unsign
 }
 NOKPROBE_SYMBOL(vmalloc_fault);
 
-static void __arch_sync_kernel_mappings(unsigned long start, unsigned long end)
+void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
 {
 	unsigned long addr;
 
@@ -284,27 +284,6 @@ static void __arch_sync_kernel_mappings(
 	}
 }
 
-void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
-{
-	__arch_sync_kernel_mappings(start, end);
-#ifdef CONFIG_KMSAN
-	/*
-	 * KMSAN maintains two additional metadata page mappings for the
-	 * [VMALLOC_START, VMALLOC_END) range. These mappings start at
-	 * KMSAN_VMALLOC_SHADOW_START and KMSAN_VMALLOC_ORIGIN_START and
-	 * have to be synced together with the vmalloc memory mapping.
-	 */
-	if (start >= VMALLOC_START && end < VMALLOC_END) {
-		__arch_sync_kernel_mappings(
-			start - VMALLOC_START + KMSAN_VMALLOC_SHADOW_START,
-			end - VMALLOC_START + KMSAN_VMALLOC_SHADOW_START);
-		__arch_sync_kernel_mappings(
-			start - VMALLOC_START + KMSAN_VMALLOC_ORIGIN_START,
-			end - VMALLOC_START + KMSAN_VMALLOC_ORIGIN_START);
-	}
-#endif
-}
-
 static bool low_pfn(unsigned long pfn)
 {
 	return pfn < max_low_pfn;
_

Patches currently in -mm which might be from glider@google.com are

revert-x86-kmsan-sync-metadata-pages-on-page-fault.patch

