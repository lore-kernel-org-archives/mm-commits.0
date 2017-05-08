From: akpm@linux-foundation.org
Subject: [patch 079/114] kernel/power/snapshot.c: use set_memory.h
 header
Date: Mon, 08 May 2017 15:58:32 -0700
Message-ID: <20170508225832.Xpk_JPX6y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbdEHW6d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: kernel/power/snapshot.c: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-13-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/power/snapshot.c~pm-hibernate-use-set_memoryh-header kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~pm-hibernate-use-set_memoryh-header
+++ a/kernel/power/snapshot.c
@@ -36,6 +36,9 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
+#ifdef CONFIG_STRICT_KERNEL_RWX
+#include <asm/set_memory.h>
+#endif
 
 #include "power.h"
 
_
