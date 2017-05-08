From: akpm@linux-foundation.org
Subject: [patch 076/114] drivers/watchdog/hpwdt.c: use set_memory.h
 header
Date: Mon, 08 May 2017 15:58:23 -0700
Message-ID: <20170508225823.NYorkeUgp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdEHW6Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, linux@roeck-us.net, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: drivers/watchdog/hpwdt.c: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-10-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/watchdog/hpwdt.c~watchdog-hpwdt-use-set_memoryh-header drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~watchdog-hpwdt-use-set_memoryh-header
+++ a/drivers/watchdog/hpwdt.c
@@ -34,7 +34,7 @@
 #include <linux/nmi.h>
 #include <linux/kdebug.h>
 #include <linux/notifier.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 #include <asm/nmi.h>
 #include <asm/frame.h>
_
