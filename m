Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0B4ECAAD5
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 19:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiIBT32 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 15:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiIBT31 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 15:29:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D969510F7
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 12:29:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D79660DB6
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 19:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF786C433C1;
        Fri,  2 Sep 2022 19:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662146961;
        bh=YqyAeVQJEyqSe24BROqS/KqKwfV8nS/OUxhGVejWR5M=;
        h=Date:To:From:Subject:From;
        b=G7C/YmcTeGekRj8qehffLqrSt0DwekOVQTYN92vkeearQSwRt7fWXbOpr2dNCitnL
         aX9h/ewwal2T4cEdqAZw7ifYtrHHDXdJthRAY4p+4vQ2svyU2FMeWev/3yAps02eCk
         eRgD5jx44RK6wY+DitQkhl5zbUEDCznBQkV5pg9g=
Date:   Fri, 02 Sep 2022 12:29:20 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com, mingo@kernel.org,
        Liam.Howlett@oracle.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-fix-compilation-after-gfp_typesh-split.patch added to mm-hotfixes-unstable branch
Message-Id: <20220902192921.BF786C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: fix compilation after gfp_types.h split
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-fix-compilation-after-gfp_typesh-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-fix-compilation-after-gfp_typesh-split.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: tools: fix compilation after gfp_types.h split
Date: Fri, 2 Sep 2022 20:19:23 +0100

When gfp_types.h was split from gfp.h, it broke the radix test suite.  Fix
the test suite by using gfp_types.h in the tools gfp.h header.

Link: https://lkml.kernel.org/r/20220902191923.1735933-1-willy@infradead.org
Fixes: cb5a065b4ea9 (headers/deps: mm: Split <linux/gfp_types.h> out of <linux/gfp.h>)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/gfp.h       |   21 +--------------------
 tools/include/linux/gfp_types.h |    1 +
 2 files changed, 2 insertions(+), 20 deletions(-)

--- a/tools/include/linux/gfp.h~tools-fix-compilation-after-gfp_typesh-split
+++ a/tools/include/linux/gfp.h
@@ -3,26 +3,7 @@
 #define _TOOLS_INCLUDE_LINUX_GFP_H
 
 #include <linux/types.h>
-
-#define __GFP_BITS_SHIFT 26
-#define __GFP_BITS_MASK ((gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
-
-#define __GFP_HIGH		0x20u
-#define __GFP_IO		0x40u
-#define __GFP_FS		0x80u
-#define __GFP_NOWARN		0x200u
-#define __GFP_ZERO		0x8000u
-#define __GFP_ATOMIC		0x80000u
-#define __GFP_ACCOUNT		0x100000u
-#define __GFP_DIRECT_RECLAIM	0x400000u
-#define __GFP_KSWAPD_RECLAIM	0x2000000u
-
-#define __GFP_RECLAIM	(__GFP_DIRECT_RECLAIM | __GFP_KSWAPD_RECLAIM)
-
-#define GFP_ZONEMASK	0x0fu
-#define GFP_ATOMIC	(__GFP_HIGH | __GFP_ATOMIC | __GFP_KSWAPD_RECLAIM)
-#define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
-#define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
+#include <linux/gfp_types.h>
 
 static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 {
--- /dev/null
+++ a/tools/include/linux/gfp_types.h
@@ -0,0 +1 @@
+#include "../../../include/linux/gfp_types.h"
_

Patches currently in -mm which might be from willy@infradead.org are

tools-fix-compilation-after-gfp_typesh-split.patch
support-highmem-pages-in-vmap_pages_range_noflush.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

