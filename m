From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-media-video-uvc-use-%pul-to-print-uuids.patch removed from -mm tree
Date: Tue, 13 Oct 2009 15:16:22 -0700
Message-ID: <200910132216.n9DMGN2h016496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755AbZJMWRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 18:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/uvc: use %pUl to print UUIDs
has been removed from the -mm tree.  Its filename was
     drivers-media-video-uvc-use-%pul-to-print-uuids.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: drivers/media/video/uvc: use %pUl to print UUIDs
=46rom: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/media/video/uvc/uvc_ctrl.c~drivers-media-video-uvc-us=
e-%pul-to-print-uuids drivers/media/video/uvc/uvc_ctrl.c
--- a/drivers/media/video/uvc/uvc_ctrl.c~drivers-media-video-uvc-use-%p=
ul-to-print-uuids
+++ a/drivers/media/video/uvc/uvc_ctrl.c
@@ -1093,8 +1093,8 @@ int uvc_xu_ctrl_query(struct uvc_video_c
=20
 	if (!found) {
 		uvc_trace(UVC_TRACE_CONTROL,
-			"Control " UVC_GUID_FORMAT "/%u not found.\n",
-			UVC_GUID_ARGS(entity->extension.guidExtensionCode),
+			"Control %pUl/%u not found.\n",
+			entity->extension.guidExtensionCode,
 			xctrl->selector);
 		return -EINVAL;
 	}
@@ -1171,9 +1171,9 @@ int uvc_ctrl_resume_device(struct uvc_de
 			    (ctrl->info->flags & UVC_CONTROL_RESTORE) =3D=3D 0)
 				continue;
=20
-			printk(KERN_INFO "restoring control " UVC_GUID_FORMAT
-				"/%u/%u\n", UVC_GUID_ARGS(ctrl->info->entity),
-				ctrl->info->index, ctrl->info->selector);
+			printk(KERN_INFO "restoring control %pUl/%u/%u\n",
+			       ctrl->info->entity,
+			       ctrl->info->index, ctrl->info->selector);
 			ctrl->dirty =3D 1;
 		}
=20
@@ -1228,46 +1228,43 @@ static void uvc_ctrl_add_ctrl(struct uvc
 			dev->intfnum, info->selector, (__u8 *)&size, 2);
 		if (ret < 0) {
 			uvc_trace(UVC_TRACE_CONTROL, "GET_LEN failed on "
-				"control " UVC_GUID_FORMAT "/%u (%d).\n",
-				UVC_GUID_ARGS(info->entity), info->selector,
-				ret);
+				  "control %pUl/%u (%d).\n",
+				  info->entity, info->selector, ret);
 			return;
 		}
=20
 		if (info->size !=3D le16_to_cpu(size)) {
-			uvc_trace(UVC_TRACE_CONTROL, "Control " UVC_GUID_FORMAT
-				"/%u size doesn't match user supplied "
-				"value.\n", UVC_GUID_ARGS(info->entity),
-				info->selector);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Control %pUl/%u size doesn't match user supplied value.\n",
+				  info->entity, info->selector);
 			return;
 		}
=20
 		ret =3D uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
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
=20
 		flags =3D info->flags;
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
=20
 	ctrl->info =3D info;
 	ctrl->data =3D kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL)=
;
-	uvc_trace(UVC_TRACE_CONTROL, "Added control " UVC_GUID_FORMAT "/%u "
-		"to device %s entity %u\n", UVC_GUID_ARGS(ctrl->info->entity),
-		ctrl->info->selector, dev->udev->devpath, entity->id);
+	uvc_trace(UVC_TRACE_CONTROL,
+		  "Added control %pUl/%u to device %s entity %u\n",
+		  ctrl->info->entity, ctrl->info->selector,
+		  dev->udev->devpath, entity->id);
 }
=20
 /*
@@ -1293,17 +1290,16 @@ int uvc_ctrl_add_info(struct uvc_control
 			continue;
=20
 		if (ctrl->selector =3D=3D info->selector) {
-			uvc_trace(UVC_TRACE_CONTROL, "Control "
-				UVC_GUID_FORMAT "/%u is already defined.\n",
-				UVC_GUID_ARGS(info->entity), info->selector);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Control %pUl/%u is already defined.\n",
+				  info->entity, info->selector);
 			ret =3D -EEXIST;
 			goto end;
 		}
 		if (ctrl->index =3D=3D info->index) {
-			uvc_trace(UVC_TRACE_CONTROL, "Control "
-				UVC_GUID_FORMAT "/%u would overwrite index "
-				"%d.\n", UVC_GUID_ARGS(info->entity),
-				info->selector, info->index);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Control %pUl/%u would overwrite index %d.\n",
+				  info->entity, info->selector, info->index);
 			ret =3D -EEXIST;
 			goto end;
 		}
@@ -1344,10 +1340,9 @@ int uvc_ctrl_add_mapping(struct uvc_cont
 			continue;
=20
 		if (info->size * 8 < mapping->size + mapping->offset) {
-			uvc_trace(UVC_TRACE_CONTROL, "Mapping '%s' would "
-				"overflow control " UVC_GUID_FORMAT "/%u\n",
-				mapping->name, UVC_GUID_ARGS(info->entity),
-				info->selector);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Mapping '%s' would overflow control %pUl/%u\n",
+				  mapping->name, info->entity, info->selector);
 			ret =3D -EOVERFLOW;
 			goto end;
 		}
@@ -1366,9 +1361,9 @@ int uvc_ctrl_add_mapping(struct uvc_cont
=20
 		mapping->ctrl =3D info;
 		list_add_tail(&mapping->list, &info->mappings);
-		uvc_trace(UVC_TRACE_CONTROL, "Adding mapping %s to control "
-			UVC_GUID_FORMAT "/%u.\n", mapping->name,
-			UVC_GUID_ARGS(info->entity), info->selector);
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "Adding mapping %s to control %pUl/%u.\n",
+			  mapping->name, info->entity, info->selector);
=20
 		ret =3D 0;
 		break;
diff -puN drivers/media/video/uvc/uvc_driver.c~drivers-media-video-uvc-=
use-%pul-to-print-uuids drivers/media/video/uvc/uvc_driver.c
--- a/drivers/media/video/uvc/uvc_driver.c~drivers-media-video-uvc-use-=
%pul-to-print-uuids
+++ a/drivers/media/video/uvc/uvc_driver.c
@@ -328,11 +328,10 @@ static int uvc_parse_format(struct uvc_d
 				sizeof format->name);
 			format->fcc =3D fmtdesc->fcc;
 		} else {
-			uvc_printk(KERN_INFO, "Unknown video format "
-				UVC_GUID_FORMAT "\n",
-				UVC_GUID_ARGS(&buffer[5]));
+			uvc_printk(KERN_INFO, "Unknown video format %pUl\n",
+				   &buffer[5]);
 			snprintf(format->name, sizeof format->name,
-				UVC_GUID_FORMAT, UVC_GUID_ARGS(&buffer[5]));
+				 "%pUl", &Buffer[5]);
 			format->fcc =3D 0;
 		}
=20
diff -puN drivers/media/video/uvc/uvcvideo.h~drivers-media-video-uvc-us=
e-%pul-to-print-uuids drivers/media/video/uvc/uvcvideo.h
--- a/drivers/media/video/uvc/uvcvideo.h~drivers-media-video-uvc-use-%p=
ul-to-print-uuids
+++ a/drivers/media/video/uvc/uvcvideo.h
@@ -555,16 +555,6 @@ extern unsigned int uvc_trace_param;
 #define uvc_printk(level, msg...) \
 	printk(level "uvcvideo: " msg)
=20
-#define UVC_GUID_FORMAT "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"=
 \
-			"%02x%02x%02x%02x%02x%02x"
-#define UVC_GUID_ARGS(guid) \
-	(guid)[3],  (guid)[2],  (guid)[1],  (guid)[0], \
-	(guid)[5],  (guid)[4], \
-	(guid)[7],  (guid)[6], \
-	(guid)[8],  (guid)[9], \
-	(guid)[10], (guid)[11], (guid)[12], \
-	(guid)[13], (guid)[14], (guid)[15]
-
 /* -------------------------------------------------------------------=
-------
  * Internal functions.
  */
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch
scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch
maintainers-document-new-k-entry-type.patch
maintainers-add-open-firmware-flattened-device-tree-entry.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patc=
h
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
isicomc-use-pr_fmt-and-pr_level.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
