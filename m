From: akpm@linux-foundation.org
Subject: +
 mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch added to -mm tree
Date: Tue, 31 Jan 2017 16:46:43 -0800
Message-ID: <58912ff3.A7zO8bpeIqkrYIHx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdBAAqr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:46:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: call vm_munmap in munmap syscall instead of using open coded version
has been added to the -mm tree.  Its filename is
     mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch

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
Subject: mm: call vm_munmap in munmap syscall instead of using open coded version

Patch series "userfaultfd: non-cooperative: better tracking for mapping
changes", v2.

These patches try to address issues I've encountered during integration of
userfaultfd with CRIU.

Previously added userfaultfd events for fork(), madvise() and mremap()
unfortunately do not cover all possible changes to a process virtual
memory layout required for uffd monitor.

When one or more VMAs is removed from the process mm, the external uffd
monitor has no way to detect those changes and will attempt to fill the
removed regions with userfaultfd_copy.

Another problematic event is the exit() of the process.  Here again, the
external uffd monitor will try to use userfaultfd_copy, although mm owning
the memory has already gone.

The first patch in the series is a minor cleanup and it's not strictly
related to the rest of the series.

The patches 2 and 3 below add UFFD_EVENT_UNMAP and UFFD_EVENT_EXIT to
allow the uffd monitor track changes in the memory layout of a process.

The patches 4 and 5 amend error codes returned by userfaultfd_copy to make
the uffd monitor able to cope with races that might occur between delivery
of unmap and exit events and outstanding userfaultfd_copy's.


This patch (of 5):

dc0ef0df7b6a ("mm: make mmap_sem for write waits killable for mm
syscalls") replaced call to vm_munmap in munmap syscall with open coded
version to allow different waits on mmap_sem in munmap syscall and
vm_munmap.  Now both functions use down_write_killable, so we can restore
the call to vm_munmap from the munmap system call.

Link: http://lkml.kernel.org/r/1485542673-24387-2-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN mm/mmap.c~mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version mm/mmap.c
--- a/mm/mmap.c~mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version
+++ a/mm/mmap.c
@@ -2680,15 +2680,8 @@ EXPORT_SYMBOL(vm_munmap);
 
 SYSCALL_DEFINE2(munmap, unsigned long, addr, size_t, len)
 {
-	int ret;
-	struct mm_struct *mm = current->mm;
-
 	profile_munmap(addr);
-	if (down_write_killable(&mm->mmap_sem))
-		return -EINTR;
-	ret = do_munmap(mm, addr, len);
-	up_write(&mm->mmap_sem);
-	return ret;
+	return vm_munmap(addr, len);
 }
 
 
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
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch

