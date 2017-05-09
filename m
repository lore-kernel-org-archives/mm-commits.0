From: akpm@linux-foundation.org
Subject: [merged] agp-use-set_memoryh-header.patch removed from -mm
 tree
Date: Tue, 09 May 2017 11:03:15 -0700
Message-ID: <20170509180315.8bbhB8pq2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34832 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754423AbdEISDQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: agp: use set_memory.h header
has been removed from the -mm tree.  Its filename was
     agp-use-set_memoryh-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: agp: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-7-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd-k7-agp.c |    1 +
 drivers/char/agp/ati-agp.c    |    1 +
 drivers/char/agp/generic.c    |    4 +++-
 drivers/char/agp/intel-gtt.c  |    1 +
 drivers/char/agp/sworks-agp.c |    1 +
 5 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/amd-k7-agp.c~agp-use-set_memoryh-header drivers/char/agp/amd-k7-agp.c
--- a/drivers/char/agp/amd-k7-agp.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/amd-k7-agp.c
@@ -9,6 +9,7 @@
 #include <linux/page-flags.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <asm/set_memory.h>
 #include "agp.h"
 
 #define AMD_MMBASE_BAR	1
diff -puN drivers/char/agp/ati-agp.c~agp-use-set_memoryh-header drivers/char/agp/ati-agp.c
--- a/drivers/char/agp/ati-agp.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/ati-agp.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/agp_backend.h>
 #include <asm/agp.h>
+#include <asm/set_memory.h>
 #include "agp.h"
 
 #define ATI_GART_MMBASE_BAR	1
diff -puN drivers/char/agp/generic.c~agp-use-set_memoryh-header drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/generic.c
@@ -39,7 +39,9 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <asm/io.h>
-#include <asm/cacheflush.h>
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
 #include <asm/pgtable.h>
 #include "agp.h"
 
diff -puN drivers/char/agp/intel-gtt.c~agp-use-set_memoryh-header drivers/char/agp/intel-gtt.c
--- a/drivers/char/agp/intel-gtt.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/intel-gtt.c
@@ -25,6 +25,7 @@
 #include "agp.h"
 #include "intel-agp.h"
 #include <drm/intel-gtt.h>
+#include <asm/set_memory.h>
 
 /*
  * If we have Intel graphics, we're not going to have anything other than
diff -puN drivers/char/agp/sworks-agp.c~agp-use-set_memoryh-header drivers/char/agp/sworks-agp.c
--- a/drivers/char/agp/sworks-agp.c~agp-use-set_memoryh-header
+++ a/drivers/char/agp/sworks-agp.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/jiffies.h>
 #include <linux/agp_backend.h>
+#include <asm/set_memory.h>
 #include "agp.h"
 
 #define SVWRKS_COMMAND		0x04
_

Patches currently in -mm which might be from labbott@redhat.com are


