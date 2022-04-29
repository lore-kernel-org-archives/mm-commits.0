Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA49AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378833AbiD2Qt5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379277AbiD2Qtx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:49:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A03CD5E86
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2EA862381
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220EBC385A4;
        Fri, 29 Apr 2022 16:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651250793;
        bh=cK3wMvbtCdXEhmE2T2u51auKTwzTgbzp/YCuKLFOcHk=;
        h=Date:To:From:Subject:From;
        b=jpaC31JKf4SSeTuS+IHiY3ecZx39IbJQS7GzWeLebuv5yOw4KAjPO6D4hMSbiGJCE
         /SkTV79oe3uVp5CwrQqnFFWm1Ht4B14k8sI56oc96CJnUV36pYSnwQeQr/4jaUIlKN
         Ct29zcH8arsuURSq91SZSeA/la1yByb45aC0ZjKM=
Date:   Fri, 29 Apr 2022 09:46:32 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mcgrof@kernel.org, masahiroy@kernel.org,
        keescook@chromium.org, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch added to mm-unstable branch
Message-Id: <20220429164633.220EBC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: add hugetlb_optimize_vmemmap sysctl
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

This patch should soon appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: add hugetlb_optimize_vmemmap sysctl

We must add hugetlb_free_vmemmap=on (or "off") to the boot cmdline and
reboot the server to enable or disable the feature of optimizing vmemmap
pages associated with HugeTLB pages.  However, rebooting usually takes a
long time.  So add a sysctl to enable or disable the feature at runtime
without rebooting.  Why we need this?  There are 3 use cases.

1) The feature of minimizing overhead of struct page associated with each
HugeTLB is disabled by default without passing "hugetlb_free_vmemmap=on"
to the boot cmdline.  When we (ByteDance) deliver the servers to the users
who want to enable this feature, they have to configure the grub (change
boot cmdline) and reboot the servers, whereas rebooting usually takes a
long time (we have thousands of servers).  It's a very bad experience for
the users.  So we need a approach to enable this feature after rebooting. 
This is a use case in our practical environment.

2) Some use cases are that HugeTLB pages are allocated 'on the fly'
instead of being pulled from the HugeTLB pool, those workloads would be
affected with this feature enabled.  Those workloads could be identified
by the characteristics of they never explicitly allocating huge pages with
'nr_hugepages' but only set 'nr_overcommit_hugepages' and then let the
pages be allocated from the buddy allocator at fault time.  We can confirm
it is a real use case from the commit 099730d67417.  For those workloads,
the page fault time could be ~2x slower than before.  We suspect those
users want to disable this feature if the system has enabled this before
and they don't think the memory savings benefit is enough to make up for
the performance drop.

3) If the workload which wants vmemmap pages to be optimized and the
workload which wants to set 'nr_overcommit_hugepages' and does not want
the extera overhead at fault time when the overcommitted pages be
allocated from the buddy allocator are deployed in the same server.  The
user could enable this feature and set 'nr_hugepages' and
'nr_overcommit_hugepages', then disable the feature.  In this case, the
overcommited HugeTLB pages will not encounter the extra overhead at fault
time.

Link: https://lkml.kernel.org/r/20220429121816.37541-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |   30 +++++++
 include/linux/memory_hotplug.h          |    9 ++
 mm/hugetlb_vmemmap.c                    |   92 +++++++++++++++++++---
 mm/hugetlb_vmemmap.h                    |    4 
 mm/memory_hotplug.c                     |    7 -
 5 files changed, 126 insertions(+), 16 deletions(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -562,6 +562,36 @@ Change the minimum size of the hugepage
 See Documentation/admin-guide/mm/hugetlbpage.rst
 
 
+hugetlb_optimize_vmemmap
+========================
+
+Enable (set to 1) or disable (set to 0) the feature of optimizing vmemmap pages
+associated with each HugeTLB page.
+
+Once enabled, the vmemmap pages of subsequent allocation of HugeTLB pages from
+buddy allocator will be optimized (7 pages per 2MB HugeTLB page and 4095 pages
+per 1GB HugeTLB page), whereas already allocated HugeTLB pages will not be
+optimized.  When those optimized HugeTLB pages are freed from the HugeTLB pool
+to the buddy allocator, the vmemmap pages representing that range needs to be
+remapped again and the vmemmap pages discarded earlier need to be rellocated
+again.  If your use case is that HugeTLB pages are allocated 'on the fly' (e.g.
+never explicitly allocating HugeTLB pages with 'nr_hugepages' but only set
+'nr_overcommit_hugepages', those overcommitted HugeTLB pages are allocated 'on
+the fly') instead of being pulled from the HugeTLB pool, you should weigh the
+benefits of memory savings against the more overhead (~2x slower than before)
+of allocation or freeing HugeTLB pages between the HugeTLB pool and the buddy
+allocator.  Another behavior to note is that if the system is under heavy memory
+pressure, it could prevent the user from freeing HugeTLB pages from the HugeTLB
+pool to the buddy allocator since the allocation of vmemmap pages could be
+failed, you have to retry later if your system encounter this situation.
+
+Once disabled, the vmemmap pages of subsequent allocation of HugeTLB pages from
+buddy allocator will not be optimized meaning the extra overhead at allocation
+time from buddy allocator disappears, whereas already optimized HugeTLB pages
+will not be affected.  If you want to make sure there is no optimized HugeTLB
+pages, you can set "nr_hugepages" to 0 first and then disable this.
+
+
 nr_hugepages_mempolicy
 ======================
 
--- a/include/linux/memory_hotplug.h~mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl
+++ a/include/linux/memory_hotplug.h
@@ -351,4 +351,13 @@ void arch_remove_linear_mapping(u64 star
 extern bool mhp_supports_memmap_on_memory(unsigned long size);
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
+#ifdef CONFIG_MHP_MEMMAP_ON_MEMORY
+bool mhp_memmap_on_memory(void);
+#else
+static inline bool mhp_memmap_on_memory(void)
+{
+	return false;
+}
+#endif
+
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl
+++ a/mm/hugetlb_vmemmap.c
@@ -10,6 +10,7 @@
  */
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
+#include <linux/memory_hotplug.h>
 #include "hugetlb_vmemmap.h"
 
 /*
@@ -22,21 +23,40 @@
 #define RESERVE_VMEMMAP_NR		1U
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
+enum vmemmap_optimize_mode {
+	VMEMMAP_OPTIMIZE_OFF,
+	VMEMMAP_OPTIMIZE_ON,
+};
+
 DEFINE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
 			hugetlb_optimize_vmemmap_key);
 EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
 
+static enum vmemmap_optimize_mode vmemmap_optimize_mode =
+	IS_ENABLED(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON);
+
+static void vmemmap_optimize_mode_switch(enum vmemmap_optimize_mode to)
+{
+	if (vmemmap_optimize_mode == to)
+		return;
+
+	if (to == VMEMMAP_OPTIMIZE_OFF)
+		static_branch_dec(&hugetlb_optimize_vmemmap_key);
+	else
+		static_branch_inc(&hugetlb_optimize_vmemmap_key);
+	vmemmap_optimize_mode = to;
+}
+
 static int __init hugetlb_vmemmap_early_param(char *buf)
 {
 	bool enable;
+	enum vmemmap_optimize_mode mode;
 
 	if (kstrtobool(buf, &enable))
 		return -EINVAL;
 
-	if (enable)
-		static_branch_enable(&hugetlb_optimize_vmemmap_key);
-	else
-		static_branch_disable(&hugetlb_optimize_vmemmap_key);
+	mode = enable ? VMEMMAP_OPTIMIZE_ON : VMEMMAP_OPTIMIZE_OFF;
+	vmemmap_optimize_mode_switch(mode);
 
 	return 0;
 }
@@ -60,6 +80,8 @@ int hugetlb_vmemmap_alloc(struct hstate
 	vmemmap_end	= vmemmap_addr + (vmemmap_pages << PAGE_SHIFT);
 	vmemmap_reuse	= vmemmap_addr - PAGE_SIZE;
 
+	VM_BUG_ON_PAGE(!vmemmap_pages, head);
+
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_addr,
 	 * @vmemmap_end) are mapped to are freed to the buddy allocator, and
@@ -69,8 +91,10 @@ int hugetlb_vmemmap_alloc(struct hstate
 	 */
 	ret = vmemmap_remap_alloc(vmemmap_addr, vmemmap_end, vmemmap_reuse,
 				  GFP_KERNEL | __GFP_NORETRY | __GFP_THISNODE);
-	if (!ret)
+	if (!ret) {
 		ClearHPageVmemmapOptimized(head);
+		static_branch_dec(&hugetlb_optimize_vmemmap_key);
+	}
 
 	return ret;
 }
@@ -84,6 +108,8 @@ void hugetlb_vmemmap_free(struct hstate
 	if (!vmemmap_pages)
 		return;
 
+	static_branch_inc(&hugetlb_optimize_vmemmap_key);
+
 	vmemmap_addr	+= RESERVE_VMEMMAP_SIZE;
 	vmemmap_end	= vmemmap_addr + (vmemmap_pages << PAGE_SHIFT);
 	vmemmap_reuse	= vmemmap_addr - PAGE_SIZE;
@@ -93,7 +119,9 @@ void hugetlb_vmemmap_free(struct hstate
 	 * to the page which @vmemmap_reuse is mapped to, then free the pages
 	 * which the range [@vmemmap_addr, @vmemmap_end] is mapped to.
 	 */
-	if (!vmemmap_remap_free(vmemmap_addr, vmemmap_end, vmemmap_reuse))
+	if (vmemmap_remap_free(vmemmap_addr, vmemmap_end, vmemmap_reuse))
+		static_branch_dec(&hugetlb_optimize_vmemmap_key);
+	else
 		SetHPageVmemmapOptimized(head);
 }
 
@@ -110,9 +138,6 @@ void __init hugetlb_vmemmap_init(struct
 	BUILD_BUG_ON(__NR_USED_SUBPAGE >=
 		     RESERVE_VMEMMAP_SIZE / sizeof(struct page));
 
-	if (!hugetlb_optimize_vmemmap_enabled())
-		return;
-
 	if (!is_power_of_2(sizeof(struct page))) {
 		pr_warn_once("cannot optimize vmemmap pages because \"struct page\" crosses page boundaries\n");
 		static_branch_disable(&hugetlb_optimize_vmemmap_key);
@@ -134,3 +159,52 @@ void __init hugetlb_vmemmap_init(struct
 	pr_info("can optimize %d vmemmap pages for %s\n",
 		h->optimize_vmemmap_pages, h->name);
 }
+
+#ifdef CONFIG_PROC_SYSCTL
+static int hugetlb_optimize_vmemmap_handler(struct ctl_table *table, int write,
+					    void *buffer, size_t *length,
+					    loff_t *ppos)
+{
+	int ret;
+	enum vmemmap_optimize_mode mode;
+	static DEFINE_MUTEX(sysctl_mutex);
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&sysctl_mutex);
+	mode = vmemmap_optimize_mode;
+	table->data = &mode;
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (write && !ret)
+		vmemmap_optimize_mode_switch(mode);
+	mutex_unlock(&sysctl_mutex);
+
+	return ret;
+}
+
+static struct ctl_table hugetlb_vmemmap_sysctls[] = {
+	{
+		.procname	= "hugetlb_optimize_vmemmap",
+		.maxlen		= sizeof(enum vmemmap_optimize_mode),
+		.mode		= 0644,
+		.proc_handler	= hugetlb_optimize_vmemmap_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{ }
+};
+
+static __init int hugetlb_vmemmap_sysctls_init(void)
+{
+	/*
+	 * If "memory_hotplug.memmap_on_memory" is enabled or "struct page"
+	 * crosses page boundaries, the vmemmap pages cannot be optimized.
+	 */
+	if (!mhp_memmap_on_memory() && is_power_of_2(sizeof(struct page)))
+		register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
+
+	return 0;
+}
+late_initcall(hugetlb_vmemmap_sysctls_init);
+#endif /* CONFIG_PROC_SYSCTL */
--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl
+++ a/mm/hugetlb_vmemmap.h
@@ -21,7 +21,9 @@ void hugetlb_vmemmap_init(struct hstate
  */
 static inline unsigned int hugetlb_optimize_vmemmap_pages(struct hstate *h)
 {
-	return h->optimize_vmemmap_pages;
+	if (hugetlb_optimize_vmemmap_enabled())
+		return h->optimize_vmemmap_pages;
+	return 0;
 }
 #else
 static inline int hugetlb_vmemmap_alloc(struct hstate *h, struct page *head)
--- a/mm/memory_hotplug.c~mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl
+++ a/mm/memory_hotplug.c
@@ -63,15 +63,10 @@ static bool memmap_on_memory __ro_after_
 module_param_cb(memmap_on_memory, &memmap_on_memory_ops, &memmap_on_memory, 0444);
 MODULE_PARM_DESC(memmap_on_memory, "Enable memmap on memory for memory hotplug");
 
-static inline bool mhp_memmap_on_memory(void)
+bool mhp_memmap_on_memory(void)
 {
 	return memmap_on_memory;
 }
-#else
-static inline bool mhp_memmap_on_memory(void)
-{
-	return false;
-}
 #endif
 
 enum {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

