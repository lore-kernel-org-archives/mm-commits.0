Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A906CC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjBCGhU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjBCGgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1E880F90
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F853CE2EC5
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B353C4339C;
        Fri,  3 Feb 2023 06:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406165;
        bh=F9u0YNkrRLHkYD7otOxg8VVTflAUurt4oE8MlpjNRHY=;
        h=Date:To:From:Subject:From;
        b=Ki88AuQ2Y/llcOd968d7RmltluPsN/G6NnxIVKUR/rDxLJ3Xgg013j2E2aoSpUhSR
         w3lLe4aPjKk6MQ9xzWvI+Q60QUjeVLqIurfrF0y6QzSIR0Di6klX8hQM+35Oc8v+I6
         rt8ee0DclbPvrmWyY4r+nKmreGLx1gmBK+//+MdY=
Date:   Thu, 02 Feb 2023 22:36:04 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        qun-wei.lin@mediatek.com, peterz@infradead.org, mingo@redhat.com,
        luto@kernel.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-x86-kmsan-sync-metadata-pages-on-page-fault.patch removed from -mm tree
Message-Id: <20230203063605.8B353C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "x86: kmsan: sync metadata pages on page fault"
has been removed from the -mm tree.  Its filename was
     revert-x86-kmsan-sync-metadata-pages-on-page-fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

fs-hfs-initialize-fsdata-in-hfs_file_truncate.patch
fs-hfsplus-initialize-fsdata-in-hfsplus_file_truncate.patch

