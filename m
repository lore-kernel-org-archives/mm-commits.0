From: akpm@linux-foundation.org
Subject: [merged] init-do_mounts-initrd_load-can-be-boolean.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 14:59:24 -0800
Message-ID: <56a162cc.wMh8CWB2f2qHa4PP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbcAUW7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init/do_mounts: initrd_load() can be boolean
has been removed from the -mm tree.  Its filename was
     init-do_mounts-initrd_load-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: init/do_mounts: initrd_load() can be boolean

Make initrd_load() return bool due to this particular function only using
either one or zero as its return value.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.h        |    4 ++--
 init/do_mounts_initrd.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN init/do_mounts.h~init-do_mounts-initrd_load-can-be-boolean init/do_mounts.h
--- a/init/do_mounts.h~init-do_mounts-initrd_load-can-be-boolean
+++ a/init/do_mounts.h
@@ -57,11 +57,11 @@ static inline int rd_load_image(char *fr
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-int __init initrd_load(void);
+bool __init initrd_load(void);
 
 #else
 
-static inline int initrd_load(void) { return 0; }
+static inline bool initrd_load(void) { return false; }
 
 #endif
 
diff -puN init/do_mounts_initrd.c~init-do_mounts-initrd_load-can-be-boolean init/do_mounts_initrd.c
--- a/init/do_mounts_initrd.c~init-do_mounts-initrd_load-can-be-boolean
+++ a/init/do_mounts_initrd.c
@@ -116,7 +116,7 @@ static void __init handle_initrd(void)
 	}
 }
 
-int __init initrd_load(void)
+bool __init initrd_load(void)
 {
 	if (mount_initrd) {
 		create_dev("/dev/ram", Root_RAM0);
@@ -129,9 +129,9 @@ int __init initrd_load(void)
 		if (rd_load_image("/initrd.image") && ROOT_DEV != Root_RAM0) {
 			sys_unlink("/initrd.image");
 			handle_initrd();
-			return 1;
+			return true;
 		}
 	}
 	sys_unlink("/initrd.image");
-	return 0;
+	return false;
 }
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are


