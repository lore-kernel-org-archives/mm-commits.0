From: akpm@linux-foundation.org
Subject: - delete-unused-header-file-linux-if_wanpipe_commonh.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:53:27 -0700
Message-ID: <200704281053.l3SArRVr020084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965692AbXD1Kxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     Delete unused header file linux/if_wanpipe_common.h
has been removed from the -mm tree.  Its filename was
     delete-unused-header-file-linux-if_wanpipe_commonh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-powerpc.patch
git-drm.patch
git-input.patch
git-netdev-all.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
arm26-remove-useless-config-option-generic_bust_spinlock.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
cris-remove-code-related-to-pre-22-kernel.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
add-spaces-on-either-side-of-case-operator.patch
clarify-the-creation-of-the-localversion_auto-string.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
video-add-spaces-on-either-side-of-the-case-operator.patch
