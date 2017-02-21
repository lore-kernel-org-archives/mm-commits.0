From: akpm@linux-foundation.org
Subject: + userfaultfd-documentation-update.patch added to -mm tree
Date: Tue, 21 Feb 2017 15:10:07 -0800
Message-ID: <58acc8cf.8sgtcryg4ffm7518%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753239AbdBUXKO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2017 18:10:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: documentation update
has been added to the -mm tree.  Its filename is
     userfaultfd-documentation-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-documentation-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-documentation-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: documentation update

Add documentation about new userfaultfd features and events

Link: http://lkml.kernel.org/r/1487716431-5551-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/userfaultfd.txt |   89 +++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff -puN Documentation/vm/userfaultfd.txt~userfaultfd-documentation-update Documentation/vm/userfaultfd.txt
--- a/Documentation/vm/userfaultfd.txt~userfaultfd-documentation-update
+++ a/Documentation/vm/userfaultfd.txt
@@ -54,6 +54,26 @@ uffdio_api.features and uffdio_api.ioctl
 respectively all the available features of the read(2) protocol and
 the generic ioctl available.
 
+The uffdio_api.features bitmask returned by the UFFDIO_API ioctl
+defines what memory types are supported by the userfaultfd and what
+events, except page fault notifications, may be generated.
+
+If the kernel supports registering userfaultfd ranges on hugetlbfs
+virtual memory areas, UFFD_FEATURE_MISSING_HUGETLBFS will be set in
+uffdio_api.features. Similarly, UFFD_FEATURE_MISSING_SHMEM will be
+set if the kernel supports registering userfaultfd ranges on shared
+memory (covering all shmem APIs, i.e. tmpfs, IPCSHM, /dev/zero
+MAP_SHARED, memfd_create, etc).
+
+The userland application that wants to use userfaultfd with hugetlbfs
+or shared memory need to set the corresponding flag in
+uffdio_api.features to enable those features.
+
+If the userland desires to receive notifications for events other than
+page faults, it has to verify that uffdio_api.features has appropriate
+UFFD_FEATURE_EVENT_* bits set. These events are described in more
+detail below in "Non-cooperative userfaultfd" section.
+
 Once the userfaultfd has been enabled the UFFDIO_REGISTER ioctl should
 be invoked (if present in the returned uffdio_api.ioctls bitmask) to
 register a memory range in the userfaultfd by setting the
@@ -142,3 +162,72 @@ course the bitmap is updated accordingly
 sending the same page twice (in case the userfault is read by the
 postcopy thread just before UFFDIO_COPY|ZEROPAGE runs in the migration
 thread).
+
+== Non-cooperative userfaultfd ==
+
+When the userfaultfd is monitored by an external manager, the manager
+must be able to track changes in the process virtual memory
+layout. Userfaultfd can notify the manager about such changes using
+the same read(2) protocol as for the page fault notifications. The
+manager has to explicitly enable these events by setting appropriate
+bits in uffdio_api.features passed to UFFDIO_API ioctl:
+
+UFFD_FEATURE_EVENT_EXIT - enable notification about exit() of the
+non-cooperative process. When the monitored process exits, the uffd
+manager will get UFFD_EVENT_EXIT.
+
+UFFD_FEATURE_EVENT_FORK - enable userfaultfd hooks for fork(). When
+this feature is enabled, the userfaultfd context of the parent process
+is duplicated into the newly created process. The manager receives
+UFFD_EVENT_FORK with file descriptor of the new userfaultfd context in
+the uffd_msg.fork.
+
+UFFD_FEATURE_EVENT_REMAP - enable notifications about mremap()
+calls. When the non-cooperative process moves a virtual memory area to
+a different location, the manager will receive UFFD_EVENT_REMAP. The
+uffd_msg.remap will contain the old and new addresses of the area and
+its original length.
+
+UFFD_FEATURE_EVENT_REMOVE - enable notifications about
+madvise(MADV_REMOVE) and madvise(MADV_DONTNEED) calls. The event
+UFFD_EVENT_REMOVE will be generated upon these calls to madvise. The
+uffd_msg.remove will contain start and end addresses of the removed
+area.
+
+UFFD_FEATURE_EVENT_UNMAP - enable notifications about memory
+unmapping. The manager will get UFFD_EVENT_UNMAP with uffd_msg.remove
+containing start and end addresses of the unmapped area.
+
+Although the UFFD_FEATURE_EVENT_REMOVE and UFFD_FEATURE_EVENT_UNMAP
+are pretty similar, they quite differ in the action expected from the
+userfaultfd manager. In the former case, the virtual memory is
+removed, but the area is not, the area remains monitored by the
+userfaultfd, and if a page fault occurs in that area it will be
+delivered to the manager. The proper resolution for such page fault is
+to zeromap the faulting address. However, in the latter case, when an
+area is unmapped, either explicitly (with munmap() system call), or
+implicitly (e.g. during mremap()), the area is removed and in turn the
+userfaultfd context for such area disappears too and the manager will
+not get further userland page faults from the removed area. Still, the
+notification is required in order to prevent manager from using
+UFFDIO_COPY on the unmapped area.
+
+Unlike userland page faults which have to be synchronous and require
+explicit or implicit wakeup, all the events are delivered
+asynchronously and the non-cooperative process resumes execution as
+soon as manager executes read(). The userfaultfd manager should
+carefully synchronize calls to UFFDIO_COPY with the events
+processing. To aid the synchronization, the UFFDIO_COPY ioctl will
+return -ENOSPC when the monitored process exits at the time of
+UFFDIO_COPY, and -ENOENT, when the non-cooperative process has changed
+its virtual memory layout simultaneously with outstanding UFFDIO_COPY
+operation.
+
+The current asynchronous model of the event delivery is optimal for
+single threaded non-cooperative userfaultfd manager implementations. A
+synchronous event delivery model can be added later as a new
+userfaultfd feature to facilitate multithreading enhancements of the
+non cooperative manager, for example to allow UFFDIO_COPY ioctls to
+run in parallel to the event reception. Single threaded
+implementations should continue to use the current async event
+delivery model instead.
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch
userfaultfd-introduce-vma_can_userfault.patch
userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-shmem-introduce-vma_is_shmem.patch
userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch
userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch
userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch
userfaultfd-shmem-add-userfaultfd_shmem-test.patch
userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open.patch
userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page.patch
userfaultfd-non-cooperative-selftest-add-test-for-fork-madvdontneed-and-remap-events.patch
userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch
userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch
mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
userfaultfd-non-cooperative-add-event-for-exit-notification.patch
userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch
userfaultfd-documentation-update.patch

