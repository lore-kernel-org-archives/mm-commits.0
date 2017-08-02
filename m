From: akpm@linux-foundation.org
Subject: +
 userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case.patch added to -mm tree
Date: Wed, 02 Aug 2017 14:28:31 -0700
Message-ID: <598243ff.nYT4QVPL4uZDKTFu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbdHBV2c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 17:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.perevalov@samsung.com, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: remove superfluous page unlock in VM_SHARED case
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case.patch

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
Subject: userfaultfd: hugetlbfs: remove superfluous page unlock in VM_SHARED case

huge_add_to_page_cache->add_to_page_cache implicitly unlocks the page
before returning in case of errors.

The error returned was -EEXIST by running UFFDIO_COPY on a non-hole offset
of a VM_SHARED hugetlbfs mapping.  It was an userland bug that triggered
it and the kernel must cope with it returning -EEXIST from
ioctl(UFFDIO_COPY) as expected.

page dumped because: VM_BUG_ON_PAGE(!PageLocked(page))
------------[ cut here ]------------
kernel BUG at mm/filemap.c:964!
invalid opcode: 0000 [#1] SMP
CPU: 1 PID: 22582 Comm: qemu-system-x86 Not tainted 4.11.11-300.fc26.x86_64 #1
task: ffff973131ab2600 task.stack: ffffacc0cba78000
RIP: 0010:unlock_page+0x4a/0x50
RSP: 0018:ffffacc0cba7bca0 EFLAGS: 00010246
RAX: 0000000000000036 RBX: fffff99d09f38000 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff97326148e0c0
RBP: ffffacc0cba7bca0 R08: 00000000000006be R09: 0000000000000004
R10: 00000000000007ae R11: ffffffffb622cbed R12: 0000000000000008
R13: ffff972f9a265240 R14: ffff972de2919740 R15: ffffffffb62da820
FS:  00007f122efff700(0000) GS:ffff973261480000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd52f788ea8 CR3: 000000036d022000 CR4: 00000000003426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hugetlb_mcopy_atomic_pte+0xc0/0x320
 mcopy_atomic+0x96f/0xbe0
 userfaultfd_ioctl+0x218/0xe90
 ? __schedule+0x23c/0x8d0
 ? hrtimer_start_range_ns+0x1bd/0x330
 do_vfs_ioctl+0xa5/0x600
 ? do_vfs_ioctl+0xa5/0x600
 SyS_ioctl+0x79/0x90
 entry_SYSCALL_64_fastpath+0x1a/0xa9

Link: http://lkml.kernel.org/r/20170802165145.22628-2-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Maxime Coquelin <maxime.coquelin@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case mm/hugetlb.c
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case
+++ a/mm/hugetlb.c
@@ -4062,9 +4062,9 @@ out:
 	return ret;
 out_release_unlock:
 	spin_unlock(ptl);
-out_release_nounlock:
 	if (vm_shared)
 		unlock_page(page);
+out_release_nounlock:
 	put_page(page);
 	goto out;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch

