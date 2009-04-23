From: akpm@linux-foundation.org
Subject: [merged] scsi-a4000-correct-driver-unregistration-in-case-of-failure.patch removed from -mm tree
Date: Thu, 23 Apr 2009 12:25:14 -0700
Message-ID: <200904231925.n3NJPEW7025224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713AbZDWT22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 15:28:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, James.Bottomley@HansenPartnership.com, gregkh@suse.de, tom.leiming@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scsi: a4000: correct driver unregistration in case of failure
has been removed from the -mm tree.  Its filename was
     scsi-a4000-correct-driver-unregistration-in-case-of-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: a4000: correct driver unregistration in case of failure
From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 7a192ec334cab9fafe3a8665a65af398b0e24730 ("platform driver: fix
incorrect use of 'platform_bus_type' with 'struct device_driver') turned a
driver_UNregister into platform_driver_REGISTER.  Correct this to
platform_driver_UNregister.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/a4000t.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/a4000t.c~scsi-a4000-correct-driver-unregistration-in-case-of-failure drivers/scsi/a4000t.c
--- a/drivers/scsi/a4000t.c~scsi-a4000-correct-driver-unregistration-in-case-of-failure
+++ a/drivers/scsi/a4000t.c
@@ -129,7 +129,7 @@ static int __init a4000t_scsi_init(void)
 	a4000t_scsi_device = platform_device_register_simple("a4000t-scsi",
 			-1, NULL, 0);
 	if (IS_ERR(a4000t_scsi_device)) {
-		platform_driver_register(&a4000t_scsi_driver);
+		platform_driver_unregister(&a4000t_scsi_driver);
 		return PTR_ERR(a4000t_scsi_device);
 	}
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch
m68k-count-can-reach-51-not-50.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch

