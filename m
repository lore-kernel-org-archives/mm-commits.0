From: akpm@linux-foundation.org
Subject: [withdrawn] drivers-media-video-uvc-use-%pul-to-print-uuids.patch removed from -mm tree
Date: Tue, 10 Nov 2009 14:16:09 -0800
Message-ID: <200911102216.nAAMG9it024643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298AbZKJWQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 17:16:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, laurent.pinchart@ideasonboard.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/uvc: use %pUl to print UUIDs
has been removed from the -mm tree.  Its filename was
     drivers-media-video-uvc-use-%pul-to-print-uuids.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/uvc: use %pUl to print UUIDs
From: Joe Perches <joe@perches.com>

This patch includes some changes that Laurent originally
commented on as well as the Buffer[5]/buffer[5] correction.

http://lkml.org/lkml/2009/9/30/399

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/uvc/uvc_ctrl.c   |   74 +++++++++++--------------
 drivers/media/video/uvc/uvc_driver.c |    9 +--
 drivers/media/video/uvc/uvcvideo.h   |   10 ---
 3 files changed, 38 insertions(+), 55 deletions(-)

diff -puN drivers/media/video/uvc/uvc_ctrl.c~drivers-media-video-uvc-use-%pul-to-print-uuids drivers/media/video/uvc/uvc_ctrl.c
--- a/drivers/media/video/uvc/uvc_ctrl.c~drivers-media-video-uvc-use-%pul-to-print-uuids
+++ a/drivers/media/video/uvc/uvc_ctrl.c
@@ -1099,10 +1099,9 @@ int uvc_xu_ctrl_query(struct uvc_video_c
 	}
 
 	if (!found) {
-		uvc_trace(UVC_TRACE_CONTROL,
-			"Control " UVC_GUID_FORMAT "/%u not found.\n",
-			UVC_GUID_ARGS(entity->extension.guidExtensionCode),
-			xctrl->selector);
+		uvc_trace(UVC_TRACE_CONTROL, "Control %pUl/%u not found.\n",
+			  entity->extension.guidExtensionCode,
+			  xctrl->selector);
 		return -EINVAL;
 	}
 
@@ -1178,9 +1177,9 @@ int uvc_ctrl_resume_device(struct uvc_de
 			    (ctrl->info->flags & UVC_CONTROL_RESTORE) == 0)
 				continue;
 
-			printk(KERN_INFO "restoring control " UVC_GUID_FORMAT
-				"/%u/%u\n", UVC_GUID_ARGS(ctrl->info->entity),
-				ctrl->info->index, ctrl->info->selector);
+			printk(KERN_INFO "restoring control %pUl/%u/%u\n",
+			       ctrl->info->entity,
+			       ctrl->info->index, ctrl->info->selector);
 			ctrl->dirty = 1;
 		}
 
@@ -1234,47 +1233,44 @@ static void uvc_ctrl_add_ctrl(struct uvc
 		ret = uvc_query_ctrl(dev, UVC_GET_LEN, ctrl->entity->id,
 			dev->intfnum, info->selector, (__u8 *)&size, 2);
 		if (ret < 0) {
-			uvc_trace(UVC_TRACE_CONTROL, "GET_LEN failed on "
-				"control " UVC_GUID_FORMAT "/%u (%d).\n",
-				UVC_GUID_ARGS(info->entity), info->selector,
-				ret);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "GET_LEN failed on control %pUl/%u (%d).\n",
+				  info->entity, info->selector, ret);
 			return;
 		}
 
 		if (info->size != le16_to_cpu(size)) {
-			uvc_trace(UVC_TRACE_CONTROL, "Control " UVC_GUID_FORMAT
-				"/%u size doesn't match user supplied "
-				"value.\n", UVC_GUID_ARGS(info->entity),
-				info->selector);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Control %pUl/%u size doesn't match user supplied value.\n",
+				  info->entity, info->selector);
 			return;
 		}
 
 		ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
 			dev->intfnum, info->selector, &inf, 1);
 		if (ret < 0) {
-			uvc_trace(UVC_TRACE_CONTROL, "GET_INFO failed on "
-				"control " UVC_GUID_FORMAT "/%u (%d).\n",
-				UVC_GUID_ARGS(info->entity), info->selector,
-				ret);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "GET_INFO failed on control %pUl/%u (%d).\n",
+				  info->entity, info->selector, ret);
 			return;
 		}
 
 		flags = info->flags;
 		if (((flags & UVC_CONTROL_GET_CUR) && !(inf & (1 << 0))) ||
 		    ((flags & UVC_CONTROL_SET_CUR) && !(inf & (1 << 1)))) {
-			uvc_trace(UVC_TRACE_CONTROL, "Control "
-				UVC_GUID_FORMAT "/%u flags don't match "
-				"supported operations.\n",
-				UVC_GUID_ARGS(info->entity), info->selector);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Control %pUl/%u flags don't match supported operations.\n",
+				  info->entity, info->selector);
 			return;
 		}
 	}
 
 	ctrl->info = info;
 	ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL);
-	uvc_trace(UVC_TRACE_CONTROL, "Added control " UVC_GUID_FORMAT "/%u "
-		"to device %s entity %u\n", UVC_GUID_ARGS(ctrl->info->entity),
-		ctrl->info->selector, dev->udev->devpath, entity->id);
+	uvc_trace(UVC_TRACE_CONTROL,
+		  "Added control %pUl/%u to device %s entity %u\n",
+		  ctrl->info->entity, ctrl->info->selector,
+		  dev->udev->devpath, entity->id);
 }
 
 /*
@@ -1300,17 +1296,16 @@ int uvc_ctrl_add_info(struct uvc_control
 			continue;
 
 		if (ctrl->selector == info->selector) {
-			uvc_trace(UVC_TRACE_CONTROL, "Control "
-				UVC_GUID_FORMAT "/%u is already defined.\n",
-				UVC_GUID_ARGS(info->entity), info->selector);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Control %pUl/%u is already defined.\n",
+				  info->entity, info->selector);
 			ret = -EEXIST;
 			goto end;
 		}
 		if (ctrl->index == info->index) {
-			uvc_trace(UVC_TRACE_CONTROL, "Control "
-				UVC_GUID_FORMAT "/%u would overwrite index "
-				"%d.\n", UVC_GUID_ARGS(info->entity),
-				info->selector, info->index);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Control %pUl/%u would overwrite index %d.\n",
+				  info->entity, info->selector, info->index);
 			ret = -EEXIST;
 			goto end;
 		}
@@ -1351,10 +1346,9 @@ int uvc_ctrl_add_mapping(struct uvc_cont
 			continue;
 
 		if (info->size * 8 < mapping->size + mapping->offset) {
-			uvc_trace(UVC_TRACE_CONTROL, "Mapping '%s' would "
-				"overflow control " UVC_GUID_FORMAT "/%u\n",
-				mapping->name, UVC_GUID_ARGS(info->entity),
-				info->selector);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Mapping '%s' would overflow control %pUl/%u\n",
+				  mapping->name, info->entity, info->selector);
 			ret = -EOVERFLOW;
 			goto end;
 		}
@@ -1373,9 +1367,9 @@ int uvc_ctrl_add_mapping(struct uvc_cont
 
 		mapping->ctrl = info;
 		list_add_tail(&mapping->list, &info->mappings);
-		uvc_trace(UVC_TRACE_CONTROL, "Adding mapping %s to control "
-			UVC_GUID_FORMAT "/%u.\n", mapping->name,
-			UVC_GUID_ARGS(info->entity), info->selector);
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "Adding mapping %s to control %pUl/%u.\n",
+			  mapping->name, info->entity, info->selector);
 
 		ret = 0;
 		break;
diff -puN drivers/media/video/uvc/uvc_driver.c~drivers-media-video-uvc-use-%pul-to-print-uuids drivers/media/video/uvc/uvc_driver.c
--- a/drivers/media/video/uvc/uvc_driver.c~drivers-media-video-uvc-use-%pul-to-print-uuids
+++ a/drivers/media/video/uvc/uvc_driver.c
@@ -329,11 +329,10 @@ static int uvc_parse_format(struct uvc_d
 				sizeof format->name);
 			format->fcc = fmtdesc->fcc;
 		} else {
-			uvc_printk(KERN_INFO, "Unknown video format "
-				UVC_GUID_FORMAT "\n",
-				UVC_GUID_ARGS(&buffer[5]));
-			snprintf(format->name, sizeof format->name,
-				UVC_GUID_FORMAT, UVC_GUID_ARGS(&buffer[5]));
+			uvc_printk(KERN_INFO, "Unknown video format %pUl\n",
+				   &buffer[5]);
+			snprintf(format->name, sizeof format->name, "%pUl",
+				 &buffer[5]);
 			format->fcc = 0;
 		}
 
diff -puN drivers/media/video/uvc/uvcvideo.h~drivers-media-video-uvc-use-%pul-to-print-uuids drivers/media/video/uvc/uvcvideo.h
--- a/drivers/media/video/uvc/uvcvideo.h~drivers-media-video-uvc-use-%pul-to-print-uuids
+++ a/drivers/media/video/uvc/uvcvideo.h
@@ -555,16 +555,6 @@ extern unsigned int uvc_timeout_param;
 #define uvc_printk(level, msg...) \
 	printk(level "uvcvideo: " msg)
 
-#define UVC_GUID_FORMAT "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-" \
-			"%02x%02x%02x%02x%02x%02x"
-#define UVC_GUID_ARGS(guid) \
-	(guid)[3],  (guid)[2],  (guid)[1],  (guid)[0], \
-	(guid)[5],  (guid)[4], \
-	(guid)[7],  (guid)[6], \
-	(guid)[8],  (guid)[9], \
-	(guid)[10], (guid)[11], (guid)[12], \
-	(guid)[13], (guid)[14], (guid)[15]
-
 /* --------------------------------------------------------------------------
  * Internal functions.
  */
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-asus-acpi-extras-remove-f-arch-x86-kernel-acpi-bootc.patch
maintainers-brocade-bfa-use-single-line-m-and-tabs.patch
maintainers-server-engines-10gbps-iscsi-use-single-line-m.patch
maintainers-vmware-vmxnet3-quote-name-with-comma-and-period-use-tabs.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
scripts-get_maintainerpl-support-multiple-vcss-add-mercurial.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch

