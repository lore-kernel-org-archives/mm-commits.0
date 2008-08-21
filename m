From: akpm@linux-foundation.org
Subject: + floppy-support-arbitrary-first-sector-numbers.patch added to -mm tree
Date: Thu, 21 Aug 2008 12:40:05 -0700
Message-ID: <200808211940.m7LJe5s4022370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315AbYHUTmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 15:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keith@lochan.org, alain@linux.lu, jens.axboe@oracle.com, mtk.manpages@googlemail.com


The patch titled
     floppy: support arbitrary first-sector numbers
has been added to the -mm tree.  Its filename is
     floppy-support-arbitrary-first-sector-numbers.patch

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
Subject: floppy: support arbitrary first-sector numbers
From: Keith Wansbrough <keith@lochan.org>

The current floppy_struct allows floppies to number sectors starting
from 0 or 1.  This patch allows arbitrary first-sector numbers - for
example, 0xC1 for Amstrad CPC disks.

This extends the existing 1-bit field (FD_ZEROBASED, bit 2 of stretch)
to 8 bits (FD_SECTMASK, bits 2 to 9).

Currently 0x00 denotes a first sector number of 1, and 0x01 denotes a
first sector number of 0.  We extend this by interpreting FD_SECTMASK
as the first sector number with the LSB flipped.

Signed-off-by: Keith Wansbrough <keith@lochan.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alain Knaff <alain@linux.lu>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   23 +++++++++++++++--------
 include/linux/fd.h     |    8 +++++++-
 2 files changed, 22 insertions(+), 9 deletions(-)

diff -puN drivers/block/floppy.c~floppy-support-arbitrary-first-sector-numbers drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-support-arbitrary-first-sector-numbers
+++ a/drivers/block/floppy.c
@@ -423,8 +423,15 @@ static struct floppy_raw_cmd *raw_cmd, d
  * 1581's logical side 0 is on physical side 1, whereas the Sharp's logical
  * side 0 is on physical side 0 (but with the misnamed sector IDs).
  * 'stretch' should probably be renamed to something more general, like
- * 'options'.  Other parameters should be self-explanatory (see also
- * setfdprm(8)).
+ * 'options'.
+ *
+ * Bits 2 through 9 of 'stretch' tell the number of the first sector.
+ * The LSB (bit 2) is flipped. For most disks, the first sector
+ * is 1 (represented by 0x00<<2).  For some CP/M and music sampler
+ * disks (such as Ensoniq EPS 16plus) it is 0 (represented as 0x01<<2).
+ * For Amstrad CPC disks it is 0xC1 (represented as 0xC0<<2).
+ *
+ * Other parameters should be self-explanatory (see also setfdprm(8)).
  */
 /*
 	    Size
@@ -2236,9 +2243,9 @@ static void setup_format_params(int trac
 			}
 		}
 	}
-	if (_floppy->stretch & FD_ZEROBASED) {
+	if (_floppy->stretch & FD_SECTBASEMASK) {
 		for (count = 0; count < F_SECT_PER_TRACK; count++)
-			here[count].sect--;
+			here[count].sect += FD_SECTBASE(_floppy) - 1;
 	}
 }
 
@@ -2649,7 +2656,7 @@ static int make_raw_rw_request(void)
 	}
 	HEAD = fsector_t / _floppy->sect;
 
-	if (((_floppy->stretch & (FD_SWAPSIDES | FD_ZEROBASED)) ||
+	if (((_floppy->stretch & (FD_SWAPSIDES | FD_SECTBASEMASK)) ||
 	     TESTF(FD_NEED_TWADDLE)) && fsector_t < _floppy->sect)
 		max_sector = _floppy->sect;
 
@@ -2679,7 +2686,7 @@ static int make_raw_rw_request(void)
 	CODE2SIZE;
 	SECT_PER_TRACK = _floppy->sect << 2 >> SIZECODE;
 	SECTOR = ((fsector_t % _floppy->sect) << 2 >> SIZECODE) +
-	    ((_floppy->stretch & FD_ZEROBASED) ? 0 : 1);
+	    FD_SECTBASE(_floppy);
 
 	/* tracksize describes the size which can be filled up with sectors
 	 * of size ssize.
@@ -3311,7 +3318,7 @@ static inline int set_geometry(unsigned 
 	    g->head <= 0 ||
 	    g->track <= 0 || g->track > UDP->tracks >> STRETCH(g) ||
 	    /* check if reserved bits are set */
-	    (g->stretch & ~(FD_STRETCH | FD_SWAPSIDES | FD_ZEROBASED)) != 0)
+	    (g->stretch & ~(FD_STRETCH | FD_SWAPSIDES | FD_SECTBASEMASK)) != 0)
 		return -EINVAL;
 	if (type) {
 		if (!capable(CAP_SYS_ADMIN))
@@ -3356,7 +3363,7 @@ static inline int set_geometry(unsigned 
 		if (DRS->maxblock > user_params[drive].sect ||
 		    DRS->maxtrack ||
 		    ((user_params[drive].sect ^ oldStretch) &
-		     (FD_SWAPSIDES | FD_ZEROBASED)))
+		     (FD_SWAPSIDES | FD_SECTBASEMASK)))
 			invalidate_drive(bdev);
 		else
 			process_fd_request();
diff -puN include/linux/fd.h~floppy-support-arbitrary-first-sector-numbers include/linux/fd.h
--- a/include/linux/fd.h~floppy-support-arbitrary-first-sector-numbers
+++ a/include/linux/fd.h
@@ -15,10 +15,16 @@ struct floppy_struct {
 			sect,		/* sectors per track */
 			head,		/* nr of heads */
 			track,		/* nr of tracks */
-			stretch;	/* !=0 means double track steps */
+			stretch;	/* bit 0 !=0 means double track steps */
+					/* bit 1 != 0 means swap sides */
+					/* bits 2..9 give the first sector */
+					/*  number (the LSB is flipped) */
 #define FD_STRETCH 1
 #define FD_SWAPSIDES 2
 #define FD_ZEROBASED 4
+#define FD_SECTBASEMASK 0x3FC
+#define FD_MKSECTBASE(s) (((s) ^ 1) << 2)
+#define FD_SECTBASE(floppy) ((((floppy)->stretch & FD_SECTBASEMASK) >> 2) ^ 1)
 
 	unsigned char	gap,		/* gap1 size */
 
_

Patches currently in -mm which might be from keith@lochan.org are

floppy-support-arbitrary-first-sector-numbers.patch

