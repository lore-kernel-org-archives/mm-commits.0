From: akpm@linux-foundation.org
Subject: + delete-unused-header-file-linux-if_wanpipe_commonh.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:33:42 -0800
Message-ID: <200703250833.l2P8Xg5J023862@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36277 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230AbXCYIdy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, khc@pm.waw.pl


The patch titled
     Delete unused header file linux/if_wanpipe_common.h
has been added to the -mm tree.  Its filename is
     delete-unused-header-file-linux-if_wanpipe_commonh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Delete unused header file linux/if_wanpipe_common.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Delete the unreferenced header file include/linux/if_wanpipe_common.h,
as well as the reference to it in the Doc file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/wan-router.txt |    1 
 include/linux/if_wanpipe_common.h       |   58 ----------------------
 2 files changed, 59 deletions(-)

diff -puN Documentation/networking/wan-router.txt~delete-unused-header-file-linux-if_wanpipe_commonh Documentation/networking/wan-router.txt
--- a/Documentation/networking/wan-router.txt~delete-unused-header-file-linux-if_wanpipe_commonh
+++ a/Documentation/networking/wan-router.txt
@@ -250,7 +250,6 @@ PRODUCT COMPONENTS AND RELATED FILES
 	sdladrv.h	SDLA support module API definitions
 	sdlasfm.h	SDLA firmware module definitions
 	if_wanpipe.h	WANPIPE Socket definitions
-	if_wanpipe_common.h	WANPIPE Socket/Driver common definitions.
 	sdlapci.h	WANPIPE PCI definitions
 	
 
diff -puN include/linux/if_wanpipe_common.h~delete-unused-header-file-linux-if_wanpipe_commonh /dev/null
--- a/include/linux/if_wanpipe_common.h
+++ /dev/null
@@ -1,58 +0,0 @@
-/*****************************************************************************
-* if_wanipe_common.h   Sangoma Driver/Socket common area definitions.
-*
-* Author:       Nenad Corbic <ncorbic@sangoma.com>
-*
-* Copyright:    (c) 2000 Sangoma Technologies Inc.
-*
-*               This program is free software; you can redistribute it and/or
-*               modify it under the terms of the GNU General Public License
-*               as published by the Free Software Foundation; either version
-*               2 of the License, or (at your option) any later version.
-* ============================================================================
-* Jan 13, 2000  Nenad Corbic      Initial version
-*****************************************************************************/
-
-
-#ifndef _WANPIPE_SOCK_DRIVER_COMMON_H
-#define _WANPIPE_SOCK_DRIVER_COMMON_H
-
-typedef struct {
-	struct net_device *slave;
-	atomic_t packet_sent;
-	atomic_t receive_block;
-	atomic_t command;
-	atomic_t disconnect;
-	atomic_t driver_busy;
-	long common_critical;
-	struct timer_list *tx_timer;
-	struct sock *sk;		/* Wanpipe Sock bind's here */ 
-	int (*func)(struct sk_buff *skb, struct net_device *dev, 
-		    struct sock *sk);
-
-	struct work_struct wanpipe_work;    /* deferred keventd work */
-	unsigned char rw_bind;			  /* Sock bind state */
-	unsigned char usedby;
-	unsigned char state;
-	unsigned char svc;
-	unsigned short lcn;
-	void *mbox;
-} wanpipe_common_t;
-
-
-enum {
-	WANSOCK_UNCONFIGURED,	/* link/channel is not configured */
-	WANSOCK_DISCONNECTED,	/* link/channel is disconnected */
-	WANSOCK_CONNECTING,		/* connection is in progress */
-	WANSOCK_CONNECTED,		/* link/channel is operational */
-	WANSOCK_LIMIT,		/* for verification only */
-	WANSOCK_DUALPORT,		/* for Dual Port cards */
-	WANSOCK_DISCONNECTING,
-	WANSOCK_BINDED,
-	WANSOCK_BIND_LISTEN,
-	WANSOCK_LISTEN
-};
-
-#endif
-
-
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-mtd.patch
jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
mtd-delete-unused-header-file-linux-mtd-iflashh.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-linux-awe_voiceh.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
