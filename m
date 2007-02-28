From: akpm@linux-foundation.org
Subject: - usb-section-fixes.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:53:51 -0800
Message-ID: <200702282353.l1SNrpRu031153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48425 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643AbXB1Xxz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:53:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb section fixes
has been removed from the -mm tree.  Its filename was
     usb-section-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb section fixes
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fixes this link error. (found on ia64.)

  LD      .tmp_vmlinux1
`mon_bin_exit' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`mon_text_exit' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/mon/mon_bin.c  |    2 +-
 drivers/usb/mon/mon_text.c |    2 +-
 drivers/usb/mon/usb_mon.h  |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/usb/mon/mon_bin.c~usb-section-fixes drivers/usb/mon/mon_bin.c
--- a/drivers/usb/mon/mon_bin.c~usb-section-fixes
+++ a/drivers/usb/mon/mon_bin.c
@@ -1165,7 +1165,7 @@ err_dev:
 	return rc;
 }
 
-void __exit mon_bin_exit(void)
+void mon_bin_exit(void)
 {
 	cdev_del(&mon_bin_cdev);
 	unregister_chrdev_region(mon_bin_dev0, MON_BIN_MAX_MINOR);
diff -puN drivers/usb/mon/mon_text.c~usb-section-fixes drivers/usb/mon/mon_text.c
--- a/drivers/usb/mon/mon_text.c~usb-section-fixes
+++ a/drivers/usb/mon/mon_text.c
@@ -520,7 +520,7 @@ int __init mon_text_init(void)
 	return 0;
 }
 
-void __exit mon_text_exit(void)
+void mon_text_exit(void)
 {
 	debugfs_remove(mon_dir);
 }
diff -puN drivers/usb/mon/usb_mon.h~usb-section-fixes drivers/usb/mon/usb_mon.h
--- a/drivers/usb/mon/usb_mon.h~usb-section-fixes
+++ a/drivers/usb/mon/usb_mon.h
@@ -56,10 +56,10 @@ int /*bool*/ mon_text_add(struct mon_bus
 void mon_text_del(struct mon_bus *mbus);
 // void mon_bin_add(struct mon_bus *);
 
-int __init mon_text_init(void);
-void __exit mon_text_exit(void);
-int __init mon_bin_init(void);
-void __exit mon_bin_exit(void);
+extern int mon_text_init(void) __init;
+extern void mon_text_exit(void);
+extern int  mon_bin_init(void) __init;
+extern void mon_bin_exit(void);
 
 /*
  * DMA interface.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

reiser4-hardirq-include-fix.patch
