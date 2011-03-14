From: akpm@linux-foundation.org
Subject: + drivers-scsi-scsi_transport_iscsic-world-writable-sysfs-priv_sess-file.patch added to -mm tree
Date: Mon, 14 Mar 2011 15:17:10 -0700
Message-ID: <201103142217.p2EMHAab014195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924Ab1CNWXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 18:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu


The patch titled
     drivers/scsi/scsi_transport_iscsi.c: world-writable sysfs priv_sess file
has been added to the -mm tree.  Its filename is
     drivers-scsi-scsi_transport_iscsic-world-writable-sysfs-priv_sess-file.patch

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
Subject: drivers/scsi/scsi_transport_iscsi.c: world-writable sysfs priv_sess file
From: Vasiliy Kulikov <segoon@openwall.com>

Don't allow everybody to change iSCSI settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_transport_iscsi.c~drivers-scsi-scsi_transport_iscsic-world-writable-sysfs-priv_sess-file drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c~drivers-scsi-scsi_transport_iscsic-world-writable-sysfs-priv_sess-file
+++ a/drivers/scsi/scsi_transport_iscsi.c
@@ -1917,7 +1917,7 @@ store_priv_session_##field(struct device
 #define iscsi_priv_session_rw_attr(field, format)			\
 	iscsi_priv_session_attr_show(field, format)			\
 	iscsi_priv_session_attr_store(field)				\
-static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUGO,		\
+static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUSR,		\
 			show_priv_session_##field,			\
 			store_priv_session_##field)
 iscsi_priv_session_rw_attr(recovery_tmo, "%d");
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files.patch
drivers-leds-leds-lp5523c-world-writable-engine-sysfs-files.patch
drivers-misc-ep93xx_pwmc-world-writable-sysfs-files.patch
drivers-rtc-rtc-ds1511c-world-writable-sysfs-nvram-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch
drivers-scsi-scsi_transport_iscsic-world-writable-sysfs-priv_sess-file.patch

