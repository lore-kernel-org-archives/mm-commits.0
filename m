From: akpm@linux-foundation.org
Subject: - kdump-add-is_vmcore_usable-and-vmcore_unusable-update.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:53:15 -0700
Message-ID: <200810182353.m9INrFXI002066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbYJRXyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kdump-add-is_vmcore_usable-and-vmcore_unusable update
has been removed from the -mm tree.  Its filename was
     kdump-add-is_vmcore_usable-and-vmcore_unusable-update.patch

This patch was dropped because it was folded into kdump-add-is_vmcore_usable-and-vmcore_unusable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump-add-is_vmcore_usable-and-vmcore_unusable update
From: Simon Horman <horms@verge.net.au>

I don't think this change was described at all...

Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_dump.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN include/linux/crash_dump.h~kdump-add-is_vmcore_usable-and-vmcore_unusable-update include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~kdump-add-is_vmcore_usable-and-vmcore_unusable-update
+++ a/include/linux/crash_dump.h
@@ -39,15 +39,11 @@ static inline int is_kdump_kernel(void)
 {
 	return (elfcorehdr_addr != ELFCORE_ADDR_MAX) ? 1 : 0;
 }
-#else /* !CONFIG_CRASH_DUMP */
-static inline int is_kdump_kernel(void) { return 0; }
-#endif /* CONFIG_CRASH_DUMP */
 
-#ifdef CONFIG_PROC_VMCORE
 /* is_vmcore_usable() checks if the kernel is booting after a panic and
  * the vmcore region is usable.
  *
- * This makes use of the fact that due to alignment 1 is not
+ * This makes use of the fact that due to alignment -2ULL is not
  * a valid pointer, much in the vain of IS_ERR(), except
  * dealing directly with an unsigned long long rather than a pointer.
  */
@@ -66,7 +62,9 @@ static inline void vmcore_unusable(void)
 	if (is_kdump_kernel())
 		elfcorehdr_addr = ELFCORE_ADDR_ERR;
 }
-#endif /* CONFIG_PROC_VMCORE */
+#else /* !CONFIG_CRASH_DUMP */
+static inline int is_kdump_kernel(void) { return 0; }
+#endif /* CONFIG_CRASH_DUMP */
 
 extern unsigned long saved_max_pfn;
 #endif /* LINUX_CRASHDUMP_H */
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch
kdump-use-is_kdump_kernel-in-sba_init.patch
kdump-add-is_vmcore_usable-and-vmcore_unusable.patch
kdump-add-is_vmcore_usable-and-vmcore_unusable-update.patch
kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch
kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch

