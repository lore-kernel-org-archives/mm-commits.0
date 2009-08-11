From: akpm@linux-foundation.org
Subject: + dvb-siano-uses-depends-on-input.patch added to -mm tree
Date: Mon, 10 Aug 2009 21:09:35 -0700
Message-ID: <200908110409.n7B49ZIE014316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbZHKLzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mchehab@infradead.org, mkrufky@linuxtv.org, uris@siano-ms.com


The patch titled
     dvb: siano uses/depends on INPUT
has been added to the -mm tree.  Its filename is
     dvb-siano-uses-depends-on-input.patch

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
Subject: dvb: siano uses/depends on INPUT
From: Randy Dunlap <randy.dunlap@oracle.com>

siano uses input_*() functions so it should depend on INPUT
to prevent build errors:

ERROR: "input_event" [drivers/media/dvb/siano/sms1xxx.ko] undefined!
ERROR: "input_register_device" [drivers/media/dvb/siano/sms1xxx.ko] undefined!
ERROR: "input_free_device" [drivers/media/dvb/siano/sms1xxx.ko] undefined!
ERROR: "input_unregister_device" [drivers/media/dvb/siano/sms1xxx.ko] undefined!
ERROR: "input_allocate_device" [drivers/media/dvb/siano/sms1xxx.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: Uri Shkolnik <uris@siano-ms.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/siano/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/siano/Kconfig~dvb-siano-uses-depends-on-input drivers/media/dvb/siano/Kconfig
--- a/drivers/media/dvb/siano/Kconfig~dvb-siano-uses-depends-on-input
+++ a/drivers/media/dvb/siano/Kconfig
@@ -4,7 +4,7 @@
 
 config DVB_SIANO_SMS1XXX
 	tristate "Siano SMS1XXX USB dongle support"
-	depends on DVB_CORE && USB
+	depends on DVB_CORE && USB && INPUT
 	---help---
 	  Choose Y here if you have a USB dongle with a SMS1XXX chipset.
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
soc-fix-i2c-build-errors.patch
media-zr364xx-fix-build-errors.patch
dvb-siano-uses-depends-on-input.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitreverse.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
reiser4-export-remove_from_page_cache-fix.patch

