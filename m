From: akpm@linux-foundation.org
Subject: + x86-mm-trace-when-an-ipi-is-about-to-be-sent.patch added to -mm tree
Date: Tue, 07 Jul 2015 16:25:41 -0700
Message-ID: <559c5ff5.MrSX8IMapFodEZ9L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbGGXZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 19:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, dave.hansen@intel.com, mingo@kernel.org, riel@redhat.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: trace when an IPI is about to be sent
has been added to the -mm tree.  Its filename is
     x86-mm-trace-when-an-ipi-is-about-to-be-sent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-trace-when-an-ipi-is-about-to-be-sent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-trace-when-an-ipi-is-about-to-be-sent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86, mm: trace when an IPI is about to be sent

When unmapping pages it is necessary to flush the TLB.  If that page was
accessed by another CPU then an IPI is used to flush the remote CPU.  That
is a lot of IPIs if kswapd is scanning and unmapping >100K pages per
second.

There already is a window between when a page is unmapped and when it is
TLB flushed.  This series ses the window so multiple pages can be flushed
using a single IPI.  This should be safe or the kernel is hosed already.

Patch 1 simply made the rest of the series easier to write as ftrace
	could identify all the senders of TLB flush IPIS.

Patch 2 tracks what CPUs potentially map a PFN and then sends an IPI
	to flush the entire TLB.

Patch 3 tracks when there potentially are writable TLB entries that
	need to be batched differently

Patch 4 increases SWAP_CLUSTER_MAX to further batch flushes

The performance impact is documented in the changelogs but in the optimistic
case on a 4-socket machine the full series reduces interrupts from 900K
interrupts/second to 60K interrupts/second.


This patch (of 4):

It is easy to trace when an IPI is received to flush a TLB but harder to
detect what event sent it.  This patch makes it easy to identify the
source of IPIs being transmitted for TLB flushes on x86.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c          |    1 +
 include/linux/mm_types.h   |    1 +
 include/trace/events/tlb.h |    3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/tlb.c~x86-mm-trace-when-an-ipi-is-about-to-be-sent arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-mm-trace-when-an-ipi-is-about-to-be-sent
+++ a/arch/x86/mm/tlb.c
@@ -140,6 +140,7 @@ void native_flush_tlb_others(const struc
 	info.flush_end = end;
 
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
+	trace_tlb_flush(TLB_REMOTE_SEND_IPI, end - start);
 	if (is_uv_system()) {
 		unsigned int cpu;
 
diff -puN include/linux/mm_types.h~x86-mm-trace-when-an-ipi-is-about-to-be-sent include/linux/mm_types.h
--- a/include/linux/mm_types.h~x86-mm-trace-when-an-ipi-is-about-to-be-sent
+++ a/include/linux/mm_types.h
@@ -563,6 +563,7 @@ enum tlb_flush_reason {
 	TLB_REMOTE_SHOOTDOWN,
 	TLB_LOCAL_SHOOTDOWN,
 	TLB_LOCAL_MM_SHOOTDOWN,
+	TLB_REMOTE_SEND_IPI,
 	NR_TLB_FLUSH_REASONS,
 };
 
diff -puN include/trace/events/tlb.h~x86-mm-trace-when-an-ipi-is-about-to-be-sent include/trace/events/tlb.h
--- a/include/trace/events/tlb.h~x86-mm-trace-when-an-ipi-is-about-to-be-sent
+++ a/include/trace/events/tlb.h
@@ -11,7 +11,8 @@
 	EM(  TLB_FLUSH_ON_TASK_SWITCH,	"flush on task switch" )	\
 	EM(  TLB_REMOTE_SHOOTDOWN,	"remote shootdown" )		\
 	EM(  TLB_LOCAL_SHOOTDOWN,	"local shootdown" )		\
-	EMe( TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown" )
+	EM(  TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown" )		\
+	EMe( TLB_REMOTE_SEND_IPI,	"remote ipi send" )
 
 /*
  * First define the enums in TLB_FLUSH_REASON to be exported to userspace
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-meminit-suppress-unused-memory-variable-warning.patch
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
x86-mm-trace-when-an-ipi-is-about-to-be-sent.patch
mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages.patch
mm-defer-flush-of-writable-tlb-entries.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch
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
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

