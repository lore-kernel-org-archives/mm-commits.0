From: akpm@linux-foundation.org
Subject: - cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:27 -0800
Message-ID: <200802070022.m170M8Tl006399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762778AbYBGAqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: use upper_32_bits() macro to eliminate warnings
has been removed from the -mm tree.  Its filename was
     cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: use upper_32_bits() macro to eliminate warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Use upper_32_bits(x) macro to handle shifts that may be >= the width of
the data type.

drivers/block/cciss.c: In function 'do_cciss_request':
drivers/block/cciss.c:2655: warning: right shift count >= width of type
drivers/block/cciss.c:2656: warning: right shift count >= width of type
drivers/block/cciss.c:2657: warning: right shift count >= width of type
drivers/block/cciss.c:2658: warning: right shift count >= width of type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/block/cciss.c~cciss-use-upper_32_bits-macro-to-eliminate-warnings drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-use-upper_32_bits-macro-to-eliminate-warnings
+++ a/drivers/block/cciss.c
@@ -2630,12 +2630,14 @@ static void do_cciss_request(struct requ
 			c->Request.CDB[8] = creq->nr_sectors & 0xff;
 			c->Request.CDB[9] = c->Request.CDB[11] = c->Request.CDB[12] = 0;
 		} else {
+			u32 upper32 = upper_32_bits(start_blk);
+
 			c->Request.CDBLen = 16;
 			c->Request.CDB[1]= 0;
-			c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
-			c->Request.CDB[3]= (start_blk >> 48) & 0xff;
-			c->Request.CDB[4]= (start_blk >> 40) & 0xff;
-			c->Request.CDB[5]= (start_blk >> 32) & 0xff;
+			c->Request.CDB[2]= (upper32 >> 24) & 0xff;	//MSB
+			c->Request.CDB[3]= (upper32 >> 16) & 0xff;
+			c->Request.CDB[4]= (upper32 >>  8) & 0xff;
+			c->Request.CDB[5]= upper32 & 0xff;
 			c->Request.CDB[6]= (start_blk >> 24) & 0xff;
 			c->Request.CDB[7]= (start_blk >> 16) & 0xff;
 			c->Request.CDB[8]= (start_blk >>  8) & 0xff;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
