From: akpm@linux-foundation.org
Subject: +
 mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch added to -mm tree
Date: Tue, 18 Feb 2014 15:14:55 -0800
Message-ID: <5303e96f.+jcLjCAq+veyHINM%akpm__47160.4375554763$1392765380$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbaBRXO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 18:14:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, thellstrom@vmware.com, stable@vger.kernel.org, riel@redhat.com, kirill.shutemov@linux.intel.com, khlebnikov@openvz.org, jaredeh@gmail.com, hannes@stressinduktion.org, dborkman@redhat.com, dave.anglin@bell.net, d.hatayama@jp.fujitsu.com, cotte@de.ibm.com, aarcange@redhat.com, vbabka@suse.cz

Subject: + mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch added to -mm tree
To: vbabka@suse.cz,aarcange@redhat.com,cotte@de.ibm.com,d.hatayama@jp.fujitsu.com,dave.anglin@bell.net,dborkman@redhat.com,hannes@stressinduktion.org,jaredeh@gmail.com,khlebnikov@openvz.org,kirill.shutemov@linux.intel.com,riel@redhat.com,stable@vger.kernel.org,thellstrom@vmware.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 15:14:55 -0800


The patch titled
     Subject: mm: include VM_MIXEDMAP flag in the VM_SPECIAL list to avoid m(un)locking
has been added to the -mm tree.  Its filename is
     mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: include VM_MIXEDMAP flag in the VM_SPECIAL list to avoid m(un)locking

[ 4366.519657] ------------[ cut here ]------------
[ 4366.519709] kernel BUG at mm/mlock.c:528!
[ 4366.519742] invalid opcode: 0000 [#1] SMP
[ 4366.519782] Modules linked in: ccm arc4 iwldvm [...]
[ 4366.520488]  video
[ 4366.520501] CPU: 3 PID: 2266 Comm: netsniff-ng Not tainted 3.14.0-rc2+ #8
[ 4366.520551] Hardware name: LENOVO 2429BP3/2429BP3, BIOS G4ET37WW (1.12 ) 05/29/2012
[ 4366.520608] task: ffff8801f87f9820 ti: ffff88002cb44000 task.ti: ffff88002cb44000
[ 4366.520662] RIP: 0010:[<ffffffff81171ad0>]  [<ffffffff81171ad0>] munlock_vma_pages_range+0x2e0/0x2f0
[ 4366.520738] RSP: 0018:ffff88002cb45e00  EFLAGS: 00010206
[ 4366.520777] RAX: 00000000000001ff RBX: ffff8801f5e75d10 RCX: 000000000000107d
[ 4366.520829] RDX: 00000007f133345f RSI: ffffea0007d76000 RDI: ffffea0007d76000
[ 4366.520881] RBP: ffff88002cb45ed8 R08: 0000000000000000 R09: a8001f5d80000000
[ 4366.520932] R10: 57ffcaa287d76000 R11: 0000000000000246 R12: ffffea0007d76000
[ 4366.520983] R13: 00007f133745f000 R14: 00007f133345f000 R15: ffff8801f5e75a50
[ 4366.521036] FS:  00007f133745f740(0000) GS:ffff88021e2c0000(0000) knlGS:0000000000000000
[ 4366.521094] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4366.521137] CR2: 000000000062ead0 CR3: 00000000c688d000 CR4: 00000000001407e0
[ 4366.521188] Stack:
[ 4366.521205]  ffffffff8116b085 00007f133745efff 00007f133327d000 00007f133745f000
[ 4366.521269]  000001ff81172793 ffff8800c6baa6e0 0000000000000000 0000000000000000
[ 4366.521333]  00007f1333336000 ffffea0004a7ab40 ffff88002cb45e58 0000000000000000
[ 4366.521397] Call Trace:
[ 4366.521422]  [<ffffffff8116b085>] ? tlb_finish_mmu+0x35/0x60
[ 4366.521468]  [<ffffffff8117486f>] do_munmap+0x18f/0x3b0
[ 4366.521511]  [<ffffffff8163e84b>] ? packet_getsockopt+0xfb/0x310
[ 4366.521558]  [<ffffffff81174ad1>] vm_munmap+0x41/0x60
[ 4366.521598]  [<ffffffff811759b2>] SyS_munmap+0x22/0x30
[ 4366.521639]  [<ffffffff81666616>] system_call_fastpath+0x1a/0x1f
[ 4366.521683] Code: ff ff e8 c4 07 fe ff 84 c0 48 8b 95 28 ff ff ff 0f 85 52 ff ff
                     ff e9 3e ff ff ff 48 89 d7 e8 bf 32 4e 00 4c 89 e7 e8 aa 32 4e
                     00 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
                     00 00
[ 4366.522004] RIP  [<ffffffff81171ad0>] munlock_vma_pages_range+0x2e0/0x2f0
[ 4366.522059]  RSP <ffff88002cb45e00>
[ 4366.539269] ---[ end trace a0088dcf07ae10f2 ]---

Daniel Borkmann reported a bug (stack trace above) with VM_BUG_ON
assertions failing where munlock_vma_pages_range() thinks it's
unexpectedly in the middle of a THP page.  This can be reproduced with
default config since 3.11 kernels.  A reproducer can be found in the
kernel's selftest directory for networking by running ./psock_tpacket.

The problem is that an order=2 compound page (allocated by
alloc_one_pg_vec_page() is part of the munlocked VM_MIXEDMAP vma (mapped
by packet_mmap()) and mistaken for a THP page and assumed to be order=9.

The checks for THP in munlock came with commit ff6a6da60b89 ("mm:
accelerate munlock() treatment of THP pages"), i.e.  since 3.9, but did
not trigger a bug.  It just makes munlock_vma_pages_range() skip such
compound pages until the next 512-pages-aligned page, when it encounters a
head page.  This is however not a problem for vma's where mlocking has no
effect anyway, but it can distort the accounting.

Since 7225522bb ("mm: munlock: batch non-THP page isolation and
munlock+putback using pagevec") this can trigger a VM_BUG_ON in
PageTransHuge() check.

This patch fixes the issue by adding VM_MIXEDMAP flag to VM_SPECIAL, a
list of flags that make vma's non-mlockable and non-mergeable.  The
reasoning is that VM_MIXEDMAP vma's are similar to VM_PFNMAP, which is
already on the VM_SPECIAL list, and both are intended for non-LRU pages
where mlocking makes no sense anyway.  Related Lkml discussion can be
found in [2].

 [1] tools/testing/selftests/net/psock_tpacket
 [2] https://lkml.org/lkml/2014/1/10/427

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Reported-by: Daniel Borkmann <dborkman@redhat.com>
Tested-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Jared Hulbert <jaredeh@gmail.com>
Tested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org> [3.11.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/huge_memory.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking include/linux/mm.h
--- a/include/linux/mm.h~mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking
+++ a/include/linux/mm.h
@@ -175,7 +175,7 @@ extern unsigned int kobjsize(const void
  * Special vmas that are non-mergable, non-mlock()able.
  * Note: mm/huge_memory.c VM_NO_THP depends on this definition.
  */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP)
+#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff -puN mm/huge_memory.c~mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking mm/huge_memory.c
--- a/mm/huge_memory.c~mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking
+++ a/mm/huge_memory.c
@@ -1961,7 +1961,7 @@ out:
 	return ret;
 }
 
-#define VM_NO_THP (VM_SPECIAL|VM_MIXEDMAP|VM_HUGETLB|VM_SHARED|VM_MAYSHARE)
+#define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch

