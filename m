From: akpm@linux-foundation.org
Subject: [merged] arm64-kconfig-select-gigantic-page.patch removed from
 -mm tree
Date: Mon, 10 Oct 2016 15:46:31 -0700
Message-ID: <57fc1a47.hX+xEFskeF/Z+odJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37275 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbcJJWqc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, catalin.marinas@arm.com, dave.hansen@intel.com, guohanjun@huawei.com, hillf.zj@alibaba-inc.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, robh+dt@kernel.org, sudeep.holla@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64 Kconfig: select gigantic page
has been removed from the -mm tree.  Its filename was
     arm64-kconfig-select-gigantic-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: arm64 Kconfig: select gigantic page

Arm64 supports gigantic page after 084bd29810a5 ("ARM64: mm: HugeTLB
support.") however, it can only be allocated at boottime and can't be
freed.

This patch selects ARCH_HAS_GIGANTIC_PAGE to make gigantic pages can be
allocated and freed at runtime for arch arm64.

Link: http://lkml.kernel.org/r/1475227569-63446-3-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com> 
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm64/Kconfig~arm64-kconfig-select-gigantic-page arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-kconfig-select-gigantic-page
+++ a/arch/arm64/Kconfig
@@ -11,6 +11,7 @@ config ARM64
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are


