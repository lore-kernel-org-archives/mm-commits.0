From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-linux-userfaultfd_kh.patch removed from -mm
 tree
Date: Tue, 08 Sep 2015 11:03:59 -0700
Message-ID: <55ef230f.uqPtjovADLZmbAwD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbbIHSEQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: linux/userfaultfd_k.h
has been removed from the -mm tree.  Its filename was
     userfaultfd-linux-userfaultfd_kh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: linux/userfaultfd_k.h

Kernel header defining the methods needed by the VM common code to
interact with the userfaultfd.

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

 include/linux/userfaultfd_k.h |   79 ++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff -puN /dev/null include/linux/userfaultfd_k.h
--- /dev/null
+++ a/include/linux/userfaultfd_k.h
@@ -0,0 +1,79 @@
+/*
+ *  include/linux/userfaultfd_k.h
+ *
+ *  Copyright (C) 2015  Red Hat, Inc.
+ *
+ */
+
+#ifndef _LINUX_USERFAULTFD_K_H
+#define _LINUX_USERFAULTFD_K_H
+
+#ifdef CONFIG_USERFAULTFD
+
+#include <linux/userfaultfd.h> /* linux/include/uapi/linux/userfaultfd.h */
+
+#include <linux/fcntl.h>
+
+/*
+ * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
+ * new flags, since they might collide with O_* ones. We want
+ * to re-use O_* flags that couldn't possibly have a meaning
+ * from userfaultfd, in order to leave a free define-space for
+ * shared O_* flags.
+ */
+#define UFFD_CLOEXEC O_CLOEXEC
+#define UFFD_NONBLOCK O_NONBLOCK
+
+#define UFFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
+#define UFFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS)
+
+extern int handle_userfault(struct vm_area_struct *vma, unsigned long address,
+			    unsigned int flags, unsigned long reason);
+
+/* mm helpers */
+static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
+					struct vm_userfaultfd_ctx vm_ctx)
+{
+	return vma->vm_userfaultfd_ctx.ctx == vm_ctx.ctx;
+}
+
+static inline bool userfaultfd_missing(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_UFFD_MISSING;
+}
+
+static inline bool userfaultfd_armed(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_UFFD_MISSING | VM_UFFD_WP);
+}
+
+#else /* CONFIG_USERFAULTFD */
+
+/* mm helpers */
+static inline int handle_userfault(struct vm_area_struct *vma,
+				   unsigned long address,
+				   unsigned int flags,
+				   unsigned long reason)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
+					struct vm_userfaultfd_ctx vm_ctx)
+{
+	return true;
+}
+
+static inline bool userfaultfd_missing(struct vm_area_struct *vma)
+{
+	return false;
+}
+
+static inline bool userfaultfd_armed(struct vm_area_struct *vma)
+{
+	return false;
+}
+
+#endif /* CONFIG_USERFAULTFD */
+
+#endif /* _LINUX_USERFAULTFD_K_H */
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

