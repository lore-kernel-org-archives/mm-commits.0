From: akpm@linux-foundation.org
Subject: + prio-tree-debugging.patch added to -mm tree
Date: Fri, 11 May 2007 14:11:28 -0700
Message-ID: <200705112111.l4BLBSNC026753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759838AbXEKVLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 17:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     prio-tree debugging
has been added to the -mm tree.  Its filename is
     prio-tree-debugging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: prio-tree debugging
From: Hugh Dickins <hugh@veritas.com>

http://bugzilla.kernel.org/show_bug.cgi?id=8446

------- Additional Comments From hugh@veritas.com  2007-05-11 13:56 -------
Thanks for the report, and for retrying without that nvidia driver.

This is likely to be caused one of three things: either bad RAM
- please try running memtest86+ overnight; or corruption from
somewhere else in the kernel; or a bug in the prio_tree code.

We've had no report of a prio_tree bug in two and a half years,
though originally there was one which triggered just like this.
I see we attacked that by dumping the vma structures passed to
the failing function vma_prio_tree_add(): let's try that again.

Please apply the patch below to your kernel source, rebuild and
reboot that kernel, and mail me the dump and oops outputs when
this strikes again.  Four or more different examples would be
very helpful, we may then be able to detect a pattern to it.

I wish I could have left out that BUG() and let you run with
less trouble: this must be very frustrating each time it occurs.
But once that prio_tree is messed up, I don't know what we could
do about it, safer just to BUG() as it was doing.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/prio_tree.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/prio_tree.c~prio-tree-debugging mm/prio_tree.c
--- a/mm/prio_tree.c~prio-tree-debugging
+++ a/mm/prio_tree.c
@@ -75,8 +75,18 @@
 void vma_prio_tree_add(struct vm_area_struct *vma, struct vm_area_struct *old)
 {
 	/* Leave these BUG_ONs till prio_tree patch stabilizes */
-	BUG_ON(RADIX_INDEX(vma) != RADIX_INDEX(old));
-	BUG_ON(HEAP_INDEX(vma) != HEAP_INDEX(old));
+	if (RADIX_INDEX(vma) != RADIX_INDEX(old) ||
+	    HEAP_INDEX(vma)  != HEAP_INDEX(old)) {
+		unsigned long *ptr;
+		int i;
+		ptr = (unsigned long *) vma;
+		for (i = 0; i < sizeof(*vma)/sizeof(*ptr); i += 2)
+			printk(KERN_EMERG "%p: %016lx %016lx\n", ptr+i, ptr[i], ptr[i+1]);
+		ptr = (unsigned long *) old;
+		for (i = 0; i < sizeof(*vma)/sizeof(*ptr); i += 2)
+			printk(KERN_EMERG "%p: %016lx %016lx\n", ptr+i, ptr[i], ptr[i+1]);
+		BUG();
+	}
 
 	vma->shared.vm_set.head = NULL;
 	vma->shared.vm_set.parent = NULL;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
ia64-race-flushing-icache-in-do_no_page-path.patch
scsi-fix-config_scsi_wait_scan=m.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
mm-more-rmap-checking.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
prio-tree-debugging.patch
