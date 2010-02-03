From: akpm@linux-foundation.org
Subject: + drivers-staging-fix-continuation-line-formats.patch added to -mm tree
Date: Wed, 03 Feb 2010 15:42:53 -0800
Message-ID: <201002032342.o13Ngrj4026750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757932Ab0BCXm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 18:42:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, greg@kroah.com


The patch titled
     drivers/staging: fix continuation line formats
has been added to the -mm tree.  Its filename is
     drivers-staging-fix-continuation-line-formats.patch

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
Subject: drivers/staging: fix continuation line formats
From: Joe Perches <joe@perches.com>

String constants that are continued on subsequent lines with \ will cause
spurios whitespace in the resulting output.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8192su/r8192S_phy.c |   16 ++++++++--------
 drivers/staging/sep/sep_driver.c       |    5 +++--
 drivers/staging/slicoss/slicoss.c      |    6 ++----
 3 files changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/staging/rtl8192su/r8192S_phy.c~drivers-staging-fix-continuation-line-formats drivers/staging/rtl8192su/r8192S_phy.c
--- a/drivers/staging/rtl8192su/r8192S_phy.c~drivers-staging-fix-continuation-line-formats
+++ a/drivers/staging/rtl8192su/r8192S_phy.c
@@ -2407,8 +2407,8 @@ void PHY_SetBWModeCallback8192S(struct n
 			break;
 
 		default:
-			RT_TRACE(COMP_DBG, "SetBWModeCallback8190Pci():\
-						unknown Bandwidth: %#X\n",priv->CurrentChannelBW);
+			RT_TRACE(COMP_DBG, "SetBWModeCallback8190Pci(): unknown Bandwidth: %#X\n",
+				 priv->CurrentChannelBW);
 			break;
 	}
 
@@ -3398,8 +3398,8 @@ void SwChnlCallback8192SUsb(struct net_d
 	u32			delay;
 //	bool			ret;
 
-	RT_TRACE(COMP_SCAN, "==>SwChnlCallback8190Pci(), switch to channel\
-				%d\n", priv->chan);
+	RT_TRACE(COMP_SCAN, "==>SwChnlCallback8190Pci(), switch to channel %d\n",
+		 priv->chan);
 
 
 	if(!priv->up)
@@ -3525,8 +3525,8 @@ void SetBWModeCallback8192SUsb(struct ne
 			break;
 
 		default:
-			RT_TRACE(COMP_DBG, "SetChannelBandwidth8190Pci():\
-						unknown Bandwidth: %#X\n",priv->CurrentChannelBW);
+			RT_TRACE(COMP_DBG, "SetChannelBandwidth8190Pci(): unknown Bandwidth: %#X\n",
+				 priv->CurrentChannelBW);
 			break;
 	}
 
@@ -3660,8 +3660,8 @@ void SetBWModeCallback8192SUsbWorkItem(s
 			break;
 
 		default:
-			RT_TRACE(COMP_DBG, "SetBWModeCallback8192SUsbWorkItem():\
-						unknown Bandwidth: %#X\n",priv->CurrentChannelBW);
+			RT_TRACE(COMP_DBG, "SetBWModeCallback8192SUsbWorkItem(): unknown Bandwidth: %#X\n",
+				 priv->CurrentChannelBW);
 			break;
 	}
 
diff -puN drivers/staging/sep/sep_driver.c~drivers-staging-fix-continuation-line-formats drivers/staging/sep/sep_driver.c
--- a/drivers/staging/sep/sep_driver.c~drivers-staging-fix-continuation-line-formats
+++ a/drivers/staging/sep/sep_driver.c
@@ -944,8 +944,9 @@ static int sep_lock_user_pages(struct se
 			dbg("data_size is %lu\n", data_size);
 			while (1);
 		}
-		edbg("lli_array[%lu].physical_address is %08lx, \
-		lli_array[%lu].block_size is %lu\n", count, lli_array[count].physical_address, count, lli_array[count].block_size);
+		edbg("lli_array[%lu].physical_address is %08lx, lli_array[%lu].block_size is %lu\n",
+		     count, lli_array[count].physical_address,
+		     count, lli_array[count].block_size);
 	}
 
 	/* set output params */
diff -puN drivers/staging/slicoss/slicoss.c~drivers-staging-fix-continuation-line-formats drivers/staging/slicoss/slicoss.c
--- a/drivers/staging/slicoss/slicoss.c~drivers-staging-fix-continuation-line-formats
+++ a/drivers/staging/slicoss/slicoss.c
@@ -658,8 +658,7 @@ static int slic_ioctl(struct net_device 
 
 			if (copy_from_user(data, rq->ifr_data, 28)) {
 				PRINT_ERROR
-				    ("slic: copy_from_user FAILED getting \
-				     initial simba param\n");
+				    ("slic: copy_from_user FAILED getting initial simba param\n");
 				return -EFAULT;
 			}
 
@@ -674,8 +673,7 @@ static int slic_ioctl(struct net_device 
 				   (tracemon_request ==
 				    SLIC_DUMP_IN_PROGRESS)) {
 				PRINT_ERROR
-				    ("ATK Diagnostic Trace Dump Requested but \
-				     already in progress... ignore\n");
+				    ("ATK Diagnostic Trace Dump Requested but already in progress... ignore\n");
 			} else {
 				PRINT_ERROR
 				    ("ATK Diagnostic Trace Dump Requested\n");
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

