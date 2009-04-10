From: akpm@linux-foundation.org
Subject: + scsi-a4000-correct-driver-unregistration-in-case-of-failure.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:05:54 -0700
Message-ID: <200904102305.n3AN5sbU007175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbZDJXJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, James.Bottomley@HansenPartnership.com, gregkh@suse.de, tom.leiming@gmail.com


The patch titled
     scsi: a4000: correct driver unregistration in case of failure
has been added to the -mm tree.  Its filename is
     scsi-a4000-correct-driver-unregistration-in-case-of-failure.patch

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

origin.patch
linux-next.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch
agnx-make-input-parameters-const.patch
at24-make-input-buffers-of-at24_write-const.patch
at25-make-input-buffers-of-at25_write-const.patch
revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
scsi-a4000-correct-driver-unregistration-in-case-of-failure.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch

