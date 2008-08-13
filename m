From: akpm@linux-foundation.org
Subject: - byteorder-fix-direct-byteswap-includes.patch removed from -mm tree
Date: Tue, 12 Aug 2008 22:44:16 -0700
Message-ID: <200808130557.m7D5vLNw001396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242AbYHMF5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 01:57:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     byteorder: fix direct byteswap includes
has been removed from the -mm tree.  Its filename was
     byteorder-fix-direct-byteswap-includes.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: fix direct byteswap includes
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mach-at32ap/include/mach/io.h |    3 +--
 drivers/media/dvb/ttpci/av7110.c         |    2 +-
 drivers/media/video/cx18/cx18-driver.h   |    2 +-
 drivers/media/video/ivtv/ivtv-driver.h   |    2 +-
 drivers/media/video/vpx3220.c            |    2 +-
 kernel/rcupreempt.c                      |    2 +-
 tests/rcutorture.c                       |    2 +-
 7 files changed, 7 insertions(+), 8 deletions(-)

diff -puN arch/avr32/mach-at32ap/include/mach/io.h~byteorder-fix-direct-byteswap-includes arch/avr32/mach-at32ap/include/mach/io.h
--- a/arch/avr32/mach-at32ap/include/mach/io.h~byteorder-fix-direct-byteswap-includes
+++ a/arch/avr32/mach-at32ap/include/mach/io.h
@@ -1,8 +1,7 @@
 #ifndef __ASM_AVR32_ARCH_AT32AP_IO_H
 #define __ASM_AVR32_ARCH_AT32AP_IO_H
 
-/* For "bizarre" halfword swapping */
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 
 #if defined(CONFIG_AP700X_32_BIT_SMC)
 # define __swizzle_addr_b(addr)	(addr ^ 3UL)
diff -puN drivers/media/dvb/ttpci/av7110.c~byteorder-fix-direct-byteswap-includes drivers/media/dvb/ttpci/av7110.c
--- a/drivers/media/dvb/ttpci/av7110.c~byteorder-fix-direct-byteswap-includes
+++ a/drivers/media/dvb/ttpci/av7110.c
@@ -36,7 +36,6 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/smp_lock.h>
 
 #include <linux/kernel.h>
@@ -53,6 +52,7 @@
 #include <linux/kthread.h>
 #include <asm/unaligned.h>
 
+#include <asm/byteorder.h>
 #include <asm/system.h>
 
 #include <linux/dvb/frontend.h>
diff -puN drivers/media/video/cx18/cx18-driver.h~byteorder-fix-direct-byteswap-includes drivers/media/video/cx18/cx18-driver.h
--- a/drivers/media/video/cx18/cx18-driver.h~byteorder-fix-direct-byteswap-includes
+++ a/drivers/media/video/cx18/cx18-driver.h
@@ -38,10 +38,10 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/list.h>
 #include <linux/unistd.h>
-#include <linux/byteorder/swab.h>
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <asm/byteorder.h>
 
 #include <linux/dvb/video.h>
 #include <linux/dvb/audio.h>
diff -puN drivers/media/video/ivtv/ivtv-driver.h~byteorder-fix-direct-byteswap-includes drivers/media/video/ivtv/ivtv-driver.h
--- a/drivers/media/video/ivtv/ivtv-driver.h~byteorder-fix-direct-byteswap-includes
+++ a/drivers/media/video/ivtv/ivtv-driver.h
@@ -49,11 +49,11 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/list.h>
 #include <linux/unistd.h>
-#include <linux/byteorder/swab.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <asm/byteorder.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
diff -puN drivers/media/video/vpx3220.c~byteorder-fix-direct-byteswap-includes drivers/media/video/vpx3220.c
--- a/drivers/media/video/vpx3220.c~byteorder-fix-direct-byteswap-includes
+++ a/drivers/media/video/vpx3220.c
@@ -24,7 +24,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 
-#include <linux/byteorder/swab.h>
+#include <asm/byteorder.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
diff -puN kernel/rcupreempt.c~byteorder-fix-direct-byteswap-includes kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~byteorder-fix-direct-byteswap-includes
+++ a/kernel/rcupreempt.c
@@ -54,9 +54,9 @@
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/cpumask.h>
 #include <linux/rcupreempt_trace.h>
+#include <asm/byteorder.h>
 
 /*
  * Macro that prevents the compiler from reordering accesses, but does
diff -puN tests/rcutorture.c~byteorder-fix-direct-byteswap-includes tests/rcutorture.c
--- a/tests/rcutorture.c~byteorder-fix-direct-byteswap-includes
+++ a/tests/rcutorture.c
@@ -42,10 +42,10 @@
 #include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <asm/byteorder.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
kvm-make-functions-static.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
net-tipc-subscrc-dont-use-___constant_swab32.patch
byteorder-fix-direct-byteswap-includes.patch
byteorder-remove-the-old-byteorder-implementation.patch

