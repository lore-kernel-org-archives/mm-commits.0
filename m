From: akpm@linux-foundation.org
Subject: - move-task_xacct-task_io_accounting-up-in-menus.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:36 -0800
Message-ID: <200702112255.l1BMtaP3016337@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60613 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932878AbXBKWzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Move TASK_XACCT, TASK_IO_ACCOUNTING up in menus
has been removed from the -mm tree.  Its filename was
     move-task_xacct-task_io_accounting-up-in-menus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Move TASK_XACCT, TASK_IO_ACCOUNTING up in menus
From: Alexey Dobriyan <adobriyan@gmail.com>

Since they depends on TASKSTATS, it would be nice to move them closer to
another options depending on TASKSTATS.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN init/Kconfig~move-task_xacct-task_io_accounting-up-in-menus init/Kconfig
--- a/init/Kconfig~move-task_xacct-task_io_accounting-up-in-menus
+++ a/init/Kconfig
@@ -192,6 +192,24 @@ config TASK_DELAY_ACCT
 
 	  Say N if unsure.
 
+config TASK_XACCT
+	bool "Enable extended accounting over taskstats (EXPERIMENTAL)"
+	depends on TASKSTATS
+	help
+	  Collect extended task accounting data and send the data
+	  to userland for processing over the taskstats interface.
+
+	  Say N if unsure.
+
+config TASK_IO_ACCOUNTING
+	bool "Enable per-task storage I/O accounting (EXPERIMENTAL)"
+	depends on TASK_XACCT
+	help
+	  Collect information on the number of bytes of storage I/O which this
+	  task has caused.
+
+	  Say N if unsure.
+
 config UTS_NS
 	bool "UTS Namespaces"
 	default n
@@ -299,24 +317,6 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
-config TASK_XACCT
-	bool "Enable extended accounting over taskstats (EXPERIMENTAL)"
-	depends on TASKSTATS
-	help
-	  Collect extended task accounting data and send the data
-	  to userland for processing over the taskstats interface.
-
-	  Say N if unsure.
-
-config TASK_IO_ACCOUNTING
-	bool "Enable per-task storage I/O accounting (EXPERIMENTAL)"
-	depends on TASK_XACCT
-	help
-	  Collect information on the number of bytes of storage I/O which this
-	  task has caused.
-
-	  Say N if unsure.
-
 config SYSCTL
 	bool
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
recognize-video=gx1fb-option.patch
