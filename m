From: akpm@linux-foundation.org
Subject: [merged] scsi-tape-fix-gcc-44-warning.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:42 -0700
Message-ID: <200905261935.n4QJZgS8006483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757913AbZEZTgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Kai.Makisara@kolumbus.fi, James.Bottomley@HansenPartnership.com, kai.makisara@kolumbus.fi, sergey.senozhatsky@mail.by, mm-commits@vger.kernel.org


The patch titled
     scsi tape: fix gcc 4.4 warning
has been removed from the -mm tree.  Its filename was
     scsi-tape-fix-gcc-44-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi tape: fix gcc 4.4 warning
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

linux-next.patch

