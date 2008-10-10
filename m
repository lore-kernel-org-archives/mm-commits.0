From: akpm@linux-foundation.org
Subject: + usb-avoid-needless-address-taking-of-function-parameters.patch added to -mm tree
Date: Fri, 10 Oct 2008 15:15:08 -0700
Message-ID: <200810102215.m9AMF8oG009106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754575AbYJJWPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 18:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     usb: avoid needless address-taking of function parameters
has been added to the -mm tree.  Its filename is
     usb-avoid-needless-address-taking-of-function-parameters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: avoid needless address-taking of function parameters
From: Harvey Harrison <harvey.harrison@gmail.com>

There's no need to take the address of the function params or local variables
when the direct value byteswapping routines are available.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/kaweth.c     |    6 +++---
 drivers/net/usb/pegasus.c    |   12 ++++++------
 drivers/usb/core/message.c   |    6 +++---
 drivers/usb/gadget/net2280.c |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/net/usb/kaweth.c~usb-avoid-needless-address-taking-of-function-parameters drivers/net/usb/kaweth.c
--- a/drivers/net/usb/kaweth.c~usb-avoid-needless-address-taking-of-function-parameters
+++ a/drivers/net/usb/kaweth.c
@@ -283,9 +283,9 @@ static int kaweth_control(struct kaweth_
 
 	dr->bRequestType= requesttype;
 	dr->bRequest = request;
-	dr->wValue = cpu_to_le16p(&value);
-	dr->wIndex = cpu_to_le16p(&index);
-	dr->wLength = cpu_to_le16p(&size);
+	dr->wValue = cpu_to_le16(value);
+	dr->wIndex = cpu_to_le16(index);
+	dr->wLength = cpu_to_le16(size);
 
 	return kaweth_internal_control_msg(kaweth->dev,
 					pipe,
diff -puN drivers/net/usb/pegasus.c~usb-avoid-needless-address-taking-of-function-parameters drivers/net/usb/pegasus.c
--- a/drivers/net/usb/pegasus.c~usb-avoid-needless-address-taking-of-function-parameters
+++ a/drivers/net/usb/pegasus.c
@@ -149,8 +149,8 @@ static int get_registers(pegasus_t * peg
 	pegasus->dr.bRequestType = PEGASUS_REQT_READ;
 	pegasus->dr.bRequest = PEGASUS_REQ_GET_REGS;
 	pegasus->dr.wValue = cpu_to_le16(0);
-	pegasus->dr.wIndex = cpu_to_le16p(&indx);
-	pegasus->dr.wLength = cpu_to_le16p(&size);
+	pegasus->dr.wIndex = cpu_to_le16(indx);
+	pegasus->dr.wLength = cpu_to_le16(size);
 	pegasus->ctrl_urb->transfer_buffer_length = size;
 
 	usb_fill_control_urb(pegasus->ctrl_urb, pegasus->usb,
@@ -207,8 +207,8 @@ static int set_registers(pegasus_t * peg
 	pegasus->dr.bRequestType = PEGASUS_REQT_WRITE;
 	pegasus->dr.bRequest = PEGASUS_REQ_SET_REGS;
 	pegasus->dr.wValue = cpu_to_le16(0);
-	pegasus->dr.wIndex = cpu_to_le16p(&indx);
-	pegasus->dr.wLength = cpu_to_le16p(&size);
+	pegasus->dr.wIndex = cpu_to_le16(indx);
+	pegasus->dr.wLength = cpu_to_le16(size);
 	pegasus->ctrl_urb->transfer_buffer_length = size;
 
 	usb_fill_control_urb(pegasus->ctrl_urb, pegasus->usb,
@@ -260,7 +260,7 @@ static int set_register(pegasus_t * pega
 	pegasus->dr.bRequestType = PEGASUS_REQT_WRITE;
 	pegasus->dr.bRequest = PEGASUS_REQ_SET_REG;
 	pegasus->dr.wValue = cpu_to_le16(data);
-	pegasus->dr.wIndex = cpu_to_le16p(&indx);
+	pegasus->dr.wIndex = cpu_to_le16(indx);
 	pegasus->dr.wLength = cpu_to_le16(1);
 	pegasus->ctrl_urb->transfer_buffer_length = 1;
 
@@ -475,7 +475,7 @@ static inline void get_node_id(pegasus_t
 
 	for (i = 0; i < 3; i++) {
 		read_eprom_word(pegasus, i, &w16);
-		((__le16 *) id)[i] = cpu_to_le16p(&w16);
+		((__le16 *) id)[i] = cpu_to_le16(w16);
 	}
 }
 
diff -puN drivers/usb/core/message.c~usb-avoid-needless-address-taking-of-function-parameters drivers/usb/core/message.c
--- a/drivers/usb/core/message.c~usb-avoid-needless-address-taking-of-function-parameters
+++ a/drivers/usb/core/message.c
@@ -139,9 +139,9 @@ int usb_control_msg(struct usb_device *d
 
 	dr->bRequestType = requesttype;
 	dr->bRequest = request;
-	dr->wValue = cpu_to_le16p(&value);
-	dr->wIndex = cpu_to_le16p(&index);
-	dr->wLength = cpu_to_le16p(&size);
+	dr->wValue = cpu_to_le16(value);
+	dr->wIndex = cpu_to_le16(index);
+	dr->wLength = cpu_to_le16(size);
 
 	/* dbg("usb_control_msg"); */
 
diff -puN drivers/usb/gadget/net2280.c~usb-avoid-needless-address-taking-of-function-parameters drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c~usb-avoid-needless-address-taking-of-function-parameters
+++ a/drivers/usb/gadget/net2280.c
@@ -669,7 +669,7 @@ fill_dma_desc (struct net2280_ep *ep, st
 
 	/* 2280 may be polling VALID_BIT through ep->dma->dmadesc */
 	wmb ();
-	td->dmacount = cpu_to_le32p (&dmacount);
+	td->dmacount = cpu_to_le32(dmacount);
 }
 
 static const u32 dmactl_default =
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-tip.patch
git-avr32.patch
git-powerpc.patch
git-xtensa.patch
git-hid.patch
git-v4l-dvb.patch
git-xfs.patch
git-net.patch
git-sound.patch
git-block.patch
git-pcmcia.patch
git-battery.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch

