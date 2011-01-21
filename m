From: akpm@linux-foundation.org
Subject: + adfs-improve-timestamp-precision.patch added to -mm tree
Date: Fri, 21 Jan 2011 14:55:21 -0800
Message-ID: <201101212255.p0LMtLLS005892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903Ab1AUW4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 17:56:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stuart.swales.croftnuisk@gmail.com, rmk@arm.linux.org.uk


The patch titled
     adfs: improve timestamp precision
has been added to the -mm tree.  Its filename is
     adfs-improve-timestamp-precision.patch

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
Subject: adfs: improve timestamp precision
From: Stuart Swales <stuart.swales.croftnuisk@gmail.com>

ADFS (FileCore) storage complies with the RISC OS timestamp specification
(40-bit centiseconds since 01 Jan 1900 00:00:00).  It is desirable that
stored timestamp precision be maintained to facilitate a precise copy of
data and metadata from a hard disc (or image thereof) into a RISC OS
emulator (such as RPCEmu).

This patch implements a full-precision conversion from ADFS to Unix
timestamp as the existing driver, for ease of calculation with old 32-bit
compilers, uses the common trick of shifting the 40-bits representing
centiseconds around into 32-bits representing seconds thereby losing
precision.

Signed-off-by: Stuart Swales<stuart.swales.croftnuisk@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/inode.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff -puN fs/adfs/inode.c~adfs-improve-timestamp-precision fs/adfs/inode.c
--- a/fs/adfs/inode.c~adfs-improve-timestamp-precision
+++ a/fs/adfs/inode.c
@@ -175,50 +175,48 @@ adfs_mode2atts(struct super_block *sb, s
 
 /*
  * Convert an ADFS time to Unix time.  ADFS has a 40-bit centi-second time
- * referenced to 1 Jan 1900 (til 2248)
+ * referenced to 1 Jan 1900 (til 2248) so we need to discard 2208988800 seconds
+ * of time to convert from RISC OS epoch to Unix epoch.
  */
 static void
 adfs_adfs2unix_time(struct timespec *tv, struct inode *inode)
 {
 	unsigned int high, low;
+	/* 01 Jan 1970 00:00:00 (Unix epoch) as nanoseconds since
+	 * 01 Jan 1900 00:00:00 (RISC OS epoch)
+	 */
+	static const s64 nsec_unix_epoch_diff_risc_os_epoch =
+							2208988800000000000LL;
+	s64 nsec;
 
 	if (ADFS_I(inode)->stamped == 0)
 		goto cur_time;
 
-	high = ADFS_I(inode)->loadaddr << 24;
-	low  = ADFS_I(inode)->execaddr;
+	high = ADFS_I(inode)->loadaddr & 0xFF; /* top 8 bits of timestamp */
+	low  = ADFS_I(inode)->execaddr;    /* bottom 32 bits of timestamp */
 
-	high |= low >> 8;
-	low  &= 255;
+	/* convert 40-bit centi-seconds to 32-bit seconds
+	 * going via nanoseconds to retain precision
+	 */
+	nsec = (((s64) high << 32) | (s64) low) * 10000000; /* cs to ns */
 
 	/* Files dated pre  01 Jan 1970 00:00:00. */
-	if (high < 0x336e996a)
+	if (nsec < nsec_unix_epoch_diff_risc_os_epoch)
 		goto too_early;
 
-	/* Files dated post 18 Jan 2038 03:14:05. */
-	if (high >= 0x656e9969)
-		goto too_late;
-
-	/* discard 2208988800 (0x336e996a00) seconds of time */
-	high -= 0x336e996a;
-
-	/* convert 40-bit centi-seconds to 32-bit seconds */
-	tv->tv_sec = (((high % 100) << 8) + low) / 100 + (high / 100 << 8);
-	tv->tv_nsec = 0;
+	/* convert from RISC OS to Unix epoch */
+	nsec -= nsec_unix_epoch_diff_risc_os_epoch;
+
+	*tv = ns_to_timespec(nsec);
 	return;
 
  cur_time:
-	*tv = CURRENT_TIME_SEC;
+	*tv = CURRENT_TIME;
 	return;
 
  too_early:
 	tv->tv_sec = tv->tv_nsec = 0;
 	return;
