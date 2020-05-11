From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-debug_wx-support-fix-3.patch added to -mm tree
Date: Mon, 11 May 2020 13:41:34 -0700
Message-ID: <20200511204134.lymcyonoD%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbgEKUlf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 16:41:35 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, zong.li@sifive.com


The patch titled
     Subject: mm: add MMU dependency for DEBUG_WX
has been added to the -mm tree.  Its filename is
     mm-add-debug_wx-support-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-debug_wx-support-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-debug_wx-support-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-add-debug_wx-support-fix-2.patch
mm-add-debug_wx-support-fix-3.patch
riscv-support-debug_wx.patch
x86-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch
arm64-mm-use-arch_has_debug_wx-instead-of-arch-defined.patch
