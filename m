From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-debug_wx-support-fix-3.patch
 removed from -mm tree
Date: Wed, 03 Jun 2020 15:24:23 -0700
Message-ID: <20200603222423.HsBqa3suK%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbgFCWYY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:24:24 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, zong.li@sifive.com


The patch titled
     Subject: mm: add MMU dependency for DEBUG_WX
has been removed from the -mm tree.  Its filename was
     mm-add-debug_wx-support-fix-3.patch

This patch was dropped because it was folded into mm-add-debug_wx-support.patch

------------------------------------------------------
From: Zong Li <zong.li@sifive.com>
Subject: mm: add MMU dependency for DEBUG_WX

DEBUG_WX should be enabled on MMU system. It had got build error when
enabling DEBUG_WX on NOMMU.

Link: http://lkml.kernel.org/r/4a674ac7863ff39ca91847b10e51209771f99416.1589178399.git.zong.li@sifive.com
Signed-off-by: Zong Li <zong.li@sifive.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig.debug~mm-add-debug_wx-support-fix-3
+++ a/mm/Kconfig.debug
@@ -124,6 +124,7 @@ config ARCH_HAS_DEBUG_WX
 config DEBUG_WX
 	bool "Warn on W+X mappings at boot"
 	depends on ARCH_HAS_DEBUG_WX
+	depends on MMU
 	select PTDUMP_CORE
 	help
 	  Generate a warning if any W+X mappings are found at boot.
_

Patches currently in -mm which might be from zong.li@sifive.com are

mm-add-debug_wx-support.patch
riscv-support-debug_wx.patch
x86-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch
arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch
