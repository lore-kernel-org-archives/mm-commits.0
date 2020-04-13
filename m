From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-disable-userfaultfd-wp-on-x86_32.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 13:01:14 -0700
Message-ID: <20200413200114.wA3Wv6ffh%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388135AbgDMUBP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 16:01:15 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hdanton@sina.com, lkp@intel.com, mm-commits@vger.kernel.org, naresh.kamboju@linaro.org, peterx@redhat.com


The patch titled
     Subject: mm/userfaultfd: disable userfaultfd-wp on x86_32
has been added to the -mm tree.  Its filename is
     mm-userfaultfd-disable-userfaultfd-wp-on-x86_32.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-userfaultfd-disable-userfaultfd-wp-on-x86_32.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-userfaultfd-disable-userfaultfd-wp-on-x86_32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -150,7 +150,7 @@ config X86
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

mm-userfaultfd-disable-userfaultfd-wp-on-x86_32.patch
