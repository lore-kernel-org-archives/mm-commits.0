From: akpm@linux-foundation.org
Subject: [patch 078/114] kernel/module.c: use set_memory.h header
Date: Mon, 08 May 2017 15:58:29 -0700
Message-ID: <20170508225829.k-7Jh6kMo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbdEHW6a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeyu@redhat.com, labbott@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: kernel/module.c: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-12-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Jessica Yu <jeyu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/module.c~module-use-set_memoryh-header kernel/module.c
--- a/kernel/module.c~module-use-set_memoryh-header
+++ a/kernel/module.c
@@ -49,6 +49,9 @@
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
+#ifdef CONFIG_STRICT_MODULE_RWX
+#include <asm/set_memory.h>
+#endif
 #include <asm/mmu_context.h>
 #include <linux/license.h>
 #include <asm/sections.h>
_
