From: akpm@linux-foundation.org
Subject: [merged] mm-fix-crash-when-using-xfs-on-loopback.patch removed
 from -mm tree
Date: Wed, 15 Jan 2014 12:28:46 -0800
Message-ID: <52d6ef7e.I0nuLiB//CkzePLM%akpm__2685.16434957764$1389817740$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAOU2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 15:28:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, penberg@kernel.org, iamjoonsoo.kim@lge.com, deller@gmx.de, dave.anglin@bell.net, cl@linux.com, ak@linux.intel.com, mpatocka@redhat.com

Subject: [merged] mm-fix-crash-when-using-xfs-on-loopback.patch removed from -mm tree
To: mpatocka@redhat.com,ak@linux.intel.com,cl@linux.com,dave.anglin@bell.net,deller@gmx.de,iamjoonsoo.kim@lge.com,penberg@kernel.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 12:28:46 -0800


The patch titled
     Subject: mm: fix crash when using XFS on loopback
has been removed from the -mm tree.  Its filename was
     mm-fix-crash-when-using-xfs-on-loopback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: mm: fix crash when using XFS on loopback

The patch 8456a648cf44f ("slab: use struct page for slab management")
causes a crash in the LVM2 testsuite on PA-RISC (the crashing test is
fsadm.sh).  The testsuite doesn't crash on 3.12, crashes on 3.13-rc1 and
later.

 Bad Address (null pointer deref?): Code=15 regs=000000413edd89a0 (Addr=000006202224647d)
 CPU: 3 PID: 24008 Comm: loop0 Not tainted 3.13.0-rc6 #5
 task: 00000001bf3c0048 ti: 000000413edd8000 task.ti: 000000413edd8000

      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
 PSW: 00001000000001101111100100001110 Not tainted
 r00-03  000000ff0806f90e 00000000405c8de0 000000004013e6c0 000000413edd83f0
 r04-07  00000000405a95e0 0000000000000200 00000001414735f0 00000001bf349e40
 r08-11  0000000010fe3d10 0000000000000001 00000040829c7778 000000413efd9000
 r12-15  0000000000000000 000000004060d800 0000000010fe3000 0000000010fe3000
 r16-19  000000413edd82a0 00000041078ddbc0 0000000000000010 0000000000000001
 r20-23  0008f3d0d83a8000 0000000000000000 00000040829c7778 0000000000000080
 r24-27  00000001bf349e40 00000001bf349e40 202d66202224640d 00000000405a95e0
 r28-31  202d662022246465 000000413edd88f0 000000413edd89a0 0000000000000001
 sr00-03  000000000532c000 0000000000000000 0000000000000000 000000000532c000
 sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

 IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000401fe42c 00000000401fe430
  IIR: 539c0030    ISR: 00000000202d6000  IOR: 000006202224647d
  CPU:        3   CR30: 000000413edd8000 CR31: 0000000000000000
  ORIG_R28: 00000000405a95e0
  IAOQ[0]: vma_interval_tree_iter_first+0x14/0x48
  IAOQ[1]: vma_interval_tree_iter_first+0x18/0x48
  RP(r2): flush_dcache_page+0x128/0x388
 Backtrace:
  [<000000004013e6c0>] flush_dcache_page+0x128/0x388
  [<0000000010fe6ca0>] lo_splice_actor+0x90/0x148 [loop]
  [<00000000402579b0>] splice_from_pipe_feed+0xc0/0x1d0
  [<00000000402580a4>] __splice_from_pipe+0xac/0xc0
  [<0000000010fe6bbc>] lo_direct_splice_actor+0x1c/0x70 [loop]
  [<000000004025854c>] splice_direct_to_actor+0xec/0x228
  [<0000000010fe63ac>] lo_receive+0xe4/0x298 [loop]
  [<0000000010fe69d8>] loop_thread+0x478/0x640 [loop]
  [<000000004018975c>] kthread+0x134/0x168
  [<000000004012c020>] end_fault_vector+0x20/0x28
  [<00000000115e0098>] xfs_setsize_buftarg+0x0/0x90 [xfs]

 Kernel panic - not syncing: Bad Address (null pointer deref?)

The patch 8456a648cf44f14365f1f44de90a3da2526a4776 changes the page
structure so that the slab subsystem reuses the page->mapping field.

The crash happens in the following way:
* XFS allocates some memory from slab and issues a bio to read data into
  it.
* the bio is sent to the loopback device.
* lo_receive creates an actor and calls splice_direct_to_actor.
* lo_splice_actor copies data to the target page.
* lo_splice_actor calls flush_dcache_page because the page may be mapped
  by userspace. In that case we need to flush the kernel cache.
* flush_dcache_page asks for the list of userspace mappings, however that
  page->mapping field is reused by the slab subsystem for a different
  purpose. This causes the crash.

Note that other architectures without coherent caches (sparc, arm, mips)
also call page_mapping from flush_dcache_page, so they may crash in the
same way.

This patch fixes this bug by testing if the page is a slab page in
page_mapping and returning NULL if it is.

The patch also fixes VM_BUG_ON(PageSlab(page)) that could happen in
earlier kernels in the same scenario on architectures without cache
coherence when CONFIG_DEBUG_VM is enabled - so it should be backported to
stable kernels.

In the old kernels, the function page_mapping is placed in
include/linux/mm.h, so you should modify the patch accordingly when
backporting it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: John David Anglin <dave.anglin@bell.net>]
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/util.c~mm-fix-crash-when-using-xfs-on-loopback mm/util.c
--- a/mm/util.c~mm-fix-crash-when-using-xfs-on-loopback
+++ a/mm/util.c
@@ -390,7 +390,10 @@ struct address_space *page_mapping(struc
 {
 	struct address_space *mapping = page->mapping;
 
-	VM_BUG_ON(PageSlab(page));
+	/* This happens if someone calls flush_dcache_page on slab page */
+	if (unlikely(PageSlab(page)))
+		return NULL;
+
 	if (unlikely(PageSwapCache(page))) {
 		swp_entry_t entry;
 
_

Patches currently in -mm which might be from mpatocka@redhat.com are

origin.patch
linux-next.patch

