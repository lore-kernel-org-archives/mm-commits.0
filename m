From: akpm@linux-foundation.org
Subject: [merged] drivers-message-fusion-mptscsihc-missing-break.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:42 -0800
Message-ID: <20121219203943.1957C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:45481 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab2LSUjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:45 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so133905wib.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, James.Bottomley@HansenPartnership.com, kashyap.desai@lsi.com, nagalakshmi.nandigama@lsi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/message/fusion/mptscsih.c: missing break
has been removed from the -mm tree.  Its filename was
     drivers-message-fusion-mptscsihc-missing-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/message/fusion/mptscsih.c: missing break

This happens to do the right thing in all cases on fibre channel but not on
other media types

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/message/fusion/mptscsih.c~drivers-message-fusion-mptscsihc-missing-break drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~drivers-message-fusion-mptscsihc-missing-break
+++ a/drivers/message/fusion/mptscsih.c
@@ -792,6 +792,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			 * than an unsolicited DID_ABORT.
 			 */
 			sc->result = DID_RESET << 16;
+			break;
 
 		case MPI_IOCSTATUS_SCSI_EXT_TERMINATED:		/* 0x004C */
 			if (ioc->bus_type == FC)
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
sendfile-allows-bypassing-of-notifier-events.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-avoid-crash-on-failed-block-map-free.patch
fork-unshare-remove-dead-code.patch

