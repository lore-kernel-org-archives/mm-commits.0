From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-scsi-stc-suppress-gcc-44-warning.patch removed from -mm tree
Date: Thu, 30 Apr 2009 14:47:19 -0700
Message-ID: <200904302147.n3ULlK5F004682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756190AbZD3Vtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Apr 2009 17:49:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@mail.by, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/st.c: suppress gcc-4.4 warning
has been removed from the -mm tree.  Its filename was
     drivers-scsi-stc-suppress-gcc-44-warning.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/st.c: suppress gcc-4.4 warning
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>

Fix a gcc 4.4 compiler warning:

drivers/scsi/st.c: In function `st_int_ioctl':
drivers/scsi/st.c:2967: warning: suggest parentheses around operand of `!' or change `|' to `||' or `!' to `~'

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/st.c~drivers-scsi-stc-suppress-gcc-44-warning drivers/scsi/st.c
--- a/drivers/scsi/st.c~drivers-scsi-stc-suppress-gcc-44-warning
+++ a/drivers/scsi/st.c
@@ -2964,7 +2964,7 @@ static int st_int_ioctl(struct scsi_tape
 			    !(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
-				STp->use_pf = !STp->use_pf | PF_TESTED;
+				STp->use_pf = (!STp->use_pf) | PF_TESTED;
 				st_release_request(SRpnt);
 				SRpnt = NULL;
 				return st_int_ioctl(STp, cmd_in, arg);
_

Patches currently in -mm which might be from sergey.senozhatsky@mail.by are

drivers-net-cxgb3-suppress-a-gcc-44-warning.patch
drivers-scsi-stc-suppress-gcc-44-warning.patch

