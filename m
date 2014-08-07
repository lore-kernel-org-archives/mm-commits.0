From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch removed from -mm
 tree
Date: Thu, 07 Aug 2014 13:05:25 -0700
Message-ID: <53e3dc05.2aowbfr0uySVt2Jx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:60876 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGUF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:26 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so844278obc.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: remove hugetlb_zero and hugetlb_infinity
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: remove hugetlb_zero and hugetlb_infinity

They are unnecessary: "zero" can be used in place of "hugetlb_zero" and
passing extra2 == NULL is equivalent to infinity.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 -
 kernel/sysctl.c         |    9 +++------
 mm/hugetlb.c            |    1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity
+++ a/include/linux/hugetlb.h
@@ -87,7 +87,6 @@ pte_t *huge_pmd_share(struct mm_struct *
 #endif
 
 extern unsigned long hugepages_treat_as_movable;
-extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
 
diff -puN kernel/sysctl.c~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity kernel/sysctl.c
--- a/kernel/sysctl.c~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity
+++ a/kernel/sysctl.c
@@ -1240,8 +1240,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_sysctl_handler,
-		.extra1		= (void *)&hugetlb_zero,
-		.extra2		= (void *)&hugetlb_infinity,
+		.extra1		= &zero,
 	},
 #ifdef CONFIG_NUMA
 	{
@@ -1250,8 +1249,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
-		.extra1		= (void *)&hugetlb_zero,
-		.extra2		= (void *)&hugetlb_infinity,
+		.extra1		= &zero,
 	},
 #endif
 	 {
@@ -1274,8 +1272,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
-		.extra1		= (void *)&hugetlb_zero,
-		.extra2		= (void *)&hugetlb_infinity,
+		.extra1		= &zero,
 	},
 #endif
 	{
diff -puN mm/hugetlb.c~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity
+++ a/mm/hugetlb.c
@@ -35,7 +35,6 @@
 #include <linux/node.h>
 #include "internal.h"
 
-const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 unsigned long hugepages_treat_as_movable;
 
 int hugetlb_max_hstate __read_mostly;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

