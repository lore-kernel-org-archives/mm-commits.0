From: akpm@linux-foundation.org
Subject: [merged] add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitreverse.patch removed from -mm tree
Date: Tue, 11 Aug 2009 14:45:41 -0700
Message-ID: <200908112145.n7BLjfEf013104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037AbZHKVrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 17:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, david@hardeman.nu, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input/winbond-cir: select BITREVERSE
has been removed from the -mm tree.  Its filename was
     add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitr=
everse.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input/winbond-cir: select BITREVERSE
=46rom: Randy Dunlap <randy.dunlap@oracle.com>

winbond-cir driver uses bitreverse functions so it needs to select
BITREVERSE to fix these build errors:

drivers/built-in.o: In function `wbcir_shutdown':
winbond-cir.c:(.text+0x104fc7): undefined reference to `byte_rev_table'
winbond-cir.c:(.text+0x104fd8): undefined reference to `byte_rev_table'
winbond-cir.c:(.text+0x104ff4): undefined reference to `byte_rev_table'
drivers/built-in.o: In function `wbcir_irq_handler':
winbond-cir.c:(.text+0x105f47): undefined reference to `byte_rev_table'
winbond-cir.c:(.text+0x105f5f): undefined reference to `byte_rev_table'
drivers/built-in.o:winbond-cir.c:(.text+0x105f77): more undefined refer=
ences to `byte_rev_table' follow

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David H=E4rdeman <david@hardeman.nu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/misc/Kconfig~add-a-driver-for-the-winbond-wpcd3=
76i-ir-functionality-select-bitreverse drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~add-a-driver-for-the-winbond-wpcd376i-=
ir-functionality-select-bitreverse
+++ a/drivers/input/misc/Kconfig
@@ -226,6 +226,7 @@ config INPUT_WINBOND_CIR
 	tristate "Winbond IR remote control"
 	depends on X86 && ACPI
 	select LEDS_CLASS
+	select BITREVERSE
 	help
 	  Say Y here if you want to use the IR remote functionality found
 	  in some Winbond SuperI/O chips. Currently only the WPCD376I
_

Patches currently in -mm which might be from randy.dunlap@oracle.com ar=
e

origin.patch
linux-next.patch
soc-fix-i2c-build-errors.patch
media-zr364xx-fix-build-errors.patch
dvb-siano-uses-depends-on-input.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sys=
fs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
usb-otg-fix-twl4030-usb-build.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitrevers=
e.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-=
fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
reiser4-export-remove_from_page_cache-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
