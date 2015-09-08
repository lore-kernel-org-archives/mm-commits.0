From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:02 -0700
Message-ID: <55ef2312.Q3fUMVXTH8zzav92%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbbIHSER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: add vm_userfaultfd_ctx to the vm_area_struct
has been removed from the -mm tree.  Its filename was
     userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: add vm_userfaultfd_ctx to the vm_area_struct

This adds the vm_userfaultfd_ctx to the vm_area_struct.

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

 include/linux/mm_types.h |   11 +++++++++++
 kernel/fork.c            |    1 +
 2 files changed, 12 insertions(+)

diff -puN include/linux/mm_types.h~userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct include/linux/mm_types.h
--- a/include/linux/mm_types.h~userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct
+++ a/include/linux/mm_types.h
@@ -256,6 +256,16 @@ struct vm_region {
 						* this region */
 };
 
+#ifdef CONFIG_USERFAULTFD
+#define NULL_VM_UFFD_CTX ((struct vm_userfaultfd_ctx) { NULL, })
+struct vm_userfaultfd_ctx {
+	struct userfaultfd_ctx *ctx;
+};
+#else /* CONFIG_USERFAULTFD */
+#define NULL_VM_UFFD_CTX ((struct vm_userfaultfd_ctx) {})
+struct vm_userfaultfd_ctx {};
+#endif /* CONFIG_USERFAULTFD */
+
 /*
  * This struct defines a memory VMM memory area. There is one of these
  * per VM-area/task.  A VM area is any part of the process virtual memory
@@ -322,6 +332,7 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
 #endif
+	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
 };
 
 struct core_thread {
diff -puN kernel/fork.c~userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct kernel/fork.c
--- a/kernel/fork.c~userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct
+++ a/kernel/fork.c
@@ -456,6 +456,7 @@ static int dup_mmap(struct mm_struct *mm
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~VM_LOCKED;
 		tmp->vm_next = tmp->vm_prev = NULL;
+		tmp->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		file = tmp->vm_file;
 		if (file) {
 			struct inode *inode = file_inode(file);
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

