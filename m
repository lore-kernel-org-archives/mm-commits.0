From: akpm@linux-foundation.org
Subject: + scsi-add-__init-__exit-macros-to-ibmvstgtc.patch added to -mm tree
Date: Wed, 24 Jun 2009 19:49:21 -0700
Message-ID: <200906250249.n5P2nLCU015811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbZFYCth (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 22:49:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterhuewe@gmx.de, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au


The patch titled
     scsi: add __init/__exit macros to ibmvstgt.c
has been added to the -mm tree.  Its filename is
     scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

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
Subject: scsi: add __init/__exit macros to ibmvstgt.c
From: Peter Huewe <peterhuewe@gmx.de>

Add the __init and __exit macros to the module_init / module_exit
functions from drivers/scsi/ibmvscsi/ibmvstgt.c

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmvscsi/ibmvstgt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvstgtc drivers/scsi/ibmvscsi/ibmvstgt.c
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvstgtc
+++ a/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -955,7 +955,7 @@ static struct srp_function_template ibmv
 	.it_nexus_response = ibmvstgt_it_nexus_response,
 };
 
-static int ibmvstgt_init(void)
+static int __init ibmvstgt_init(void)
 {
 	int err = -ENOMEM;
 
@@ -986,7 +986,7 @@ release_transport:
 	return err;
 }
 
-static void ibmvstgt_exit(void)
+static void __exit ibmvstgt_exit(void)
 {
 	printk("Unregister IBM virtual SCSI driver\n");
 
_

Patches currently in -mm which might be from peterhuewe@gmx.de are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

