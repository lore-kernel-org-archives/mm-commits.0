From: akpm@linux-foundation.org
Subject: + userfaultfd-linux-documentation-vm-userfaultfdtxt.patch added
 to -mm tree
Date: Tue, 19 May 2015 14:38:17 -0700
Message-ID: <555bad49.ij+r2DTNTl8oCmeo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbESViT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 17:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: linux/Documentation/vm/userfaultfd.txt
has been added to the -mm tree.  Its filename is
     userfaultfd-linux-documentation-vm-userfaultfdtxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-linux-documentation-vm-userfaultfdtxt.patch

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
Subject: userfaultfd: linux/Documentation/vm/userfaultfd.txt

This is the latest userfaultfd patchset.  The postcopy live migration
feature on the qemu side is mostly ready to be merged and it entirely
depends on the userfaultfd syscall to be merged as well.  So it'd be great
if this patchset could be reviewed for merging in -mm.

Userfaults allow to implement on demand paging from userland and more
generally they allow userland to more efficiently take control of the
behavior of page faults than what was available before (PROT_NONE +
SIGSEGV trap).

The use cases are:

1) KVM postcopy live migration (one form of cloud memory
   externalization).

   KVM postcopy live migration is the primary driver of this work:

	http://blog.zhaw.ch/icclab/setting-up-post-copy-live-migration-in-openstack/
	http://lists.gnu.org/archive/html/qemu-devel/2015-02/msg04873.html

2) postcopy live migration of binaries inside linux containers:

	http://thread.gmane.org/gmane.linux.kernel.mm/132662

3) KVM postcopy live snapshotting (allowing to limit/throttle the
   memory usage, unlike fork would, plus the avoidance of fork
   overhead in the first place).

   While the wrprotect tracking is not implemented yet, the syscall API is
   already contemplating the wrprotect fault tracking and it's generic enough
   to allow its later implementation in a backwards compatible fashion.

4) KVM userfaults on shared memory. The UFFDIO_COPY lowlevel method
   should be extended to work also on tmpfs and then the
   uffdio_register.ioctls will notify userland that UFFDIO_COPY is
   available even when the registered virtual memory range is tmpfs
   backed.

5) alternate mechanism to notify web browsers or apps on embedded
   devices that volatile pages have been reclaimed. This basically
   avoids the need to run a syscall before the app can access with the
   CPU the virtual regions marked volatile. This depends on point 4)
   to be fulfilled first, as volatile pages happily apply to tmpfs.

Even though there wasn't a real use case requesting it yet, it also
allows to implement distributed shared memory in a way that readonly
shared mappings can exist simultaneously in different hosts and they
can be become exclusive at the first wrprotect fault.



This patch (of 22):

Add documentation.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/userfaultfd.txt |  140 +++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff -puN /dev/null Documentation/vm/userfaultfd.txt
--- /dev/null
+++ a/Documentation/vm/userfaultfd.txt
@@ -0,0 +1,140 @@
+= Userfaultfd =
+
+== Objective ==
+
+Userfaults allow the implementation of on-demand paging from userland
+and more generally they allow userland to take control various memory
+page faults, something otherwise only the kernel code could do.
+
+For example userfaults allows a proper and more optimal implementation
+of the PROT_NONE+SIGSEGV trick.
+
+== Design ==
+
+Userfaults are delivered and resolved through the userfaultfd syscall.
+
+The userfaultfd (aside from registering and unregistering virtual
+memory ranges) provides two primary functionalities:
+
+1) read/POLLIN protocol to notify a userland thread of the faults
+   happening
+
+2) various UFFDIO_* ioctls that can manage the virtual memory regions
+   registered in the userfaultfd that allows userland to efficiently
+   resolve the userfaults it receives via 1) or to manage the virtual
+   memory in the background
+
+The real advantage of userfaults if compared to regular virtual memory
+management of mremap/mprotect is that the userfaults in all their
+operations never involve heavyweight structures like vmas (in fact the
+userfaultfd runtime load never takes the mmap_sem for writing).
+
+Vmas are not suitable for page- (or hugepage) granular fault tracking
+when dealing with virtual address spaces that could span
+Terabytes. Too many vmas would be needed for that.
+
+The userfaultfd once opened by invoking the syscall, can also be
+passed using unix domain sockets to a manager process, so the same
+manager process could handle the userfaults of a multitude of
+different processes without them being aware about what is going on
+(well of course unless they later try to use the userfaultfd
+themselves on the same region the manager is already tracking, which
+is a corner case that would currently return -EBUSY).
+
+== API ==
+
+When first opened the userfaultfd must be enabled invoking the
+UFFDIO_API ioctl specifying a uffdio_api.api value set to UFFD_API (or
+a later API version) which will specify the read/POLLIN protocol
+userland intends to speak on the UFFD. The UFFDIO_API ioctl if
+successful (i.e. if the requested uffdio_api.api is spoken also by the
+running kernel), will return into uffdio_api.features and
+uffdio_api.ioctls two 64bit bitmasks of respectively the activated
+feature of the read(2) protocol and the generic ioctl available.
+
+Once the userfaultfd has been enabled the UFFDIO_REGISTER ioctl should
+be invoked (if present in the returned uffdio_api.ioctls bitmask) to
+register a memory range in the userfaultfd by setting the
+uffdio_register structure accordingly. The uffdio_register.mode
+bitmask will specify to the kernel which kind of faults to track for
+the range (UFFDIO_REGISTER_MODE_MISSING would track missing
+pages). The UFFDIO_REGISTER ioctl will return the
+uffdio_register.ioctls bitmask of ioctls that are suitable to resolve
+userfaults on the range registered. Not all ioctls will necessarily be
+supported for all memory types depending on the underlying virtual
+memory backend (anonymous memory vs tmpfs vs real filebacked
+mappings).
+
+Userland can use the uffdio_register.ioctls to manage the virtual
+address space in the background (to add or potentially also remove
+memory from the userfaultfd registered range). This means a userfault
+could be triggering just before userland maps in the background the
+user-faulted page.
+
+The primary ioctl to resolve userfaults is UFFDIO_COPY. That
+atomically copies a page into the userfault registered range and wakes
+up the blocked userfaults (unless uffdio_copy.mode &
+UFFDIO_COPY_MODE_DONTWAKE is set). Other ioctl works similarly to
+UFFDIO_COPY.
+
+== QEMU/KVM ==
+
+QEMU/KVM is using the userfaultfd syscall to implement postcopy live
+migration. Postcopy live migration is one form of memory
+externalization consisting of a virtual machine running with part or
+all of its memory residing on a different node in the cloud. The
+userfaultfd abstraction is generic enough that not a single line of
+KVM kernel code had to be modified in order to add postcopy live
+migration to QEMU.
+
+Guest async page faults, FOLL_NOWAIT and all other GUP features work
+just fine in combination with userfaults. Userfaults trigger async
+page faults in the guest scheduler so those guest processes that
+aren't waiting for userfaults (i.e. network bound) can keep running in
+the guest vcpus.
+
+It is generally beneficial to run one pass of precopy live migration
+just before starting postcopy live migration, in order to avoid
+generating userfaults for readonly guest regions.
+
+The implementation of postcopy live migration currently uses one
+single bidirectional socket but in the future two different sockets
+will be used (to reduce the latency of the userfaults to the minimum
+possible without having to decrease /proc/sys/net/ipv4/tcp_wmem).
+
+The QEMU in the source node writes all pages that it knows are missing
+in the destination node, into the socket, and the migration thread of
+the QEMU running in the destination node runs UFFDIO_COPY|ZEROPAGE
+ioctls on the userfaultfd in order to map the received pages into the
+guest (UFFDIO_ZEROCOPY is used if the source page was a zero page).
+
+A different postcopy thread in the destination node listens with
+poll() to the userfaultfd in parallel. When a POLLIN event is
+generated after a userfault triggers, the postcopy thread read() from
+the userfaultfd and receives the fault address (or -EAGAIN in case the
+userfault was already resolved and waken by a UFFDIO_COPY|ZEROPAGE run
+by the parallel QEMU migration thread).
+
+After the QEMU postcopy thread (running in the destination node) gets
+the userfault address it writes the information about the missing page
+into the socket. The QEMU source node receives the information and
+roughly "seeks" to that page address and continues sending all
+remaining missing pages from that new page offset. Soon after that
+(just the time to flush the tcp_wmem queue through the network) the
+migration thread in the QEMU running in the destination node will
+receive the page that triggered the userfault and it'll map it as
+usual with the UFFDIO_COPY|ZEROPAGE (without actually knowing if it
+was spontaneously sent by the source or if it was an urgent page
+requested through an userfault).
+
+By the time the userfaults start, the QEMU in the destination node
+doesn't need to keep any per-page state bitmap relative to the live
+migration around and a single per-page bitmap has to be maintained in
+the QEMU running in the source node to know which pages are still
+missing in the destination node. The bitmap in the source node is
+checked to find which missing pages to send in round robin and we seek
+over it when receiving incoming userfaults. After sending each page of
+course the bitmap is updated accordingly. It's also useful to avoid
+sending the same page twice (in case the userfault is read by the
+postcopy thread just before UFFDIO_COPY|ZEROPAGE runs in the migration
+thread).
_

Patches currently in -mm which might be from aarcange@redhat.com are

thp-cleanup-how-khugepaged-enters-freezer.patch
mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte.patch
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
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
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

