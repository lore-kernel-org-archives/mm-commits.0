From: akpm@linux-foundation.org
Subject: + memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch added to -mm tree
Date: Mon, 17 Sep 2007 13:54:29 -0700
Message-ID: <200709172054.l8HKsTXv004146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544AbXIQUyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Sep 2007 16:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com


The patch titled
     fix swapoff breakage; however...
has been added to the -mm tree.  Its filename is
     memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix swapoff breakage; however...
From: Hugh Dickins <hugh@veritas.com>

rc4-mm1's memory-controller-memory-accounting-v7.patch broke swapoff:
it extended unuse_pte_range's boolean "found" return code to allow an
error return too; but ended up returning found (1) as an error.
Replace that by success (0) before it gets to the upper level.

More fundamentally, it looks like any container brought over its limit in
unuse_pte will abort swapoff: that doesn't doesn't seem "contained" to me.
Maybe unuse_pte should just let containers go over their limits without
error?  Or swap should be counted along with RSS?  Needs reconsideration.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~memory-controller-memory-accounting-v7-fix-swapoff-breakage-however mm/swapfile.c
--- a/mm/swapfile.c~memory-controller-memory-accounting-v7-fix-swapoff-breakage-however
+++ a/mm/swapfile.c
@@ -642,7 +642,7 @@ static int unuse_mm(struct mm_struct *mm
 			break;
 	}
 	up_read(&mm->mmap_sem);
-	return ret;
+	return (ret < 0)? ret: 0;
 }
 
 /*
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-acpi.patch
ata-increase-allowed-config-flags.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
mm-clarify-__add_to_swap_cache-locking.patch
mm-clarify-__add_to_swap_cache-locking-fix.patch
radix-tree-use-indirect-bit.patch
use-vm_read-write-exec-to-set-vm_page_prot.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
mm-shmemc-make-3-functions-static.patch
lib-percpu_counter_sub.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
prio_tree-debugging-patch.patch
