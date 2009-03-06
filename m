From: akpm@linux-foundation.org
Subject: [merged] libata-change-drive-ready-wait-after-hard-reset-to-5s.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:18 -0800
Message-ID: <200903061928.n26JSI28022676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756119AbZCFT3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:29:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stuart_hayes@dell.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: change drive ready wait after hard reset to 5s
has been removed from the -mm tree.  Its filename was
     libata-change-drive-ready-wait-after-hard-reset-to-5s.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: change drive ready wait after hard reset to 5s
From: Stuart Hayes <stuart_hayes@dell.com>

This fixes problems during resume with drives that take longer than 1s to
be ready.  The ATA-6 spec appears to allow 5 seconds for a drive to be
ready.

On one affected system, this patch changes "PM: resume devices took..."
message from 17 seconds to 4 seconds, and gets rid of a lot of ugly
timeout/error messages.

Without this patch, the libata code moves on after 1s, tries to send a
soft reset (which the drive doesn't see because it isn't ready) which also
times out, then an IDENTIFY command is sent to the drive which times out,
and finally the error handler will try to send another hard reset which
will finally get things working.

Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/libata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/libata.h~libata-change-drive-ready-wait-after-hard-reset-to-5s include/linux/libata.h
--- a/include/linux/libata.h~libata-change-drive-ready-wait-after-hard-reset-to-5s
+++ a/include/linux/libata.h
@@ -275,7 +275,7 @@ enum {
 	 * advised to wait only for the following duration before
 	 * doing SRST.
 	 */
-	ATA_TMOUT_PMP_SRST_WAIT	= 1000,
+	ATA_TMOUT_PMP_SRST_WAIT	= 5000,
 
 	/* ATA bus states */
 	BUS_UNKNOWN		= 0,
_

Patches currently in -mm which might be from stuart_hayes@dell.com are

linux-next.patch

