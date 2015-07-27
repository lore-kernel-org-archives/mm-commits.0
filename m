From: akpm@linux-foundation.org
Subject: + mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch
 added to -mm tree
Date: Mon, 27 Jul 2015 12:07:41 -0700
Message-ID: <55b6817d.yrHKVAwWUO8bvz+I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbbG0THm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 15:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, fengguang.wu@intel.com, oleg@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix
has been added to the -mm tree.  Its filename is
     mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix

   mm/nommu.c: In function 'do_mmap':
>> mm/nommu.c:1248:30: error: 'vm_flags' redeclared as different kind of symbol
     unsigned long capabilities, vm_flags, result;
                                 ^
   mm/nommu.c:1241:15: note: previous definition of 'vm_flags' was here
       vm_flags_t vm_flags,

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/nommu.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix mm/nommu.c
--- a/mm/nommu.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix
+++ a/mm/nommu.c
@@ -1245,7 +1245,7 @@ unsigned long do_mmap(struct file *file,
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *rb;
-	unsigned long capabilities, vm_flags, result;
+       unsigned long capabilities, result;
 	int ret;
 
 	*populate = 0;
@@ -1263,7 +1263,7 @@ unsigned long do_mmap(struct file *file,
 
 	/* we've determined that we can make the mapping, now translate what we
 	 * now know into VMA flags */
-	vm_flags = determine_vm_flags(file, prot, flags, capabilities);
+       vm_flags |= determine_vm_flags(file, prot, flags, capabilities);
 
 	/* we're going to need to record the mapping */
 	region = kmem_cache_zalloc(vm_region_jar, GFP_KERNEL);
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-memory-failure-unlock_page-before-put_page.patch
mm-memory-failure-fix-race-in-counting-num_poisoned_pages.patch
mm-memory-failure-give-up-error-handling-for-non-tail-refcounted-thp.patch
mm-memory-failure-check-__pg_hwpoison-separately-from-page_flags_check_at_.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
pagemap-hide-physical-addresses-from-non-privileged-users.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

