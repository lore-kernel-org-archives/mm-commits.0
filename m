From: akpm@linux-foundation.org
Subject: +
 userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch added to
 -mm tree
Date: Tue, 26 May 2015 15:52:44 -0700
Message-ID: <5564f93c.yq6K8ZRj0YxlTJs1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbEZWwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 May 2015 18:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: update the uffd_msg structure to be the same on 32/64bit
has been added to the -mm tree.  Its filename is
     userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: update the uffd_msg structure to be the same on 32/64bit

Avoiding to using packed allowed the code to be nicer and it avoided
the reserved1/2/3 but the structure must be the same for 32bit and
64bit archs so x86 applications built with the 32bit ABI can run on
the 64bit kernel without requiring translation of the data read
through the read syscall.

$ gcc -m64 p.c && ./a.out
32
0
16
8
8
16
24
$ gcc -m32 p.c && ./a.out
32
0
16
8
8
16
24

int main()
{
	printf("%lu\n", sizeof(struct uffd_msg));
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->event);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.pagefault.address);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.pagefault.flags);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.reserved.reserved1);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.reserved.reserved2);
	printf("%lu\n", (unsigned long) &((struct uffd_msg *) 0)->arg.reserved.reserved3);
}

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/userfaultfd.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2 include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2
+++ a/include/uapi/linux/userfaultfd.h
@@ -51,9 +51,13 @@
 struct uffd_msg {
 	__u8	event;
 
+	__u8	reserved1;
+	__u16	reserved2;
+	__u32	reserved3;
+
 	union {
 		struct {
-			__u32	flags;
+			__u64	flags;
 			__u64	address;
 		} pagefault;
 
@@ -64,7 +68,7 @@ struct uffd_msg {
 			__u64	reserved3;
 		} reserved;
 	} arg;
-};
+} __attribute__((packed));
 
 /*
  * Start at 0x12 and not at 0 to be more strict against bugs.
_

Patches currently in -mm which might be from aarcange@redhat.com are

thp-cleanup-how-khugepaged-enters-freezer.patch
mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt-fix.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-optimize-read-and-poll-to-be-o1-fix.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-activate-syscall-fix.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
fs-userfaultfdc-work-around-i386-build-error.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
mm-clarify-that-the-function-operates-on-hugepage-pte.patch
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

