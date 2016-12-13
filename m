From: akpm@linux-foundation.org
Subject: [patch 113/123] lib/Kconfig.debug: make CONFIG_STRICT_DEVMEM
 depend on CONFIG_DEVMEM
Date: Mon, 12 Dec 2016 16:46:14 -0800
Message-ID: <584f44d6.wkpA6x0ZeaJ6dD0H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42004 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932602AbcLMAqP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dyoung@redhat.com, aryabinin@virtuozzo.com, dan.j.williams@intel.com, dvyukov@google.com, jpoimboe@redhat.com, keescook@chromium.org, mingo@kernel.org, nikolay@cumulusnetworks.com, tj@kernel.org

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
@@ -2005,7 +2005,7 @@ config ARCH_HAS_DEVMEM_IS_ALLOWED
 
 config STRICT_DEVMEM
 	bool "Filter access to /dev/mem"
-	depends on MMU
+	depends on MMU && DEVMEM
 	depends on ARCH_HAS_DEVMEM_IS_ALLOWED
 	default y if TILE || PPC
 	---help---
_
