From: akpm@linux-foundation.org
Subject: + cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch added to -mm tree
Date: Mon, 12 Nov 2007 17:31:19 -0800
Message-ID: <200711130131.lAD1VJ96019971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756458AbXKMBbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 20:31:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mike.miller@hp.com


The patch titled
     cciss: use upper_32_bits() macro to eliminate warnings
has been added to the -mm tree.  Its filename is
     cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2650,12 +2650,14 @@ static void do_cciss_request(struct requ
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

chipsfb-uses-depends-on-pci.patch
git-dvb.patch
git-kbuild.patch
git-netdev-all.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
