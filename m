From: akpm@linux-foundation.org
Subject: [folded-merged] mm-vmalloc-remove-vm_vpages-fix.patch removed
 from -mm tree
Date: Thu, 14 Jan 2016 14:23:25 -0800
Message-ID: <56981fdd.QtFA8rbuNmRCIOdm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbcANWX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:23:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-remove-vm_vpages-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-vm_vpages-fix.patch

This patch was dropped because it was folded into mm-vmalloc-remove-vm_vpages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-remove-vm_vpages-fix

remove VM_VPAGES reference via kvfree()

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-remove-vm_vpages-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-remove-vm_vpages-fix
+++ a/mm/vmalloc.c
@@ -1479,10 +1479,7 @@ static void __vunmap(const void *addr, i
 			__free_kmem_pages(page, 0);
 		}
 
-		if (area->flags & VM_VPAGES)
-			vfree(area->pages);
-		else
-			kfree(area->pages);
+		kvfree(area->pages);
 	}
 
 	kfree(area);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm-vmalloc-remove-vm_vpages.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

