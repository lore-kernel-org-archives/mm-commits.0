From: akpm@linux-foundation.org
Subject: + synclink_gt-add-serial-bit-order-control.patch added to -mm tree
Date: Thu, 17 Jul 2008 14:13:01 -0700
Message-ID: <200807172113.m6HLD2ON006474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760012AbYGQVNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 17:13:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk


The patch titled
     synclink_gt: add serial bit order control
has been added to the -mm tree.  Its filename is
     synclink_gt-add-serial-bit-order-control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: add serial bit order control
From: Paul Fulghum <paulkf@microgate.com>

Add control of hardware serial bit order between LSB first
(default/standard) and MSB first.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |    2 ++
 include/linux/synclink.h   |    1 +
 2 files changed, 3 insertions(+)

diff -puN drivers/char/synclink_gt.c~synclink_gt-add-serial-bit-order-control drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-add-serial-bit-order-control
+++ a/drivers/char/synclink_gt.c
@@ -4443,6 +4443,8 @@ static void msc_set_vcr(struct slgt_info
 		break;
 	}
 
+	if (info->if_mode & MGSL_INTERFACE_MSB_FIRST)
+		val |= BIT4;
 	if (info->signals & SerialSignal_DTR)
 		val |= BIT3;
 	if (info->signals & SerialSignal_RTS)
diff -puN include/linux/synclink.h~synclink_gt-add-serial-bit-order-control include/linux/synclink.h
--- a/include/linux/synclink.h~synclink_gt-add-serial-bit-order-control
+++ a/include/linux/synclink.h
@@ -136,6 +136,7 @@
 #define MGSL_INTERFACE_RTS_EN   0x10
 #define MGSL_INTERFACE_LL       0x20
 #define MGSL_INTERFACE_RL       0x40
+#define MGSL_INTERFACE_MSB_FIRST 0x80
 
 typedef struct _MGSL_PARAMS
 {
_

Patches currently in -mm which might be from paulkf@microgate.com are

synclink_gt-add-rx-dma-buffer-fill-level-control.patch
synclink_gt-add-serial-bit-order-control.patch
synclink_gt-improve-tiocoutq-accuracy.patch
synclink_gt-improve-and-simplify-write-method.patch

