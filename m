From: akpm@linux-foundation.org
Subject: [merged]
 mm-userfaultfd-disable-userfaultfd-wp-on-x86_32.patch removed from -mm tree
Date: Thu, 23 Apr 2020 12:51:30 -0700
Message-ID: <20200423195130.L_KM0T5CV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgDWTvb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hdanton@sina.com, lkp@intel.com, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org, peterx@redhat.com


The patch titled
     Subject: mm/userfaultfd: disable userfaultfd-wp on x86_32
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-disable-userfaultfd-wp-on-x86_32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/userfaultfd: disable userfaultfd-wp on x86_32

Userfaultfd-wp is not yet working on 32bit hosts, but it's accidentally
enabled previously.  Disable it.

Link: http://lkml.kernel.org/r/20200413141608.109211-1-peterx@redhat.com
Fixes: 5a281062af1d ("userfaultfd: wp: add WP pagetable tracking to x86")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig~mm-userfaultfd-disable-userfaultfd-wp-on-x86_32
+++ a/arch/x86/Kconfig
@@ -149,7 +149,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
-	select HAVE_ARCH_USERFAULTFD_WP		if USERFAULTFD
+	select HAVE_ARCH_USERFAULTFD_WP         if X86_64 && USERFAULTFD
 	select HAVE_ARCH_VMAP_STACK		if X86_64
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_ASM_MODVERSIONS
_

Patches currently in -mm which might be from peterx@redhat.com are
