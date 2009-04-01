From: akpm@linux-foundation.org
Subject: [merged] fbdev-newport-newport_wait-return-0-on-timeout.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:42 -0700
Message-ID: <200904011843.n31Ihg0o010166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933635AbZDASqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: newport: newport_*wait() return 0 on timeout
has been removed from the -mm tree.  Its filename was
     fbdev-newport-newport_wait-return-0-on-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: newport: newport_*wait() return 0 on timeout
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement t reaches -1 on timeout which results in a
return of 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/newport.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/video/newport.h~fbdev-newport-newport_wait-return-0-on-timeout include/video/newport.h
--- a/include/video/newport.h~fbdev-newport-newport_wait-return-0-on-timeout
+++ a/include/video/newport.h
@@ -453,7 +453,7 @@ static __inline__ int newport_wait(struc
 {
 	int t = BUSY_TIMEOUT;
 
-	while (t--)
+	while (--t)
 		if (!(regs->cset.status & NPORT_STAT_GBUSY))
 			break;
 	return !t;
@@ -463,7 +463,7 @@ static __inline__ int newport_bfwait(str
 {
 	int t = BUSY_TIMEOUT;
 
-	while (t--)
+	while (--t)
 		if(!(regs->cset.status & NPORT_STAT_BBUSY))
 			break;
 	return !t;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch

