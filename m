From: akpm@linux-foundation.org
Subject: + usb-otg-fix-twl4030-usb-build.patch added to -mm tree
Date: Tue, 11 Aug 2009 13:57:03 -0700
Message-ID: <200908112057.n7BKv3Mf026716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752815AbZHKU6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 16:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, felipe.balbi@nokia.com, greg@kroah.com


The patch titled
     usb/otg: fix twl4030-usb build
has been added to the -mm tree.  Its filename is
     usb-otg-fix-twl4030-usb-build.patch

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
Subject: usb/otg: fix twl4030-usb build
From: Randy Dunlap <randy.dunlap@oracle.com>

subsys_initcall_sync() is only defined for built-in code, not for loadable
modules, so this driver build fails when built as a module.  However, the
_sync() forms of the initcalls are not implemented, so this should not be
used -- just use the non-sync form of it.

drivers/usb/otg/twl4030-usb.c:777: warning: data definition has no type or storage class
drivers/usb/otg/twl4030-usb.c:777: warning: type defaults to 'int' in declaration of 'subsys_initcall_sync'
drivers/usb/otg/twl4030-usb.c:777: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/otg/twl4030-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/otg/twl4030-usb.c~usb-otg-fix-twl4030-usb-build drivers/usb/otg/twl4030-usb.c
--- a/drivers/usb/otg/twl4030-usb.c~usb-otg-fix-twl4030-usb-build
+++ a/drivers/usb/otg/twl4030-usb.c
@@ -774,7 +774,7 @@ static int __init twl4030_usb_init(void)
 {
 	return platform_driver_register(&twl4030_usb_driver);
 }
-subsys_initcall_sync(twl4030_usb_init);
+subsys_initcall(twl4030_usb_init);
 
 static void __exit twl4030_usb_exit(void)
 {
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
usb-otg-fix-twl4030-usb-build.patch
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

