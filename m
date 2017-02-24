From: akpm@linux-foundation.org
Subject: [patch 055/124] mm: call vm_munmap in munmap syscall instead of
 using open coded version
Date: Fri, 24 Feb 2017 14:58:19 -0800
Message-ID: <58b0ba8b.9lPwkjmT+GqDNt/u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38404 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdBXW6V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:58:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@virtuozzo.com

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
