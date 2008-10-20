From: akpm@linux-foundation.org
Subject: - memory_probe-fix-wrong-sysfs-file-attribute.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:01 -0700
Message-ID: <200810202034.m9KKY16s010750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208AbYJTUem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     memory_probe: fix wrong sysfs file attribute
has been removed from the -mm tree.  Its filename was
     memory_probe-fix-wrong-sysfs-file-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory_probe: fix wrong sysfs file attribute
From: Shaohua Li <shaohua.li@intel.com>

This attribute just has a write operation.

[akpm@linux-foundation.org: use S_IWUSR as suggested by Randy]
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory_probe-fix-wrong-sysfs-file-attribute drivers/base/memory.c
--- a/drivers/base/memory.c~memory_probe-fix-wrong-sysfs-file-attribute
+++ a/drivers/base/memory.c
@@ -21,6 +21,8 @@
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/stat.h>
+
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
@@ -325,7 +327,7 @@ memory_probe_store(struct class *class, 
 
 	return count;
 }
-static CLASS_ATTR(probe, 0700, NULL, memory_probe_store);
+static CLASS_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
 
 static int memory_probe_init(void)
 {
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch

