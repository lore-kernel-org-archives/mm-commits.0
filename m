From: akpm@linux-foundation.org
Subject: + userfaultfd-rename-uffd_apibits-into-features.patch added to
 -mm tree
Date: Tue, 19 May 2015 14:38:43 -0700
Message-ID: <555bad63.zrtp8KvjQd0SBOMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbbESVip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 17:38:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@parallels.com, aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: Rename uffd_api.bits into .features
has been added to the -mm tree.  Its filename is
     userfaultfd-rename-uffd_apibits-into-features.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-rename-uffd_apibits-into-features.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-rename-uffd_apibits-into-features.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: userfaultfd: Rename uffd_api.bits into .features

This is (seems to be) the minimal thing that is required to unblock
standard uffd usage from the non-cooperative one.  Now more bits can be
added to the features field indicating e.g.  UFFD_FEATURE_FORK and others
needed for the latter use-case.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
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

 fs/userfaultfd.c                 |    4 ++--
 include/uapi/linux/userfaultfd.h |   10 ++++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-rename-uffd_apibits-into-features fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-rename-uffd_apibits-into-features
+++ a/fs/userfaultfd.c
@@ -871,7 +871,7 @@ static int userfaultfd_api(struct userfa
 		goto out;
 	}
 	/* careful not to leak info, we only read the first 8 bytes */
-	uffdio_api.bits = UFFD_API_BITS;
+	uffdio_api.features = UFFD_API_FEATURES;
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
@@ -928,7 +928,7 @@ static void userfaultfd_show_fdinfo(stru
 	 *	protocols: aa:... bb:...
 	 */
 	seq_printf(m, "pending:\t%lu\ntotal:\t%lu\nAPI:\t%Lx:%x:%Lx\n",
-		   pending, total, UFFD_API, UFFD_API_BITS,
+		   pending, total, UFFD_API, UFFD_API_FEATURES,
 		   UFFD_API_IOCTLS|UFFD_API_RANGE_IOCTLS);
 }
 #endif
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-rename-uffd_apibits-into-features include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-rename-uffd_apibits-into-features
+++ a/include/uapi/linux/userfaultfd.h
@@ -11,7 +11,7 @@
 
 #define UFFD_API ((__u64)0xAA)
 /* FIXME: add "|UFFD_BIT_WP" to UFFD_API_BITS after implementing it */
-#define UFFD_API_BITS (UFFD_BIT_WRITE)
+#define UFFD_API_FEATURES (UFFD_FEATURE_WRITE_BIT)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -51,12 +51,18 @@
 #define UFFD_BIT_WP	(1<<1)	/* handle_userfault() reason VM_UFFD_WP */
 #define UFFD_BITS	2	/* two above bits used for UFFD_BIT_* mask */
 
+/*
+ * Features reported in uffdio_api.features field
+ */
+#define UFFD_FEATURE_WRITE_BIT	(1<<0) /* Corresponds to UFFD_BIT_WRITE */
+#define UFFD_FEATURE_WP_BIT	(1<<1) /* Corresponds to UFFD_BIT_WP */
+
 struct uffdio_api {
 	/* userland asks for an API number */
 	__u64 api;
 
 	/* kernel answers below with the available features for the API */
-	__u64 bits;
+	__u64 features;
 	__u64 ioctls;
 };
 
_

Patches currently in -mm which might be from xemul@parallels.com are

mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
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

