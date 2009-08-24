From: akpm@linux-foundation.org
Subject: + gspca-fix-sn9c20x-build-errors.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:36:24 -0700
Message-ID: <200908242136.n7OLaOq8017192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbZHXVgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:36:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, brijohn@gmail.com, mchehab@infradead.org, toralf.foerster@gmx.de


The patch titled
     gspca: fix sn9c20x build errors
has been added to the -mm tree.  Its filename is
     gspca-fix-sn9c20x-build-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gspca: fix sn9c20x build errors
=46rom: Randy Dunlap <randy.dunlap@oracle.com>

=46ix gscpa sn9c20x build errors:
ERROR: "input_event" [drivers/media/video/gspca/gspca_sn9c20x.ko] undef=
ined!
ERROR: "input_register_device" [drivers/media/video/gspca/gspca_sn9c20x=
=2Eko] undefined!
ERROR: "input_free_device" [drivers/media/video/gspca/gspca_sn9c20x.ko]=
 undefined!
ERROR: "input_unregister_device" [drivers/media/video/gspca/gspca_sn9c2=
0x.ko] undefined!
ERROR: "input_allocate_device" [drivers/media/video/gspca/gspca_sn9c20x=
=2Eko] undefined!

Reported-by: Toralf F=F6rster <toralf.foerster@gmx.de
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Brian Johnson <brijohn@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/gspca/Kconfig~gspca-fix-sn9c20x-build-err=
ors drivers/media/video/gspca/Kconfig
--- a/drivers/media/video/gspca/Kconfig~gspca-fix-sn9c20x-build-errors
+++ a/drivers/media/video/gspca/Kconfig
@@ -123,7 +123,7 @@ config USB_GSPCA_SN9C20X
=20
 config USB_GSPCA_SN9C20X_EVDEV
 	bool "Enable evdev support"
-	depends on USB_GSPCA_SN9C20X
+       depends on USB_GSPCA_SN9C20X && INPUT
 	---help---
 	  Say Y here in order to enable evdev support for sn9c20x webcam butt=
on.
=20
_

Patches currently in -mm which might be from randy.dunlap@oracle.com ar=
e

linux-next.patch
gspca-fix-sn9c20x-build-errors.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sys=
fs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
staging-iio-fix-duplicate-dev_attr_name.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-=
fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
reiser4-export-remove_from_page_cache-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
