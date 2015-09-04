From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch removed
 from -mm tree
Date: Fri, 04 Sep 2015 15:28:53 -0700
Message-ID: <55ea1b25.DZN/CI0bmXsYZEkb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbbIDW2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:28:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: update the uffd_msg structure to be the same on 32/64bit
has been removed from the -mm tree.  Its filename was
     userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch

This patch was dropped because it was folded into userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch

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
@@ -53,9 +53,13 @@
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
 
@@ -66,7 +70,7 @@ struct uffd_msg {
 			__u64	reserved3;
 		} reserved;
 	} arg;
-};
+} __attribute__((packed));
 
 /*
  * Start at 0x12 and not at 0 to be more strict against bugs.
_

Patches currently in -mm which might be from aarcange@redhat.com are

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
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-optimize-read-and-poll-to-be-o1-fix.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
userfaultfd-require-uffdio_api-before-other-ioctls.patch
userfaultfd-allow-signals-to-interrupt-a-userfault.patch
userfaultfd-propagate-the-full-address-in-thp-faults.patch
userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch
userfaultfd-selftest.patch

