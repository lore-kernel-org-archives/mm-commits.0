From: akpm@linux-foundation.org
Subject: + kernel-time-use-array_size-macro-in-timecomparec.patch added to -mm tree
Date: Mon, 23 Aug 2010 16:47:24 -0700
Message-ID: <201008232347.o7NNlOWq022497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766Ab0HWXr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 19:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nikitasangelinas@googlemail.com, tglx@linutronix.de


The patch titled
     kernel: time: use ARRAY_SIZE macro in timecompare.c
has been added to the -mm tree.  Its filename is
     kernel-time-use-array_size-macro-in-timecomparec.patch

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
Subject: kernel: time: use ARRAY_SIZE macro in timecompare.c
From: Nikitas Angelinas <nikitasangelinas@googlemail.com>

Replace sizeof(buffer)/sizeof(buffer[0]) with ARRAY_SIZE(buffer) in
kernel/time/timecompare.c

Signed-off-by: Nikitas Angelinas <nikitasangelinas@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timecompare.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/time/timecompare.c~kernel-time-use-array_size-macro-in-timecomparec kernel/time/timecompare.c
--- a/kernel/time/timecompare.c~kernel-time-use-array_size-macro-in-timecomparec
+++ a/kernel/time/timecompare.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/math64.h>
+#include <linux/kernel.h>
 
 /*
  * fixed point arithmetic scale factor for skew
@@ -57,11 +58,11 @@ int timecompare_offset(struct timecompar
 	int index;
 	int num_samples = sync->num_samples;
 
-	if (num_samples > sizeof(buffer)/sizeof(buffer[0])) {
+	if (num_samples > ARRAY_SIZE(buffer)) {
 		samples = kmalloc(sizeof(*samples) * num_samples, GFP_ATOMIC);
 		if (!samples) {
 			samples = buffer;
-			num_samples = sizeof(buffer)/sizeof(buffer[0]);
+			num_samples = ARRAY_SIZE(buffer);
 		}
 	} else {
 		samples = buffer;
_

Patches currently in -mm which might be from nikitasangelinas@googlemail.com are

kernel-time-use-array_size-macro-in-timecomparec.patch

