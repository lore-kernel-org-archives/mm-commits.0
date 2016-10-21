From: akpm@linux-foundation.org
Subject: + let-config_strict_devmem-depends-on-config_devmem.patch added
 to -mm tree
Date: Thu, 20 Oct 2016 20:38:11 -0700
Message-ID: <58098da3.wZL7iE9fkNke8PA2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbcJUDiM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2016 23:38:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, aryabinin@virtuozzo.com, dan.j.williams@intel.com, dvyukov@google.com, jpoimboe@redhat.com, keescook@chromium.org, mingo@kernel.org, nikolay@cumulusnetworks.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: make CONFIG_STRICT_DEVMEM depend on CONFIG_DEVMEM
has been added to the -mm tree.  Its filename is
     let-config_strict_devmem-depends-on-config_devmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/let-config_strict_devmem-depends-on-config_devmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/let-config_strict_devmem-depends-on-config_devmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: lib/Kconfig.debug: make CONFIG_STRICT_DEVMEM depend on CONFIG_DEVMEM

With CONFIG_DEVMEM not set, CONFIG_STRICT_DEVMEM will be useless even if
it is set =y, thus let's update the dependency in Kconfig.

Link: http://lkml.kernel.org/r/20161006051217.GA31027@dhcp-128-65.nay.redhat.com
Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~let-config_strict_devmem-depends-on-config_devmem lib/Kconfig.debug
--- a/lib/Kconfig.debug~let-config_strict_devmem-depends-on-config_devmem
+++ a/lib/Kconfig.debug
@@ -1972,7 +1972,7 @@ config ARCH_HAS_DEVMEM_IS_ALLOWED
 
 config STRICT_DEVMEM
 	bool "Filter access to /dev/mem"
-	depends on MMU
+	depends on MMU && DEVMEM
 	depends on ARCH_HAS_DEVMEM_IS_ALLOWED
 	default y if TILE || PPC
 	---help---
_

Patches currently in -mm which might be from dyoung@redhat.com are

let-config_strict_devmem-depends-on-config_devmem.patch

