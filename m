From: akpm@linux-foundation.org
Subject: + scsi-tape-fix-gcc-44-warning.patch added to -mm tree
Date: Mon, 04 May 2009 14:52:44 -0700
Message-ID: <200905042152.n44LqimN019386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbZEDVzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Kai.Makisara@kolumbus.fi, James.Bottomley@HansenPartnership.com, kai.makisara@kolumbus.fi, sergey.senozhatsky@mail.by


The patch titled
     SCSI tape: fix gcc 4.4 warning
has been added to the -mm tree.  Its filename is
     scsi-tape-fix-gcc-44-warning.patch

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
Subject: SCSI tape: fix gcc 4.4 warning
From: Kai Makisara <Kai.Makisara@kolumbus.fi>

This patch fixes the GCC 4.4 warning reported by David Binderman and Sergey
Senozhatsky. The old version was working correctly but was not easy to read.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/st.c~scsi-tape-fix-gcc-44-warning drivers/scsi/st.c
--- a/drivers/scsi/st.c~scsi-tape-fix-gcc-44-warning
+++ a/drivers/scsi/st.c
@@ -2964,7 +2964,7 @@ static int st_int_ioctl(struct scsi_tape
 			    !(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
-				STp->use_pf = !STp->use_pf | PF_TESTED;
+				STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;
 				st_release_request(SRpnt);
 				SRpnt = NULL;
 				return st_int_ioctl(STp, cmd_in, arg);
_

Patches currently in -mm which might be from Kai.Makisara@kolumbus.fi are

scsi-tape-fix-gcc-44-warning.patch

