Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8808DC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72E6F61C96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhGFTSn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231725AbhGFTSn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0102861C7F;
        Tue,  6 Jul 2021 19:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598963;
        bh=TJCw8CZ+uDzvuOVkfzy939lcCo+6OvzJ2LRmeHgcLyo=;
        h=Date:From:To:Subject:From;
        b=ln3FzLizRxKLD+J23tBQ5YjBosg3ZTlsPmxga3XK5QTMprXfqp7JOCUn9xqU1bPZP
         uTZfIpzxFUubTdDKHSfaa5Lr0e6rP6+rRnpgWgcVkBq7/HggfR/JN07e6QR1QNuXTN
         Ilj0wbgz/6DtrtRcSTUgIxe/YES64QfbVyZzvyzc=
Date:   Tue, 06 Jul 2021 12:16:02 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, anshuman.khandual@arm.com,
        bodeddub@amazon.com, bp@alien8.de, bsingharora@gmail.com,
        chenhuang5@huawei.com, corbet@lwn.net, dave.hansen@linux.intel.com,
        david@redhat.com, duanxiongchun@bytedance.com, hpa@zytor.com,
        joao.m.martins@oracle.com, jroedel@suse.de, linmiaohe@huawei.com,
        luto@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, oneukum@suse.com, osalvador@suse.de,
        paulmck@kernel.org, pawan.kumar.gupta@linux.intel.com,
        peterz@infradead.org, rdunlap@infradead.org, rientjes@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [merged]
 mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch removed
 from -mm tree
Message-ID: <20210706191602.XTkHTzjYb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: introduce a new config HUGETLB_PAGE_FREE_VMEMMAP
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: introduce a new config HUGETLB_PAGE_FREE_VMEMMAP

The option HUGETLB_PAGE_FREE_VMEMMAP allows for the freeing of some
vmemmap pages associated with pre-allocated HugeTLB pages.  For example,
on X86_64 6 vmemmap pages of size 4KB each can be saved for each 2MB
HugeTLB page.  4094 vmemmap pages of size 4KB each can be saved for each
1GB HugeTLB page.

When a HugeTLB page is allocated or freed, the vmemmap array representing
the range associated with the page will need to be remapped.  When a page
is allocated, vmemmap pages are freed after remapping.  When a page is
freed, previously discarded vmemmap pages must be allocated before
remapping.

The config option is introduced early so that supporting code can be
written to depend on the option.  The initial version of the code only
provides support for x86-64.

If config HAVE_BOOTMEM_INFO_NODE is enabled, the freeing vmemmap page code
denpend on it to free vmemmap pages.  Otherwise, just use
free_reserved_page() to free vmemmmap pages.  The routine
register_page_bootmem_info() is used to register bootmem info.  Therefore,
make sure register_page_bootmem_info is enabled if
HUGETLB_PAGE_FREE_VMEMMAP is defined.

Link: https://lkml.kernel.org/r/20210510030027.56044-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Chen Huang <chenhuang5@huawei.com>
Tested-by: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Reviewed-by: Balbir Singh <bsingharora@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
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

 arch/x86/mm/init_64.c |    2 +-
 fs/Kconfig            |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/init_64.c~mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap
+++ a/arch/x86/mm/init_64.c
@@ -1270,7 +1270,7 @@ static struct kcore_list kcore_vsyscall;
 
 static void __init register_page_bootmem_info(void)
 {
-#ifdef CONFIG_NUMA
+#if defined(CONFIG_NUMA) || defined(CONFIG_HUGETLB_PAGE_FREE_VMEMMAP)
 	int i;
 
 	for_each_online_node(i)
--- a/fs/Kconfig~mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap
+++ a/fs/Kconfig
@@ -240,6 +240,11 @@ config HUGETLBFS
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
+config HUGETLB_PAGE_FREE_VMEMMAP
+	def_bool HUGETLB_PAGE
+	depends on X86_64
+	depends on SPARSEMEM_VMEMMAP
+
 config MEMFD_CREATE
 	def_bool TMPFS || HUGETLBFS
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


