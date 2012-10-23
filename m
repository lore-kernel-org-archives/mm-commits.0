From: akpm@linux-foundation.org
Subject: + drivers-message-fusion-mptscsihc-missing-break.patch added to -mm tree
Date: Tue, 23 Oct 2012 15:49:27 -0700
Message-ID: <20121023224927.8CBF8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52684 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543Ab2JWWt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 18:49:28 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so549924qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 15:49:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com


The patch titled
     Subject: drivers/message/fusion/mptscsih.c: missing break
has been added to the -mm tree.  Its filename is
     drivers-message-fusion-mptscsihc-missing-break.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/message/fusion/mptscsih.c: missing break

This happens to do the right thing in all cases on fibre channel but not on
other media types

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
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

linux-next.patch
drivers-message-fusion-mptscsihc-missing-break.patch

