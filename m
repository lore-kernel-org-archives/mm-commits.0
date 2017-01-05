From: akpm@linux-foundation.org
Subject: + userfaultfd-document-_ior-_iow.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:53:19 -0800
Message-ID: <586d98ff.p4mTsCCW1OfHIbdG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38098 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969955AbdAEBBm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 20:01:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, ldv@altlinux.org, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: document _IOR/_IOW
has been added to the -mm tree.  Its filename is
     userfaultfd-document-_ior-_iow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-document-_ior-_iow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-document-_ior-_iow.patch

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
Subject: userfaultfd: document _IOR/_IOW

Patch series "userfaultfd tmpfs/hugetlbfs/non-cooperative", v2


These userfaultfd features are finished and are ready for larger
exposure in -mm and upstream merging.

1) tmpfs non present userfault
2) hugetlbfs non present userfault
3) non cooperative userfault for fork/madvise/mremap

qemu development code is already exercising 2) and container postcopy
live migration needs 3).

1) is not currently used but there's a self test and we know some qemu
user for various reasons uses tmpfs as backing for KVM so it'll need
it too to use postcopy live migration with tmpfs memory.

All review feedback from the previous submit has been handled and the
fixes are included.  There's no outstanding issue AFIK.

Upstream code just did a s/fe/vmf/ conversion in the page faults and this
has been converted as well incrementally.

In addition to the previous submits, this also wakes up stuck userfaults
during UFFDIO_UNREGISTER.  The non cooperative testcase actually
reproduced this problem by getting stuck instead of quitting clean in some
rare case as it could call UFFDIO_UNREGISTER while some userfault could be
still in flight.  The other option would have been to keep leaving it up
to userland to serialize itself and to patch the testcase instead but the
wakeup during unregister I think is preferable.

David also asked the UFFD_FEATURE_MISSING_HUGETLBFS and
UFFD_FEATURE_MISSING_SHMEM feature flags to be added so QEMU can avoid to
probe if the hugetlbfs/shmem missing support is available by calling
UFFDIO_REGISTER.  QEMU already checks HUGETLBFS_MAGIC with fstatfs so if
UFFD_FEATURE_MISSING_HUGETLBFS is also set, it knows UFFDIO_REGISTER will
succeed (or if it fails, it's for some other more concerning reason). 
There's no reason to worry about adding too many feature flags.  There are
64 available and worst case we've to bump the API if someday we're really
going to run out of them.

The round-trip network latency of hugetlbfs userfaults during postcopy
live migration is still of the order of dozen milliseconds on 10GBit if at
2MB hugepage granularity so it's working perfectly and it should provide
for higher bandwidth or lower CPU usage (which makes it interesting to add
an option in the future to support THP granularity too for anonymous
memory, UFFDIO_COPY would then have to create THP if alignment/len allows
for it).  1GB hugetlbfs granularity will require big changes in hugetlbfs
to work so it's deferred for later.



This patch (of 42):

This adds proper documentation (inline) to avoid the risk of further
misunderstandings about the semantics of _IOW/_IOR and it also reminds
whoever will bump the UFFDIO_API in the future, to change the two ioctl to
_IOW.

This was found while implementing strace support for those ioctl,
otherwise we could have never found it by just reviewing kernel code and
testing it.

_IOC_READ or _IOC_WRITE alters nothing but the ioctl number itself, so
it's only worth fixing if the UFFDIO_API is bumped someday.

Link: http://lkml.kernel.org/r/20161216144821.5183-2-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/asm-generic/ioctl.h |   10 +++++++++-
 include/uapi/linux/userfaultfd.h |    6 ++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN include/uapi/asm-generic/ioctl.h~userfaultfd-document-_ior-_iow include/uapi/asm-generic/ioctl.h
--- a/include/uapi/asm-generic/ioctl.h~userfaultfd-document-_ior-_iow
+++ a/include/uapi/asm-generic/ioctl.h
@@ -48,6 +48,9 @@
 /*
  * Direction bits, which any architecture can choose to override
  * before including this file.
+ *
+ * NOTE: _IOC_WRITE means userland is writing and kernel is
+ * reading. _IOC_READ means userland is reading and kernel is writing.
  */
 
 #ifndef _IOC_NONE
@@ -72,7 +75,12 @@
 #define _IOC_TYPECHECK(t) (sizeof(t))
 #endif
 
-/* used to create numbers */
+/*
+ * Used to create numbers.
+ *
+ * NOTE: _IOW means userland is writing and kernel is reading. _IOR
+ * means userland is reading and kernel is writing.
+ */
 #define _IO(type,nr)		_IOC(_IOC_NONE,(type),(nr),0)
 #define _IOR(type,nr,size)	_IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(size)))
 #define _IOW(type,nr,size)	_IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(size)))
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-document-_ior-_iow include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-document-_ior-_iow
+++ a/include/uapi/linux/userfaultfd.h
@@ -11,6 +11,12 @@
 
 #include <linux/types.h>
 
+/*
+ * If the UFFDIO_API is upgraded someday, the UFFDIO_UNREGISTER and
+ * UFFDIO_WAKE ioctls should be defined as _IOW and not as _IOR.  In
+ * userfaultfd.h we assumed the kernel was reading (instead _IOC_READ
+ * means the userland is reading).
+ */
 #define UFFD_API ((__u64)0xAA)
 /*
  * After implementing the respective features it will become:
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-document-_ior-_iow.patch
userfaultfd-correct-comment-about-uffd_feature_pagefault_flag_wp.patch
userfaultfd-convert-bug-to-warn_on_once.patch
userfaultfd-use-vma_is_anonymous.patch
userfaultfd-non-cooperative-report-all-available-features-to-userland.patch
userfaultfd-non-cooperative-add-fork-event-build-warning-fix.patch
userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch
userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition.patch
userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch
userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch
userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch
userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch
userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

