From: akpm@linux-foundation.org
Subject: + kexec-remove-kmsg_dump_kexec.patch added to -mm tree
Date: Tue, 01 Feb 2011 16:23:33 -0800
Message-ID: <201102020023.p120NXfm007214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522Ab1BBAXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 19:23:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, ebiederm@xmission.com, jarod@redhat.com, kosaki.motohiro@jp.fujitsu.com, vgoyal@redhat.com


The patch titled
     kexec: remove KMSG_DUMP_KEXEC
has been added to the -mm tree.  Its filename is
     kexec-remove-kmsg_dump_kexec.patch

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
Subject: kexec: remove KMSG_DUMP_KEXEC
From: WANG Cong <xiyou.wangcong@gmail.com>

KMSG_DUMP_KEXEC is useless because we already save kernel messages inside
/proc/vmcore, and it is unsafe to allow modules to do other stuffs in a
crash dump scenario.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Reported-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Jarod Wilson <jarod@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c    |    3 +--
 drivers/mtd/mtdoops.c     |    3 +--
 include/linux/kmsg_dump.h |    1 -
 kernel/kexec.c            |    3 ---
 4 files changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/char/ramoops.c~kexec-remove-kmsg_dump_kexec drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~kexec-remove-kmsg_dump_kexec
+++ a/drivers/char/ramoops.c
@@ -69,8 +69,7 @@ static void ramoops_do_dump(struct kmsg_
 	struct timeval timestamp;
 
 	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC &&
-	    reason != KMSG_DUMP_KEXEC)
+	    reason != KMSG_DUMP_PANIC)
 		return;
 
 	/* Only dump oopses if dump_oops is set */
diff -puN drivers/mtd/mtdoops.c~kexec-remove-kmsg_dump_kexec drivers/mtd/mtdoops.c
--- a/drivers/mtd/mtdoops.c~kexec-remove-kmsg_dump_kexec
+++ a/drivers/mtd/mtdoops.c
@@ -308,8 +308,7 @@ static void mtdoops_do_dump(struct kmsg_
 	char *dst;
 
 	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC &&
-	    reason != KMSG_DUMP_KEXEC)
+	    reason != KMSG_DUMP_PANIC)
 		return;
 
 	/* Only dump oopses if dump_oops is set */
diff -puN include/linux/kmsg_dump.h~kexec-remove-kmsg_dump_kexec include/linux/kmsg_dump.h
--- a/include/linux/kmsg_dump.h~kexec-remove-kmsg_dump_kexec
+++ a/include/linux/kmsg_dump.h
@@ -17,7 +17,6 @@
 enum kmsg_dump_reason {
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
-	KMSG_DUMP_KEXEC,
 	KMSG_DUMP_RESTART,
 	KMSG_DUMP_HALT,
 	KMSG_DUMP_POWEROFF,
diff -puN kernel/kexec.c~kexec-remove-kmsg_dump_kexec kernel/kexec.c
--- a/kernel/kexec.c~kexec-remove-kmsg_dump_kexec
+++ a/kernel/kexec.c
@@ -32,7 +32,6 @@
 #include <linux/console.h>
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
-#include <linux/kmsg_dump.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1078,8 +1077,6 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
-			kmsg_dump(KMSG_DUMP_KEXEC);
