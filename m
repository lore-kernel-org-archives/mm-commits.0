From: akpm@linux-foundation.org
Subject: [folded-merged] mm-factor-commit-limit-calculation-fix-fix.patch
 removed from -mm tree
Date: Tue, 12 Nov 2013 14:36:40 -0800
Message-ID: <5282ad78.ksX5oUUy4gyaE8vK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab3KLWgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:36:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, jmarchan@redhat.com, dave.hansen@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-factor-commit-limit-calculation-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dave.hansen@linux.intel.com,jmarchan@redhat.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:36:40 -0800


The patch titled
     Subject: mm-factor-commit-limit-calculation-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-factor-commit-limit-calculation-fix-fix.patch

This patch was dropped because it was folded into mm-factor-commit-limit-calculation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-factor-commit-limit-calculation-fix-fix

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 ---------
 mm/util.c |   13 +++++++++++++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -puN mm/mmap.c~mm-factor-commit-limit-calculation-fix-fix mm/mmap.c
--- a/mm/mmap.c~mm-factor-commit-limit-calculation-fix-fix
+++ a/mm/mmap.c
@@ -110,15 +110,6 @@ unsigned long vm_memory_committed(void)
 EXPORT_SYMBOL_GPL(vm_memory_committed);
 
 /*
- * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
- */
-unsigned long vm_commit_limit(void)
-{
-	return ((totalram_pages - hugetlb_total_pages())
-		* sysctl_overcommit_ratio / 100) + total_swap_pages;
-}
-
-/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
diff -puN mm/util.c~mm-factor-commit-limit-calculation-fix-fix mm/util.c
--- a/mm/util.c~mm-factor-commit-limit-calculation-fix-fix
+++ a/mm/util.c
@@ -7,6 +7,9 @@
 #include <linux/security.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/mman.h>
+#include <linux/hugetlb.h>
+
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -398,6 +401,16 @@ struct address_space *page_mapping(struc
 	return mapping;
 }
 
+/*
+ * Commited memory limit enforced when OVERCOMMIT_NEVER policy is used
+ */
+unsigned long vm_commit_limit(void)
+{
+	return ((totalram_pages - hugetlb_total_pages())
+		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+}
+
+
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation.patch
mm-factor-commit-limit-calculation-fix-fix-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch

