Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52741C4707E
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456227AbiDFB5r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379856AbiDEU2e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:28:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA61F65D3
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:15:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13E4C61924
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683F2C385A3;
        Tue,  5 Apr 2022 20:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189729;
        bh=IAOpqs239tDRK9vf280ZzbkzHdqiaEBrSV3MeFbcF4g=;
        h=Date:To:From:Subject:From;
        b=xuwZnCqHs1ygc0Rf1PXrkGcLJmpiBdfxtBZGCcV05CV4c1PMo7/iwDyPB4Xg2WHkD
         2JgDqcYBRTiZ0d6O/cuApVy8CfJSK1RM4oxTzBOxHGQnRdU8Ui7dcSijhv+51h8O0d
         3voY0ykXQ9lNv3eRMRVfViGKbwbqhlxLDW39DbMQ=
Date:   Tue, 05 Apr 2022 13:15:28 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@lst.de,
        cpw@sgi.com, osandov@fb.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore.patch added to -mm tree
Message-Id: <20220405201529.683F2C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix spinning drain_vmap_work after reading from /proc/vmcore
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Omar Sandoval <osandov@fb.com>
Subject: mm/vmalloc: fix spinning drain_vmap_work after reading from /proc/vmcore

Commit 3ee48b6af49c ("mm, x86: Saving vmcore with non-lazy freeing of
vmas") introduced set_iounmap_nonlazy(), which sets vmap_lazy_nr to
lazy_max_pages() + 1, ensuring that any future vunmaps() immediately
purges the vmap areas instead of doing it lazily.

Commit 690467c81b1a ("mm/vmalloc: Move draining areas out of caller
context") moved the purging from the vunmap() caller to a worker thread. 
Unfortunately, set_iounmap_nonlazy() can cause the worker thread to spin
(possibly forever).  For example, consider the following scenario:

1. Thread reads from /proc/vmcore. This eventually calls
   __copy_oldmem_page() -> set_iounmap_nonlazy(), which sets
   vmap_lazy_nr to lazy_max_pages() + 1.
2. Then it calls free_vmap_area_noflush() (via iounmap()), which adds 2
   pages (one page plus the guard page) to the purge list and
   vmap_lazy_nr. vmap_lazy_nr is now lazy_max_pages() + 3, so the
   drain_vmap_work is scheduled.
3. Thread returns from the kernel and is scheduled out.
4. Worker thread is scheduled in and calls drain_vmap_area_work(). It
   frees the 2 pages on the purge list. vmap_lazy_nr is now
   lazy_max_pages() + 1.
5. This is still over the threshold, so it tries to purge areas again,
   but doesn't find anything.
6. Repeat 5.

If the system is running with only one CPU (which is typicial for kdump)
and preemption is disabled, then this will never make forward progress:
there aren't any more pages to purge, so it hangs.  If there is more than
one CPU or preemption is enabled, then the worker thread will spin forever
in the background.  (Note that if there were already pages to be purged at
the time that set_iounmap_nonlazy() was called, this bug is avoided.)

This can be reproduced with anything that reads from /proc/vmcore multiple
times.  E.g., vmcore-dmesg /proc/vmcore.

A simple way to "fix" this would be to make set_iounmap_nonlazy() set
vmap_lazy_nr to lazy_max_pages() instead of lazy_max_pages() + 1.  But, I
think it'd be better to get rid of this hack of clobbering vmap_lazy_nr. 
Instead, this fix makes __copy_oldmem_page() explicitly drain the vmap
areas itself.

Link: https://lkml.kernel.org/r/75014514645de97f2d9e087aa3df0880ea311b77.1649187356.git.osandov@fb.com
Fixes: 3ee48b6af49c ("mm, x86: Saving vmcore with non-lazy freeing of vmas")
Signed-off-by: Omar Sandoval <osandov@fb.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Cliff Wickman <cpw@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/io.h       |    2 +-
 arch/x86/kernel/crash_dump_64.c |    2 +-
 mm/vmalloc.c                    |   21 ++++++++++-----------
 3 files changed, 12 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/io.h~mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore
+++ a/arch/x86/include/asm/io.h
@@ -210,7 +210,7 @@ void __iomem *ioremap(resource_size_t of
 extern void iounmap(volatile void __iomem *addr);
 #define iounmap iounmap
 
-extern void set_iounmap_nonlazy(void);
+void iounmap_purge_vmap_area(void);
 
 #ifdef __KERNEL__
 
--- a/arch/x86/kernel/crash_dump_64.c~mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore
+++ a/arch/x86/kernel/crash_dump_64.c
@@ -37,8 +37,8 @@ static ssize_t __copy_oldmem_page(unsign
 	} else
 		memcpy(buf, vaddr + offset, csize);
 
-	set_iounmap_nonlazy();
 	iounmap((void __iomem *)vaddr);
+	iounmap_purge_vmap_area();
 	return csize;
 }
 
--- a/mm/vmalloc.c~mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore
+++ a/mm/vmalloc.c
@@ -1671,17 +1671,6 @@ static DEFINE_MUTEX(vmap_purge_lock);
 /* for per-CPU blocks */
 static void purge_fragmented_blocks_allcpus(void);
 
-#ifdef CONFIG_X86_64
-/*
- * called before a call to iounmap() if the caller wants vm_area_struct's
- * immediately freed.
- */
-void set_iounmap_nonlazy(void)
-{
-	atomic_long_set(&vmap_lazy_nr, lazy_max_pages()+1);
-}
-#endif /* CONFIG_X86_64 */
-
 /*
  * Purges all lazily-freed vmap areas.
  */
@@ -1753,6 +1742,16 @@ static void purge_vmap_area_lazy(void)
 	mutex_unlock(&vmap_purge_lock);
 }
 
+#ifdef CONFIG_X86_64
+/* Called after iounmap() to immediately free vm_area_struct's. */
+void iounmap_purge_vmap_area(void)
+{
+	mutex_lock(&vmap_purge_lock);
+	__purge_vmap_area_lazy(ULONG_MAX, 0);
+	mutex_unlock(&vmap_purge_lock);
+}
+#endif /* CONFIG_X86_64 */
+
 static void drain_vmap_area_work(struct work_struct *work)
 {
 	unsigned long nr_lazy;
_

Patches currently in -mm which might be from osandov@fb.com are

mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore.patch

