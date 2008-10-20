From: akpm@linux-foundation.org
Subject: - byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:31 -0700
Message-ID: <200810202037.m9KKbV6r011652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024AbYJTUie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mchehab@infradead.org, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     byteorder: remove direct includes of linux/byteorder/swab[b].h
has been removed from the -mm tree.  Its filename was
     byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: remove direct includes of linux/byteorder/swab[b].h
From: Harvey Harrison <harvey.harrison@gmail.com>

A consolidated implementation will provide this generically through
asm/byteorder, remove direct includes to avoid breakage when the
changeover to the new implementation occurs.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Acked-by: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/ttpci/av7110.c       |    2 +-
 drivers/media/video/cx18/cx18-driver.h |    1 +
 drivers/media/video/ivtv/ivtv-driver.h |    1 +
 kernel/rcupreempt.c                    |    2 +-
 4 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/media/dvb/ttpci/av7110.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh drivers/media/dvb/ttpci/av7110.c
--- a/drivers/media/dvb/ttpci/av7110.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh
+++ a/drivers/media/dvb/ttpci/av7110.c
@@ -36,7 +36,6 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/smp_lock.h>
 
 #include <linux/kernel.h>
@@ -52,6 +51,7 @@
 #include <linux/i2c.h>
 #include <linux/kthread.h>
 #include <asm/unaligned.h>
+#include <asm/byteorder.h>
 
 #include <asm/system.h>
 
diff -puN drivers/media/video/cx18/cx18-driver.h~byteorder-remove-direct-includes-of-linux-byteorder-swabh drivers/media/video/cx18/cx18-driver.h
--- a/drivers/media/video/cx18/cx18-driver.h~byteorder-remove-direct-includes-of-linux-byteorder-swabh
+++ a/drivers/media/video/cx18/cx18-driver.h
@@ -41,6 +41,7 @@
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <asm/byteorder.h>
 
 #include <linux/dvb/video.h>
 #include <linux/dvb/audio.h>
diff -puN drivers/media/video/ivtv/ivtv-driver.h~byteorder-remove-direct-includes-of-linux-byteorder-swabh drivers/media/video/ivtv/ivtv-driver.h
--- a/drivers/media/video/ivtv/ivtv-driver.h~byteorder-remove-direct-includes-of-linux-byteorder-swabh
+++ a/drivers/media/video/ivtv/ivtv-driver.h
@@ -55,6 +55,7 @@
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
+#include <asm/byteorder.h>
 
 #include <linux/dvb/video.h>
 #include <linux/dvb/audio.h>
diff -puN kernel/rcupreempt.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh
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
  * PREEMPT_RCU data structures.
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch

