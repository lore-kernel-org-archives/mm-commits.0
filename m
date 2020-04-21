From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 03/15] mm/userfaultfd: disable userfaultfd-wp on
 x86_32
Date: Mon, 20 Apr 2020 18:13:45 -0700
Message-ID: <20200421011345.oj5QRcygo%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbgDUBNq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 21:13:46 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, hdanton@sina.com, linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org, peterx@redhat.com, torvalds@linux-foundation.org

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
