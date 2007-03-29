From: akpm@linux-foundation.org
Subject: - remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:53 -0700
Message-ID: <200703292337.l2TNbrjD015158@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945927AbXC2Xh6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:37:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     remove unused header file: drivers/net/skfp/h/lnkstat.h
has been removed from the -mm tree.  Its filename was
     remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove unused header file: drivers/net/skfp/h/lnkstat.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skfp/h/lnkstat.h |   84 ---------------------------------
 1 file changed, 84 deletions(-)

diff -puN drivers/net/skfp/h/lnkstat.h~remove-unused-header-file-drivers-net-skfp-h-lnkstath /dev/null
--- a/drivers/net/skfp/h/lnkstat.h
+++ /dev/null
@@ -1,84 +0,0 @@
-/******************************************************************************
- *
- *	(C)Copyright 1998,1999 SysKonnect,
- *	a business unit of Schneider & Koch & Co. Datensysteme GmbH.
- *
- *	This program is free software; you can redistribute it and/or modify
- *	it under the terms of the GNU General Public License as published by
- *	the Free Software Foundation; either version 2 of the License, or
- *	(at your option) any later version.
- *
- *	The information in this file is provided "AS IS" without warranty.
- *
- ******************************************************************************/
-
-/*
- * Definition of the Error Log Structure
- * This structure will be copied into the Error Log buffer
- * during the NDIS General Request ReadErrorLog by the MAC Driver
- */
-
-struct	s_error_log {
-
-	/*
-	 * place holder for token ring adapter error log (zeros)
-	 */
-	u_char	reserved_0 ;			/* byte 0 inside Error Log */
-	u_char	reserved_1 ;			/* byte 1 */
-	u_char	reserved_2 ;			/* byte 2 */	
-	u_char	reserved_3 ;			/* byte 3 */
-	u_char	reserved_4 ;			/* byte 4 */
-	u_char	reserved_5 ;			/* byte 5 */
-	u_char	reserved_6 ;			/* byte 6 */
-	u_char	reserved_7 ;			/* byte 7 */
-	u_char	reserved_8 ;			/* byte 8 */
-	u_char	reserved_9 ;			/* byte 9 */
-	u_char	reserved_10 ;			/* byte 10 */
-	u_char	reserved_11 ;			/* byte 11 */
-	u_char	reserved_12 ;			/* byte 12 */
-	u_char	reserved_13 ;			/* byte 13 */
-
-	/*
-	 * FDDI link statistics 
-	 */
-/*
- * smt error low
- */
-#define SMT_ERL_AEB	(1<<15)			/* A elast. buffer */
-#define SMT_ERL_BLC	(1<<14)			/* B link error condition */
-#define SMT_ERL_ALC	(1<<13)			/* A link error condition */
-#define SMT_ERL_NCC	(1<<12)			/* not copied condition */
-#define SMT_ERL_FEC	(1<<11)			/* frame error condition */
-
-/*
- * smt event low
- */
-#define SMT_EVL_NCE	(1<<5)
-
-	u_short	smt_error_low ;			/* byte 14/15 */
-	u_short	smt_error_high ;		/* byte 16/17 */
-	u_short	smt_event_low ;			/* byte 18/19 */
-	u_short	smt_event_high ;		/* byte 20/21 */
-	u_short	connection_policy_violation ;	/* byte 22/23 */
-	u_short port_event ;			/* byte 24/25 */
-	u_short set_count_low ;			/* byte 26/27 */
-	u_short set_count_high ;		/* byte 28/29 */
-	u_short	aci_id_code ;			/* byte 30/31 */
-	u_short	purge_frame_counter ;		/* byte 32/33 */
-
-	/*
-	 * CMT and RMT state machines
-	 */
-	u_short	ecm_state ;			/* byte 34/35 */
-	u_short	pcm_a_state ;			/* byte 36/37 */
-	u_short pcm_b_state ;			/* byte 38/39 */
-	u_short	cfm_state ;			/* byte 40/41 */
-	u_short	rmt_state ;			/* byte 42/43 */
-
-	u_short	not_used[30] ;			/* byte 44-103 */
-
-	u_short	ucode_version_level ;		/* byte 104/105 */
-
-	u_short	not_used_1 ;			/* byte 106/107 */
-	u_short not_used_2 ;			/* byte 108/109 */
-} ;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-mtd.patch
jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch
git-netdev-all.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
pcmcia-allow-pcmcia-scsi-drivers-to-be-built-into-the.patch
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
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
