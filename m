From: akpm@linux-foundation.org
Subject: + rio-fix-section-mismatch.patch added to -mm tree
Date: Tue, 12 May 2009 15:12:06 -0700
Message-ID: <200905122212.n4CMC6Dd020758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756935AbZELWPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 18:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leoli@freescale.com, benh@kernel.crashing.org, galak@gate.crashing.org, mporter@kernel.crashing.org, zw@zh-kernel.org


The patch titled
     rio: fix section mismatch
has been added to the -mm tree.  Its filename is
     rio-fix-section-mismatch.patch

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
Subject: rio: fix section mismatch
From: Li Yang <leoli@freescale.com>

Signed-off-by: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Zhang Wei <zw@zh-kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rio-fix-section-mismatch drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rio-fix-section-mismatch
+++ a/drivers/rapidio/rio-scan.c
@@ -296,7 +296,7 @@ static int __devinit rio_add_device(stru
  * to a RIO device on success or NULL on failure.
  *
  */
-static struct rio_dev *rio_setup_device(struct rio_net *net,
+static struct rio_dev __devinit *rio_setup_device(struct rio_net *net,
 					struct rio_mport *port, u16 destid,
 					u8 hopcount, int do_enum)
 {
@@ -569,7 +569,7 @@ static void rio_net_add_mport(struct rio
  * Recursively enumerates a RIO network.  Transactions are sent via the
  * master port passed in @port.
  */
-static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
+static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 			 u8 hopcount)
 {
 	int port_num;
@@ -728,7 +728,7 @@ static int rio_enum_complete(struct rio_
  * Recursively discovers a RIO network.  Transactions are sent via the
  * master port passed in @port.
  */
-static int
+static int __devinit
 rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 	      u8 hopcount)
 {
_

Patches currently in -mm which might be from leoli@freescale.com are

rapidio-add-common-mapping-apis-for-rapidio-memory-access.patch
powerpc-fsl_rio-use-law-address-from-device-tree.patch
powerpc-add-memory-map-support-to-freescale-rapidio-block.patch
rionet-add-memory-access-to-simulated-ethernet-over-rapidio.patch
rio-warn_unused_result-warnings-fix.patch
rio-fix-section-mismatch.patch

