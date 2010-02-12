From: akpm@linux-foundation.org
Subject: [merged] edac-mpc85xx-fix-bad-page-calculation.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:03:10 -0800
Message-ID: <201002121903.o1CJ3AkM021089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757241Ab0BLTES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:04:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptyser@xes-inc.com, dougthompson@xmission.com, galak@gate.crashing.org, iws@ovro.caltech.edu, mm-commits@vger.kernel.org


The patch titled
     edac: mpc85xx fix bad page calculation
has been removed from the -mm tree.  Its filename was
     edac-mpc85xx-fix-bad-page-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: mpc85xx fix bad page calculation
From: Peter Tyser <ptyser@xes-inc.com>

Commit b4846251727a38a7f248e41308c060995371dd05 ("edac: mpc85xx add
mpc83xx support") accidentally broke how a chip select's first and last
page addresses are calculated.  The page addresses are being shifted too
far right by PAGE_SHIFT.  This results in errors such as:

  EDAC MPC85xx MC1: Err addr: 0x003075c0
  EDAC MPC85xx MC1: PFN: 0x00000307
  EDAC MPC85xx MC1: PFN out of range!
  EDAC MC1: INTERNAL ERROR: row out of range (4 >= 4)
  EDAC MC1: CE - no information available: INTERNAL ERROR

The vaule of PAGE_SHIFT is already being taken into consideration during
the calculation of the 'start' and 'end' variables, thus it is not
necessary to account for it again when setting a chip select's first and
last page address.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-bad-page-calculation drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-bad-page-calculation
+++ a/drivers/edac/mpc85xx_edac.c
@@ -804,8 +804,8 @@ static void __devinit mpc85xx_init_csrow
 		end   <<= (24 - PAGE_SHIFT);
 		end    |= (1 << (24 - PAGE_SHIFT)) - 1;
 
-		csrow->first_page = start >> PAGE_SHIFT;
-		csrow->last_page = end >> PAGE_SHIFT;
+		csrow->first_page = start;
+		csrow->last_page = end;
 		csrow->nr_pages = end + 1 - start;
 		csrow->grain = 8;
 		csrow->mtype = mtype;
_

Patches currently in -mm which might be from ptyser@xes-inc.com are

origin.patch
linux-next.patch
edac-mpc85xx-mask-ecc-syndrome-correctly.patch
edac-mpc85xx-improve-sdram-error-reporting.patch
edac-mpc85xx-use-resource_size-instead-of-raw-math.patch
edac-e752x-fsb-ecc.patch
edac-e752x-add-dram-scrubbing-support.patch

