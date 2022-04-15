Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9044AC43217
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 02:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344722AbiDOCQi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 22:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348616AbiDOCQh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 22:16:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A33CB18AC
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 19:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0391B62219
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 02:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC21C385A5;
        Fri, 15 Apr 2022 02:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649988842;
        bh=H2iypGY9BaC4SA681TThy2eJKi1ILIBobrhY0GhHqkc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=B14meI9LZfboYGHLeewF7Rdxi4NRrruW9TZ5qFA5vtrXxS/MqtjtHHMZ+XIS3Q2wu
         RooqhdSPoCYUEcnBNM2bvQAsqWn0cXHWRzebFJjvH5pch0N97ZLzH8ZI8ZRpqMjFKo
         X7fGkbsZvASXJlFvqTEPxO790M96pY1asR76FCeQ=
Date:   Thu, 14 Apr 2022 19:14:01 -0700
To:     urezki@gmail.com, hch@lst.de, chris@chrisdown.name, bhe@redhat.com,
        osandov@fb.com, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
Subject: [patch 13/14] mm/vmalloc: fix spinning drain_vmap_work after reading from /proc/vmcore
Message-Id: <20220415021402.5BC21C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>
Subject: mm/vmalloc: fix spinning drain_vmap_work after reading from /proc/vmcore

Commit 3ee48b6af49c ("mm, x86: Saving vmcore with non-lazy freeing of
vmas") introduced set_iounmap_nonlazy(), which sets vmap_lazy_nr to
lazy_max_pages() + 1, ensuring that any future vunmaps() immediately purge
the vmap areas instead of doing it lazily.

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

It turns out that improvements to vmap() over the years have obsoleted the
need for this "optimization".  I benchmarked `dd if=/proc/vmcore
of=/dev/null` with 4k and 1M read sizes on a system with a 32GB vmcore. 
The test was run on 5.17, 5.18-rc1 with a fix that avoided the hang, and
5.18-rc1 with set_iounmap_nonlazy() removed entirely:

  |5.17  |5.18+fix|5.18+removal
4k|40.86s|  40.09s|      26.73s
1M|24.47s|  23.98s|      21.84s

The removal was the fastest (by a wide margin with 4k reads). This patch
removes set_iounmap_nonlazy().

Link: https://lkml.kernel.org/r/52f819991051f9b865e9ce25605509bfdbacadcd.1649277321.git.osandov@fb.com
Fixes: 690467c81b1a  ("mm/vmalloc: Move draining areas out of caller context")
Signed-off-by: Omar Sandoval <osandov@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/io.h       |    2 --
 arch/x86/kernel/crash_dump_64.c |    1 -
 mm/vmalloc.c                    |   11 -----------
 3 files changed, 14 deletions(-)

--- a/arch/x86/include/asm/io.h~mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore
+++ a/arch/x86/include/asm/io.h
@@ -210,8 +210,6 @@ void __iomem *ioremap(resource_size_t of
 extern void iounmap(volatile void __iomem *addr);
 #define iounmap iounmap
 
-extern void set_iounmap_nonlazy(void);
-
 #ifdef __KERNEL__
 
 void memcpy_fromio(void *, const volatile void __iomem *, size_t);
--- a/arch/x86/kernel/crash_dump_64.c~mm-vmalloc-fix-spinning-drain_vmap_work-after-reading-from-proc-vmcore
+++ a/arch/x86/kernel/crash_dump_64.c
@@ -37,7 +37,6 @@ static ssize_t __copy_oldmem_page(unsign
 	} else
 		memcpy(buf, vaddr + offset, csize);
 
-	set_iounmap_nonlazy();
 	iounmap((void __iomem *)vaddr);
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
_
