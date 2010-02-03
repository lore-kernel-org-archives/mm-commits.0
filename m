From: akpm@linux-foundation.org
Subject: + drivers-video-via-fix-continuation-line-formats.patch added to -mm tree
Date: Wed, 03 Feb 2010 15:43:23 -0800
Message-ID: <201002032343.o13NhNCE026771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757932Ab0BCXn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 18:43:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, FlorianSchandinat@gmx.de


The patch titled
     drivers/video/via: fix continuation line formats
has been added to the -mm tree.  Its filename is
     drivers-video-via-fix-continuation-line-formats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/via: fix continuation line formats
From: Joe Perches <joe@perches.com>

String constants that are continued on subsequent lines with \ will cause
spurios whitespace in the resulting output.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/dvi.c |    8 ++++----
 drivers/video/via/lcd.c |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/video/via/dvi.c~drivers-video-via-fix-continuation-line-formats drivers/video/via/dvi.c
--- a/drivers/video/via/dvi.c~drivers-video-via-fix-continuation-line-formats
+++ a/drivers/video/via/dvi.c
@@ -411,8 +411,8 @@ static void dvi_get_panel_size_from_DDCv
 		tmds_setting->max_vres = 1080;
 		break;
 	default:
-		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d !\
-					 set default panel size.\n", max_h);
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d ! "
+					 "set default panel size.\n", max_h);
 		break;
 	}
 
@@ -460,8 +460,8 @@ static void dvi_get_panel_size_from_DDCv
 		tmds_setting->max_vres = 1200;
 		break;
 	default:
-		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d!\
-			set default panel size.\n", tmds_setting->max_hres);
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d! "
+			"set default panel size.\n", tmds_setting->max_hres);
 		break;
 	}
 
diff -puN drivers/video/via/lcd.c~drivers-video-via-fix-continuation-line-formats drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~drivers-video-via-fix-continuation-line-formats
+++ a/drivers/video/via/lcd.c
@@ -164,13 +164,13 @@ static bool lvds_identify_integratedlvds
 		if (viaparinfo->chip_info->lvds_chip_info.lvds_chip_name) {
 			viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name =
 			    INTEGRATED_LVDS;
-			DEBUG_MSG(KERN_INFO "Support two dual channel LVDS!\
-				  (Internal LVDS + External LVDS)\n");
+			DEBUG_MSG(KERN_INFO "Support two dual channel LVDS! "
+				  "(Internal LVDS + External LVDS)\n");
 		} else {
 			viaparinfo->chip_info->lvds_chip_info.lvds_chip_name =
 			    INTEGRATED_LVDS;
-			DEBUG_MSG(KERN_INFO "Not found external LVDS,\
-				  so can't support two dual channel LVDS!\n");
+			DEBUG_MSG(KERN_INFO "Not found external LVDS, "
+				  "so can't support two dual channel LVDS!\n");
 		}
 	} else if (viafb_display_hardware_layout == HW_LAYOUT_LCD1_LCD2) {
 		/* Two single channel LCD (Internal LVDS + Internal LVDS): */
@@ -178,8 +178,8 @@ static bool lvds_identify_integratedlvds
 		INTEGRATED_LVDS;
 		viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name =
 			INTEGRATED_LVDS;
-		DEBUG_MSG(KERN_INFO "Support two single channel LVDS!\
-			  (Internal LVDS + Internal LVDS)\n");
+		DEBUG_MSG(KERN_INFO "Support two single channel LVDS! "
+			  "(Internal LVDS + Internal LVDS)\n");
 	} else if (viafb_display_hardware_layout != HW_LAYOUT_DVI_ONLY) {
 		/* If we have found external LVDS, just use it,
 		   otherwise, we will use internal LVDS as default. */
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
arch-ia64-fix-continuation-line-formats.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
drivers-net-davinci_emacc-fix-continuation-line-formats.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-staging-fix-continuation-line-formats.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
checkpatch-warn-on-unnecessary-spaces-before-quoted-newlines.patch
scripts-checkpatchpl-dramatically-improve-define-parse-times.patch
drivers-hwmon-vt8231c-fix-continuation-line-formats.patch
drivers-video-via-fix-continuation-line-formats.patch

