From: akpm@linux-foundation.org
Subject: + printk-trivial-optimizations-fix.patch added to -mm tree
Date: Thu, 29 Nov 2007 14:48:22 -0800
Message-ID: <200711292248.lATMmMcH011253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759545AbXK2Wsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 17:48:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, vda.linux@googlemail.com


The patch titled
     printk trivial optimizations fix
has been added to the -mm tree.  Its filename is
     printk-trivial-optimizations-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: printk trivial optimizations fix
From: Hugh Dickins <hugh@veritas.com>

mm's printk has been showing "%p" in abominable upper case recently:
its trivial optimizations have changed the default from lower to upper,
so the 'p' case needs to enforce lower explicitly.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/vsprintf.c~printk-trivial-optimizations-fix lib/vsprintf.c
--- a/lib/vsprintf.c~printk-trivial-optimizations-fix
+++ a/lib/vsprintf.c
@@ -525,6 +525,7 @@ int vsnprintf(char *buf, size_t size, co
 				continue;
 
 			case 'p':
+				flags |= SMALL;
 				if (field_width == -1) {
 					field_width = 2*sizeof(void *);
 					flags |= ZEROPAD;
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
printk-trivial-optimizations-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
prio_tree-debugging-patch.patch
