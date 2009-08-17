From: akpm@linux-foundation.org
Subject: [merged] usb-otg-fix-twl4030-usb-build.patch removed from -mm tree
Date: Mon, 17 Aug 2009 13:05:02 -0700
Message-ID: <200908172005.n7HK52A2017733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbZHQULw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 16:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, felipe.balbi@nokia.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb/otg: fix twl4030-usb build
has been removed from the -mm tree.  Its filename was
     usb-otg-fix-twl4030-usb-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
reiser4-export-remove_from_page_cache-fix.patch

