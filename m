From: akpm@linux-foundation.org
Subject: + ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch added to -mm tree
Date: Wed, 12 May 2010 13:47:41 -0700
Message-ID: <201005122047.o4CKlfRO019438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258Ab0ELUrq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 16:47:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, michael.hennerich@analog.com


The patch titled
     misc: fix ad525X_dpot build
has been added to the -mm tree.  Its filename is
     ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch

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
Subject: misc: fix ad525X_dpot build
From: Randy Dunlap <randy.dunlap@oracle.com>

Add slab.h to fix build:

drivers/misc/ad525x_dpot.c:609: error: implicit declaration of function 'kzalloc'
drivers/misc/ad525x_dpot.c:609: warning: assignment makes pointer from integer without a cast
drivers/misc/ad525x_dpot.c:656: error: implicit declaration of function 'kfree'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ad525x_dpot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/ad525x_dpot.c~ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build drivers/misc/ad525x_dpot.c
--- a/drivers/misc/ad525x_dpot.c~ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build
+++ a/drivers/misc/ad525x_dpot.c
@@ -55,6 +55,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 #define DRIVER_VERSION			"0.2"
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
dib3000mc-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
aio-fix-the-compat-vectored-operations-fix.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

