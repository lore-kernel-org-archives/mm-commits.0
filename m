From: akpm@linux-foundation.org
Subject: + byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch added to -mm tree
Date: Wed, 15 Oct 2008 15:04:21 -0700
Message-ID: <200810152204.m9FM4LB4011352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509AbYJOWF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 18:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mchehab@infradead.org, paulmck@us.ibm.com


The patch titled
     byteorder: remove direct includes of linux/byteorder/swab[b].h
has been added to the -mm tree.  Its filename is
     byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: remove direct includes of linux/byteorder/swab[b].h
From: Harvey Harrison <harvey.harrison@gmail.com>

A consolidated implementation will provide this generically through
asm/byteorder, remove direct includes to avoid breakage when the
changeover to the new implementation occurs.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/ttpci/av7110.c       |    2 +-
 drivers/media/video/cx18/cx18-driver.h |    1 +
 drivers/media/video/ivtv/ivtv-driver.h |    1 +
 kernel/rcupreempt.c                    |    2 +-
 tests/rcutorture.c                     |    3 ++-
 5 files changed, 6 insertions(+), 3 deletions(-)

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
diff -puN /dev/null /dev/null
diff -puN tests/rcutorture.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh tests/rcutorture.c
--- a/tests/rcutorture.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh
+++ a/tests/rcutorture.c
@@ -42,11 +42,12 @@
 #include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
 
+#include <asm/byteorder.h>
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
               "Josh Triplett <josh@freedesktop.org>");
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
byteorder-provide-swabbh-generically-in-asm-byteorderh.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch

