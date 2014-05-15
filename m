From: akpm@linux-foundation.org
Subject: + mm-export-unmap_kernel_range.patch added to -mm tree
Date: Thu, 15 May 2014 16:10:44 -0700
Message-ID: <53754974.srkGitawbc52k4x1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaEOXKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 19:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: + mm-export-unmap_kernel_range.patch added to -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 16:10:44 -0700


The patch titled
     Subject: mm/vmalloc.c: export unmap_kernel_range()
has been added to the -mm tree.  Its filename is
     mm-export-unmap_kernel_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-export-unmap_kernel_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-export-unmap_kernel_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/vmalloc.c: export unmap_kernel_range()

zsmalloc needs exported unmap_kernel_range for building as a module.  See
https://lkml.org/lkml/2013/1/18/487

I didn't send a patch to make unmap_kernel_range exportable at that time
because zram was staging stuff and I thought VM function exporting for
staging stuff makes no sense.

Now zsmalloc was promoted.  If we can't build zsmalloc as module, it means
we can't build zram as module, either.  Additionally, buddy map_vm_area is
already exported so let's export unmap_kernel_range to help his buddy.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmalloc.c~mm-export-unmap_kernel_range mm/vmalloc.c
--- a/mm/vmalloc.c~mm-export-unmap_kernel_range
+++ a/mm/vmalloc.c
@@ -1268,6 +1268,7 @@ void unmap_kernel_range(unsigned long ad
 	vunmap_page_range(addr, end);
 	flush_tlb_kernel_range(addr, end);
 }
+EXPORT_SYMBOL_GPL(unmap_kernel_range);
 
 int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
 {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
zram-correct-offset-usage-in-zram_bio_discard.patch
zsmalloc-fixup-trivial-zs-size-classes-value-in-comments.patch
mm-export-unmap_kernel_range.patch
zsmalloc-make-zsmalloc-module-buildable.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

