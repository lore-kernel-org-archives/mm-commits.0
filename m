From: akpm@linux-foundation.org
Subject: + headers-include-linux-typesh-where-appropriate.patch added to -mm tree
Date: Fri, 24 Feb 2012 11:49:52 -0800
Message-ID: <20120224194952.B4CD1A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57201 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2BXTtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 14:49:55 -0500
Received: by faaa19 with SMTP id a19so98709faa.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 11:49:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bobbypowers@gmail.com, James.Bottomley@HansenPartnership.com, airlied@linux.ie, cjb@laptop.org, tiwai@suse.de


The patch titled
     Subject: headers: include linux/types.h where appropriate
has been added to the -mm tree.  Its filename is
     headers-include-linux-typesh-where-appropriate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
