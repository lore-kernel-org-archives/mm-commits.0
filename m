From: akpm@linux-foundation.org
Subject: - genericizing-iova-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 01:26:18 -0800
Message-ID: <200802060925.m169Px5Q003282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760298AbYBFJ0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 04:26:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anil.s.keshavamurthy@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     genericizing-iova-fix
has been removed from the -mm tree.  Its filename was
     genericizing-iova-fix.patch

This patch was dropped because it was folded into genericizing-iova.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genericizing-iova-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/pci/dmar.c: In function 'parse_dmar_table':
drivers/pci/dmar.c:267: error: 'PAGE_SHIFT_4K' undeclared (first use in this function)
drivers/pci/dmar.c:267: error: (Each undeclared identifier is reported only once
drivers/pci/dmar.c:267: error: for each function it appears in.)

Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c        |    1 +
 drivers/pci/intel-iommu.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/pci/dmar.c~genericizing-iova-fix drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~genericizing-iova-fix
+++ a/drivers/pci/dmar.c
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/dmar.h>
 #include "iova.h"
+#include "intel-iommu.h"
 
 #undef PREFIX
 #define PREFIX "DMAR:"
diff -puN drivers/pci/intel-iommu.h~genericizing-iova-fix drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h~genericizing-iova-fix
+++ a/drivers/pci/intel-iommu.h
@@ -23,6 +23,7 @@
 
 #include <linux/types.h>
 #include <linux/msi.h>
+#include <linux/sysdev.h>
 #include "iova.h"
 #include <linux/io.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
genericizing-iova.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
remove-support-for-un-needed-_extratext-section.patch
allow-auto-destruction-of-loop-devices.patch
read_current_time-cleanups.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
kallsyms-should-prefer-non-weak-symbols.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
stopmachine-semaphore-to-mutex.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec.patch
system-timer-fix-crash-in-100hz-system-timer.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
rtc-ds1302-rtc-support.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
fbmon-cleanup-trailing-whitespaces.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init.patch
isapnp-driver-semaphore-to-mutex.patch
ext3-fix-lock-inversion-in-direct-io.patch
