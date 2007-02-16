From: akpm@linux-foundation.org
Subject: + drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:10:18 -0800
Message-ID: <200702162110.l1GLAJko009922@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946242AbXBPVNg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, tilman@imap.cc


The patch titled
     drivers/isdn/gigaset/: build asyncdata.o into the gigaset module
has been added to the -mm tree.  Its filename is
     drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/gigaset/: build asyncdata.o into the gigaset module
From: Adrian Bunk <bunk@stusta.de>

  LD      drivers/isdn/gigaset/built-in.o
drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_send_skb':
(.text+0xe50): multiple definition of `gigaset_m10x_send_skb'
drivers/isdn/gigaset/usb_gigaset.o:(.text+0x0): first defined here
drivers/isdn/gigaset/ser_gigaset.o: In function `gigaset_m10x_input':
(.text+0x1121): multiple definition of `gigaset_m10x_input'
drivers/isdn/gigaset/usb_gigaset.o:(.text+0x2d1): first defined here
make[4]: *** [drivers/isdn/gigaset/built-in.o] Error 1

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/Makefile    |    6 +++---
 drivers/isdn/gigaset/asyncdata.c |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/isdn/gigaset/Makefile~drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module drivers/isdn/gigaset/Makefile
--- a/drivers/isdn/gigaset/Makefile~drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module
+++ a/drivers/isdn/gigaset/Makefile
@@ -1,7 +1,7 @@
-gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o
-usb_gigaset-y := usb-gigaset.o asyncdata.o
+gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o asyncdata.o
+usb_gigaset-y := usb-gigaset.o
 bas_gigaset-y := bas-gigaset.o isocdata.o
-ser_gigaset-y := ser-gigaset.o asyncdata.o
+ser_gigaset-y := ser-gigaset.o
 
 obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
 obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
diff -puN drivers/isdn/gigaset/asyncdata.c~drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module drivers/isdn/gigaset/asyncdata.c
--- a/drivers/isdn/gigaset/asyncdata.c~drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module
+++ a/drivers/isdn/gigaset/asyncdata.c
@@ -444,6 +444,7 @@ nextbyte:
 		atomic_set(&inbuf->head, head);
 	}
 }
+EXPORT_SYMBOL_GPL(gigaset_m10x_input);
 
 
 /* == data output ========================================================== */
@@ -591,3 +592,4 @@ int gigaset_m10x_send_skb(struct bc_stat
 
 	return len;	/* ok so far */
 }
+EXPORT_SYMBOL_GPL(gigaset_m10x_send_skb);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
correct-config_gigaset_m101-makefile-entry.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat.patch
git-cpufreq.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
git-mtd.patch
git-ubi.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
