From: akpm@osdl.org
Subject: - scsi-st-fix.patch removed from -mm tree
Date: Sat, 27 Jan 2007 14:22:48 -0800
Message-ID: <200701272222.l0RMMmLd017781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbXA0WWy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 17:22:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Kai.Makisara@kolumbus.fi, ce_reisinger@yahoo.com, kai.makisara@kolumbus.fi, mm-commits@vger.kernel.org


The patch titled
     scsi: st fix
has been removed from the -mm tree.  Its filename was
     scsi-st-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: st fix
From: Kai Makisara <Kai.Makisara@kolumbus.fi>

On Wed, 24 Jan 2007, Andrew Morton wrote:

> On Mon, 22 Jan 2007 13:07:20 -0800
> bugme-daemon@bugzilla.kernel.org wrote:
>
> > http://bugzilla.kernel.org/show_bug.cgi?id=7864
> >
> >            Summary: A MTIOCTOP/MTWEOF within the early warning will cause
> >                     the file number to be incorrect
> >     Kernel Version: 2.6.19.2
> >             Status: NEW
> >           Severity: low
> >              Owner: io_scsi@kernel-bugs.osdl.org
> >          Submitter: ce_reisinger@yahoo.com
> >
> >
> > Write records to a SCSI tape until a write fails with a ENOSPC (you have reached
> > early warning.
> > Now perform a:
> >    struct mtget before, after;
> >    ioctl(fd, MTIOCGET, &before);
> >    struct mtop mtop = { MTWEOF, 1 };
> >    ioctl(fd, MTIOCTOP, &mtop);
> >    ioctl(fd, MTIOCGET, &after);
> >
> > Check the value of mt_fileno in the before and after structures. Notice the
> > after is 2 greater then the before.
> >
> > The problem appears to be in the block of code starting at line 2817 in st.c.
> > This block is entered because the drive did return a CHECK CONDITION with NO
> > SENSE and the SENSE_EOM bit set. At lines 2824/5 the fileno is incremented. But
> > it has already been increased by the number of filemarks requested by the
> > MTIOCTOP. I believe that the residue count in the sense data should be
> > subtracted from fileno, not a increment as is done.
> >
>
> Thanks.  Could you please send us a tested patch to fix these things, as
> per http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt ?
>
The analysis is basically correct and explains the bug. According to the
SCSI standards, the sense code is NO SENSE or RECOVERED ERROR in case
writing filemark(s) succeeds. If it fails (partly or completely) the sense
code is VOLUME OVERFLOW. The patch below is tested to fix the case when
one filemark is successfully written after the EOM early warning. It
should also fix the case at real EOM but this has not been tested.

Carl, thanks for reporting the bug and providing the analysis for the fix.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
Cc: <ce_reisinger@yahoo.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/st.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/st.c~scsi-st-fix drivers/scsi/st.c
--- a/drivers/scsi/st.c~scsi-st-fix
+++ a/drivers/scsi/st.c
@@ -2816,15 +2816,18 @@ static int st_int_ioctl(struct scsi_tape
 
 		if (cmd_in == MTWEOF &&
 		    cmdstatp->have_sense &&
-		    (cmdstatp->flags & SENSE_EOM) &&
-		    (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
-		     cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
-		    undone == 0) {
-			ioctl_result = 0;	/* EOF written successfully at EOM */
-			if (fileno >= 0)
-				fileno++;
+		    (cmdstatp->flags & SENSE_EOM)) {
+			if (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
+			    cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) {
+				ioctl_result = 0;	/* EOF(s) written successfully at EOM */
+				STps->eof = ST_NOEOF;
+			} else {  /* Writing EOF(s) failed */
+				if (fileno >= 0)
+					fileno -= undone;
+				if (undone < arg)
+					STps->eof = ST_NOEOF;
+			}
 			STps->drv_file = fileno;
-			STps->eof = ST_NOEOF;
 		} else if ((cmd_in == MTFSF) || (cmd_in == MTFSFM)) {
 			if (fileno >= 0)
 				STps->drv_file = fileno - undone;
_

Patches currently in -mm which might be from Kai.Makisara@kolumbus.fi are

git-scsi-rc-fixes.patch
