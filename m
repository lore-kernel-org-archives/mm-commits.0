From: akpm@linux-foundation.org
Subject: [merged] pm-hibernate-use-set_memoryh-header.patch removed
 from -mm tree
Date: Tue, 09 May 2017 11:03:24 -0700
Message-ID: <20170509180324.Iu1Sy9fbf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34864 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754505AbdEISDZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/power/snapshot.c: use set_memory.h header
has been removed from the -mm tree.  Its filename was
     pm-hibernate-use-set_memoryh-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from labbott@redhat.com are


