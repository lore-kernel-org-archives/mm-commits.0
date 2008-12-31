From: akpm@linux-foundation.org
Subject: + spih-uses-needs-deviceh.patch added to -mm tree
Date: Tue, 30 Dec 2008 20:47:03 -0800
Message-ID: <200812310447.mBV4l31V020687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbYLaErN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 23:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dbrownell@users.sourceforge.net


The patch titled
     spi.h uses/needs device.h
has been added to the -mm tree.  Its filename is
     spih-uses-needs-deviceh.patch

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
Subject: spi.h uses/needs device.h
From: Randy Dunlap <randy.dunlap@oracle.com>

Include header files as used/needed:

In file included from mmotm-2008-1230-1605/drivers/leds/leds-dac124s085.c:16:
mmotm-2008-1230-1605/include/linux/spi/spi.h:66: error: field 'dev' has incomplete type
mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'to_spi_device':
mmotm-2008-1230-1605/include/linux/spi/spi.h:100: warning: type defaults to 'int' in declaration of '__mptr'
<etc>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/spi.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/spi/spi.h~spih-uses-needs-deviceh include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spih-uses-needs-deviceh
+++ a/include/linux/spi/spi.h
@@ -19,6 +19,8 @@
 #ifndef __LINUX_SPI_H
 #define __LINUX_SPI_H
 
+#include <linux/device.h>
+
 /*
  * INTERFACES between SPI master-side drivers and SPI infrastructure.
  * (There's no SPI slave support for Linux yet...)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
spih-uses-needs-deviceh.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-how-to-use-doc-section-blocks.patch
docs-add-more-early-params-to-kernel-parameterstxt.patch
doc-reformat-some-long-lines-in-kernel-parameterstxt.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

