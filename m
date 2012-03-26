From: akpm@linux-foundation.org
Subject: [merged] init-do_mountsc-print-error-code-on-mount-failure.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:12 -0700
Message-ID: <20120326193112.57AABA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58916 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2CZTbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:13 -0400
Received: by mail-ee0-f74.google.com with SMTP id c41so293942eek.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bernhard@bwalle.de, mm-commits@vger.kernel.org


The patch titled
     Subject: init/do_mounts.c: print error code on mount failure
has been removed from the -mm tree.  Its filename was
     init-do_mountsc-print-error-code-on-mount-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bernhard Walle <bernhard@bwalle.de>
Subject: init/do_mounts.c: print error code on mount failure

Printing the error code makes it easier to debug the cause of a mount
failure.  For example I had the problem that the root file system could
not be mounted read-writeable because my SD card was write-protected. 
Without an error code it looks like the SD card was not detected at all.

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/do_mounts.c~init-do_mountsc-print-error-code-on-mount-failure init/do_mounts.c
--- a/init/do_mounts.c~init-do_mountsc-print-error-code-on-mount-failure
+++ a/init/do_mounts.c
@@ -373,8 +373,8 @@ retry:
 #ifdef CONFIG_BLOCK
 		__bdevname(ROOT_DEV, b);
 #endif
-		printk("VFS: Cannot open root device \"%s\" or %s\n",
-				root_device_name, b);
+		printk("VFS: Cannot open root device \"%s\" or %s: error %d\n",
+				root_device_name, b, err);
 		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
 
 		printk_all_partitions();
_

Patches currently in -mm which might be from bernhard@bwalle.de are

origin.patch
linux-next.patch

