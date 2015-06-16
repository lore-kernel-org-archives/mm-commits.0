From: akpm@linux-foundation.org
Subject: +
 mm-shmem_zero_setup-skip-security-check-and-lockdep-conflict-with-xfs.patch added to -mm tree
Date: Tue, 16 Jun 2015 13:16:26 -0700
Message-ID: <5580841a.PzUYjy9QY+uy1VfJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbbFPUQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 16:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, david@fromorbit.com, eparis@redhat.com, esandeen@redhat.com, mstevens@fedoraproject.org, prarit@redhat.com, wagi@monom.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem_zero_setup: skip security check and lockdep conflict with XFS
has been added to the -mm tree.  Its filename is
     mm-shmem_zero_setup-skip-security-check-and-lockdep-conflict-with-xfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shmem_zero_setup-skip-security-check-and-lockdep-conflict-with-xfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem_zero_setup-skip-security-check-and-lockdep-conflict-with-xfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: shmem_zero_setup: skip security check and lockdep conflict with XFS

It appears that, at some point last year, XFS made directory handling
changes which bring it into lockdep conflict with shmem_zero_setup(): it
is surprising that mmap() can clone an inode while holding mmap_sem, but
that has been so for many years.

Since those few lockdep traces that I've seen all implicated selinux, I'm
hoping that we can use the __shmem_file_setup(,,,S_PRIVATE) which v3.13's
commit c7277090927a ("security: shmem: implement kernel private shmem
inodes") introduced to avoid LSM checks on kernel-internal inodes: the
mmap("/dev/zero") cloned inode is indeed a kernel-internal detail.

This also covers the !CONFIG_SHMEM use of ramfs to support /dev/zero (and
MAP_SHARED|MAP_ANONYMOUS).  I thought there were also drivers which cloned
inode in mmap(), but if so, I cannot locate them now.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Prarit Bhargava <prarit@redhat.com>
Tested-by: Prarit Bhargava <prarit@redhat.com>
Reported-by: Daniel Wagner <wagi@monom.org>
Tested-by: Daniel Wagner <wagi@monom.org>
Reported-by: Morten Stevens <mstevens@fedoraproject.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Eric Sandeen <esandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~mm-shmem_zero_setup-skip-security-check-and-lockdep-conflict-with-xfs mm/shmem.c
--- a/mm/shmem.c~mm-shmem_zero_setup-skip-security-check-and-lockdep-conflict-with-xfs
+++ a/mm/shmem.c
@@ -3401,7 +3401,13 @@ int shmem_zero_setup(struct vm_area_stru
 	struct file *file;
 	loff_t size = vma->vm_end - vma->vm_start;
 
-	file = shmem_file_setup("dev/zero", size, vma->vm_flags);
+	/*
+	 * Cloning a new file under mmap_sem leads to a lock ordering conflict
+	 * between XFS directory reading and selinux: since this file is only
+	 * accessible to the user through its mapping, use S_PRIVATE flag to
+	 * bypass file security, in the same way as shmem_kernel_file_setup().
+	 */
+	file = __shmem_file_setup("dev/zero", size, vma->vm_flags, S_PRIVATE);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-shmem_zero_setup-skip-security-check-and-lockdep-conflict-with-xfs.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
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
tmpfs-truncate-prealloc-blocks-past-i_size.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
linux-next.patch

