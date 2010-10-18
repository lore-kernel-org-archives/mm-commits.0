From: akpm@linux-foundation.org
Subject: + rapidio-fix-maximum-port-number-in-tsi57x-em-initialization.patch added to -mm tree
Date: Mon, 18 Oct 2010 12:53:24 -0700
Message-ID: <201010181953.o9IJrOSb030721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933206Ab0JRTyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 15:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: fix maximum port number in tsi57x EM initialization
has been added to the -mm tree.  Its filename is
     rapidio-fix-maximum-port-number-in-tsi57x-em-initialization.patch

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
Subject: rapidio: fix maximum port number in tsi57x EM initialization
From: Alexandre Bounine <alexandre.bounine@idt.com>

Replace hardcoded maximum port number with actual reported number of
switch ports.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/tsi57x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/switches/tsi57x.c~rapidio-fix-maximum-port-number-in-tsi57x-em-initialization drivers/rapidio/switches/tsi57x.c
--- a/drivers/rapidio/switches/tsi57x.c~rapidio-fix-maximum-port-number-in-tsi57x-em-initialization
+++ a/drivers/rapidio/switches/tsi57x.c
@@ -166,7 +166,8 @@ tsi57x_em_init(struct rio_dev *rdev)
 
 	pr_debug("TSI578 %s [%d:%d]\n", __func__, destid, hopcount);
 
-	for (portnum = 0; portnum < 16; portnum++) {
+	for (portnum = 0;
+	     portnum < RIO_GET_TOTAL_PORTS(rdev->swpinfo); portnum++) {
 		/* Make sure that Port-Writes are enabled (for all ports) */
 		rio_mport_read_config_32(mport, destid, hopcount,
 				TSI578_SP_MODE(portnum), &regval);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-fix-rapidio-sysfs-hierarchy.patch
rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler.patch
rapidio-use-stored-ingress-port-number-instead-of-register-read.patch
rapidio-add-relation-links-between-rio-device-structures.patch
rapidio-add-default-handler-for-error-stopped-state.patch
rapidio-modify-sysfs-initialization-for-switches.patch
rapidio-add-handling-of-orphan-port-write-message.patch
rapidio-add-device-access-check-into-the-enumeration.patch
rapidio-add-support-for-idt-cps-gen2-switches.patch
rapidio-add-handling-of-redundant-routes.patch
rapidio-fix-idle2-bits-corruption.patch
rapidio-fix-maximum-port-number-in-tsi57x-em-initialization.patch
rapidio-fix-destructive-port-em-initialization-for-tsi568.patch

