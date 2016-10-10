From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-introduce-arch_has_gigantic_page.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:46:28 -0700
Message-ID: <57fc1a44.bx/UcQcz3rxYIfZa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752339AbcJJWq3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, catalin.marinas@arm.com, dave.hansen@intel.com, guohanjun@huawei.com, hillf.zj@alibaba-inc.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, robh+dt@kernel.org, sudeep.holla@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: introduce ARCH_HAS_GIGANTIC_PAGE
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-arch_has_gigantic_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/hugetlb: introduce ARCH_HAS_GIGANTIC_PAGE

Avoid making ifdef get pretty unwieldy if many ARCHs support gigantic page.
No functional change with this patch.

Link: http://lkml.kernel.org/r/1475227569-63446-2-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com> 
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |    1 +
 arch/x86/Kconfig  |    1 +
 fs/Kconfig        |    3 +++
 mm/hugetlb.c      |    2 +-
 4 files changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/s390/Kconfig~mm-hugetlb-introduce-arch_has_gigantic_page arch/s390/Kconfig
--- a/arch/s390/Kconfig~mm-hugetlb-introduce-arch_has_gigantic_page
+++ a/arch/s390/Kconfig
@@ -71,6 +71,7 @@ config S390
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
diff -puN arch/x86/Kconfig~mm-hugetlb-introduce-arch_has_gigantic_page arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-hugetlb-introduce-arch_has_gigantic_page
+++ a/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_GIGANTIC_PAGE		if X86_64
 	select ARCH_HAS_KCOV			if X86_64
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_MMIO_FLUSH
diff -puN fs/Kconfig~mm-hugetlb-introduce-arch_has_gigantic_page fs/Kconfig
--- a/fs/Kconfig~mm-hugetlb-introduce-arch_has_gigantic_page
+++ a/fs/Kconfig
@@ -200,6 +200,9 @@ config HUGETLBFS
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
+config ARCH_HAS_GIGANTIC_PAGE
+	bool
+
 source "fs/configfs/Kconfig"
 source "fs/efivarfs/Kconfig"
 
diff -puN mm/hugetlb.c~mm-hugetlb-introduce-arch_has_gigantic_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-arch_has_gigantic_page
+++ a/mm/hugetlb.c
@@ -1022,7 +1022,7 @@ static int hstate_next_node_to_free(stru
 		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
 		nr_nodes--)
 
-#if (defined(CONFIG_X86_64) || defined(CONFIG_S390)) && \
+#if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && \
 	((defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || \
 	defined(CONFIG_CMA))
 static void destroy_compound_gigantic_page(struct page *page,
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are


