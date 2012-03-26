From: akpm@linux-foundation.org
Subject: [merged] headers-include-linux-typesh-where-appropriate.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:15 -0700
Message-ID: <20120326192815.8EF65A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:57483 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2CZT2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:18 -0400
Received: by wejx9 with SMTP id x9so290097wej.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobbypowers@gmail.com, James.Bottomley@HansenPartnership.com, airlied@linux.ie, cjb@laptop.org, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: headers: include linux/types.h where appropriate
has been removed from the -mm tree.  Its filename was
     headers-include-linux-typesh-where-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bobby Powers <bobbypowers@gmail.com>
Subject: headers: include linux/types.h where appropriate

This addresses some header check warnings.  DRM headers which include
"drm.h" have been excluded, as they indirectly include types.h.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/drm/drm_mode.h          |    2 ++
 include/linux/mmc/ioctl.h       |    3 +++
 include/scsi/scsi_netlink.h     |    2 +-
 include/sound/compress_params.h |    2 ++
 4 files changed, 8 insertions(+), 1 deletion(-)

diff -puN include/drm/drm_mode.h~headers-include-linux-typesh-where-appropriate include/drm/drm_mode.h
--- a/include/drm/drm_mode.h~headers-include-linux-typesh-where-appropriate
+++ a/include/drm/drm_mode.h
@@ -27,6 +27,8 @@
 #ifndef _DRM_MODE_H
 #define _DRM_MODE_H
 
+#include <linux/types.h>
+
 #define DRM_DISPLAY_INFO_LEN	32
 #define DRM_CONNECTOR_NAME_LEN	32
 #define DRM_DISPLAY_MODE_LEN	32
diff -puN include/linux/mmc/ioctl.h~headers-include-linux-typesh-where-appropriate include/linux/mmc/ioctl.h
--- a/include/linux/mmc/ioctl.h~headers-include-linux-typesh-where-appropriate
+++ a/include/linux/mmc/ioctl.h
@@ -1,5 +1,8 @@
 #ifndef LINUX_MMC_IOCTL_H
 #define LINUX_MMC_IOCTL_H
+
+#include <linux/types.h>
+
 struct mmc_ioc_cmd {
 	/* Implies direction of data.  true = write, false = read */
 	int write_flag;
diff -puN include/scsi/scsi_netlink.h~headers-include-linux-typesh-where-appropriate include/scsi/scsi_netlink.h
--- a/include/scsi/scsi_netlink.h~headers-include-linux-typesh-where-appropriate
+++ a/include/scsi/scsi_netlink.h
@@ -23,7 +23,7 @@
 #define SCSI_NETLINK_H
 
 #include <linux/netlink.h>
