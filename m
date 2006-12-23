From: akpm@osdl.org
Subject: - make-jffs-depend-on-config_broken.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:09 -0800
Message-ID: <200612230754.kBN7s9Jk010186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49676 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbWLWHyM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwboyer@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Make JFFS depend on CONFIG_BROKEN
has been removed from the -mm tree.  Its filename was
     make-jffs-depend-on-config_broken.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make JFFS depend on CONFIG_BROKEN
From: "Josh Boyer" <jwboyer@gmail.com>

Mark JFFS as broken and provide a warning to users that it is deprecated
and scheduled for removal in 2.6.21

Signed-off-by: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/Kconfig~make-jffs-depend-on-config_broken fs/Kconfig
--- a/fs/Kconfig~make-jffs-depend-on-config_broken
+++ a/fs/Kconfig
@@ -1198,13 +1198,16 @@ config EFS_FS
 
 config JFFS_FS
 	tristate "Journalling Flash File System (JFFS) support"
-	depends on MTD && BLOCK
+	depends on MTD && BLOCK && BROKEN
 	help
 	  JFFS is the Journalling Flash File System developed by Axis
 	  Communications in Sweden, aimed at providing a crash/powerdown-safe
 	  file system for disk-less embedded devices. Further information is
 	  available at (<http://developer.axis.com/software/jffs/>).
 
+	  NOTE: This filesystem is deprecated and is scheduled for removal in
+	  2.6.21.  See Documentation/feature-removal-schedule.txt
+
 config JFFS_FS_VERBOSE
 	int "JFFS debugging verbosity (0 = quiet, 3 = noisy)"
 	depends on JFFS_FS
_

Patches currently in -mm which might be from jwboyer@gmail.com are

origin.patch

