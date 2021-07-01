Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339C6C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AD1D61477
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237174AbhGABt6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABt5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:49:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C86A261469;
        Thu,  1 Jul 2021 01:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104046;
        bh=B/reZ1mSXT6NQEJmPCJE7MgtkRFoE/6D/4fnvFnQRoo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ktPjlGk8/Fo52jZ2zj6ErwyzCNpkW14fGRaEqrhGAXdvrDCLRZbnM0F7J7EwYFnS5
         pV1DLJVoW3fjTP+rSznYH1pvgqxYUgHEjifzkYYaa1H++RQFRZfolJjacPtjGFW9Uh
         X/ZL3s6H2NL7RNEid/LJKI+6RTCk5NFtuJY0fobw=
Date:   Wed, 30 Jun 2021 18:47:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, almasrymina@google.com,
        anshuman.khandual@arm.com, bodeddub@amazon.com, bp@alien8.de,
        bsingharora@gmail.com, chenhuang5@huawei.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        duanxiongchun@bytedance.com, hpa@zytor.com,
        joao.m.martins@oracle.com, jroedel@suse.de, linmiaohe@huawei.com,
        linux-mm@kvack.org, luto@kernel.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        oneukum@suse.com, osalvador@suse.de, paulmck@kernel.org,
        pawan.kumar.gupta@linux.intel.com, peterz@infradead.org,
        rdunlap@infradead.org, rientjes@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 007/192] mm: hugetlb: add a kernel parameter
 hugetlb_free_vmemmap
Message-ID: <20210701014725.0NAzb7_it%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: add a kernel parameter hugetlb_free_vmemmap

Add a kernel parameter hugetlb_free_vmemmap to enable the feature of
freeing unused vmemmap pages associated with each hugetlb page on boot.

We disable PMD mapping of vmemmap pages for x86-64 arch when this feature
is enabled.  Because vmemmap_remap_free() depends on vmemmap being base
page mapped.

Link: https://lkml.kernel.org/r/20210510030027.56044-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Chen Huang <chenhuang5@huawei.com>
Tested-by: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   17 +++++++++
 Documentation/admin-guide/mm/hugetlbpage.rst    |    3 +
 arch/x86/mm/init_64.c                           |    8 +++-
 include/linux/hugetlb.h                         |   19 +++++++++++
 mm/hugetlb_vmemmap.c                            |   24 ++++++++++++++
 5 files changed, 69 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/init_64.c~mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap
+++ a/arch/x86/mm/init_64.c
@@ -34,6 +34,7 @@
 #include <linux/gfp.h>
 #include <linux/kcore.h>
 #include <linux/bootmem_info.h>
+#include <linux/hugetlb.h>
 
 #include <asm/processor.h>
 #include <asm/bios_ebda.h>
@@ -1609,7 +1610,8 @@ int __meminit vmemmap_populate(unsigned
 	VM_BUG_ON(!IS_ALIGNED(start, PAGE_SIZE));
 	VM_BUG_ON(!IS_ALIGNED(end, PAGE_SIZE));
 
-	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
+	if ((is_hugetlb_free_vmemmap_enabled()  && !altmap) ||
+	    end - start < PAGES_PER_SECTION * sizeof(struct page))
 		err = vmemmap_populate_basepages(start, end, node, NULL);
 	else if (boot_cpu_has(X86_FEATURE_PSE))
 		err = vmemmap_populate_hugepages(start, end, node, altmap);
@@ -1637,6 +1639,8 @@ void register_page_bootmem_memmap(unsign
 	pmd_t *pmd;
 	unsigned int nr_pmd_pages;
 	struct page *page;
+	bool base_mapping = !boot_cpu_has(X86_FEATURE_PSE) ||
+			    is_hugetlb_free_vmemmap_enabled();
 
 	for (; addr < end; addr = next) {
 		pte_t *pte = NULL;
@@ -1662,7 +1666,7 @@ void register_page_bootmem_memmap(unsign
 		}
 		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
 
-		if (!boot_cpu_has(X86_FEATURE_PSE)) {
+		if (base_mapping) {
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
 			pmd = pmd_offset(pud, addr);
 			if (pmd_none(*pmd))
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1567,6 +1567,23 @@
 			Documentation/admin-guide/mm/hugetlbpage.rst.
 			Format: size[KMG]
 
+	hugetlb_free_vmemmap=
+			[KNL] Reguires CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+			enabled.
+			Allows heavy hugetlb users to free up some more
+			memory (6 * PAGE_SIZE for each 2MB hugetlb page).
+			This feauture is not free though. Large page
+			tables are not used to back vmemmap pages which
+			can lead to a performance degradation for some
+			workloads. Also there will be memory allocation
+			required when hugetlb pages are freed from the
+			pool which can lead to corner cases under heavy
+			memory pressure.
+			Format: { on | off (default) }
+
+			on:  enable the feature
+			off: disable the feature
+
 	hung_task_panic=
 			[KNL] Should the hung task detector generate panics.
 			Format: 0 | 1
--- a/Documentation/admin-guide/mm/hugetlbpage.rst~mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -153,6 +153,9 @@ default_hugepagesz
 
 	will all result in 256 2M huge pages being allocated.  Valid default
 	huge page size is architecture dependent.
+hugetlb_free_vmemmap
+	When CONFIG_HUGETLB_PAGE_FREE_VMEMMAP is set, this enables freeing
+	unused vmemmap pages associated with each HugeTLB page.
 
 When multiple huge page sizes are supported, ``/proc/sys/vm/nr_hugepages``
 indicates the current number of pre-allocated huge pages of the default size.
--- a/include/linux/hugetlb.h~mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap
+++ a/include/linux/hugetlb.h
@@ -892,6 +892,20 @@ static inline void huge_ptep_modify_prot
 }
 #endif
 
+#ifdef CONFIG_HUGETLB_PAGE_FREE_VMEMMAP
+extern bool hugetlb_free_vmemmap_enabled;
+
+static inline bool is_hugetlb_free_vmemmap_enabled(void)
+{
+	return hugetlb_free_vmemmap_enabled;
+}
+#else
+static inline bool is_hugetlb_free_vmemmap_enabled(void)
+{
+	return false;
+}
+#endif
+
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
@@ -1046,6 +1060,11 @@ static inline void set_huge_swap_pte_at(
 					pte_t *ptep, pte_t pte, unsigned long sz)
 {
 }
+
+static inline bool is_hugetlb_free_vmemmap_enabled(void)
+{
+	return false;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap
+++ a/mm/hugetlb_vmemmap.c
@@ -168,6 +168,8 @@
  * (last) level. So this type of HugeTLB page can be optimized only when its
  * size of the struct page structs is greater than 2 pages.
  */
+#define pr_fmt(fmt)	"HugeTLB: " fmt
+
 #include "hugetlb_vmemmap.h"
 
 /*
@@ -180,6 +182,28 @@
 #define RESERVE_VMEMMAP_NR		2U
 #define RESERVE_VMEMMAP_SIZE		(RESERVE_VMEMMAP_NR << PAGE_SHIFT)
 
+bool hugetlb_free_vmemmap_enabled;
+
+static int __init early_hugetlb_free_vmemmap_param(char *buf)
+{
+	/* We cannot optimize if a "struct page" crosses page boundaries. */
+	if ((!is_power_of_2(sizeof(struct page)))) {
+		pr_warn("cannot free vmemmap pages because \"struct page\" crosses page boundaries\n");
+		return 0;
+	}
+
+	if (!buf)
+		return -EINVAL;
+
+	if (!strcmp(buf, "on"))
+		hugetlb_free_vmemmap_enabled = true;
+	else if (strcmp(buf, "off"))
+		return -EINVAL;
+
+	return 0;
+}
+early_param("hugetlb_free_vmemmap", early_hugetlb_free_vmemmap_param);
+
 static inline unsigned long free_vmemmap_pages_size_per_hpage(struct hstate *h)
 {
 	return (unsigned long)free_vmemmap_pages_per_hpage(h) << PAGE_SHIFT;
_
