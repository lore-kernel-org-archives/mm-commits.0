From: akpm@linux-foundation.org
Subject: [merged] kexec-remove-kmsg_dump_kexec.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:16 -0800
Message-ID: <20120113203616.B397E1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56060 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:17 -0500
Received: by mail-yx0-f202.google.com with SMTP id l1so72336yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, ebiederm@xmission.com, jarod@redhat.com, kosaki.motohiro@jp.fujitsu.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove KMSG_DUMP_KEXEC
has been removed from the -mm tree.  Its filename was
     kexec-remove-kmsg_dump_kexec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: kexec: remove KMSG_DUMP_KEXEC

KMSG_DUMP_KEXEC is useless because we already save kernel messages inside
/proc/vmcore, and it is unsafe to allow modules to do other stuffs in a
crash dump scenario.

[akpm@linux-foundation.org: fix powerpc build]
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Reported-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Jarod Wilson <jarod@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/nvram.c |    1 -
 drivers/char/ramoops.c                 |    3 +--
 drivers/mtd/mtdoops.c                  |    3 +--
 include/linux/kmsg_dump.h              |    1 -
 kernel/kexec.c                         |    3 ---
 5 files changed, 2 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/platforms/pseries/nvram.c~kexec-remove-kmsg_dump_kexec arch/powerpc/platforms/pseries/nvram.c
--- a/arch/powerpc/platforms/pseries/nvram.c~kexec-remove-kmsg_dump_kexec
+++ a/arch/powerpc/platforms/pseries/nvram.c
@@ -638,7 +638,6 @@ static void oops_to_nvram(struct kmsg_du
 		/* These are almost always orderly shutdowns. */
 		return;
 	case KMSG_DUMP_OOPS:
-	case KMSG_DUMP_KEXEC:
 		break;
 	case KMSG_DUMP_PANIC:
 		panicking = true;
diff -puN drivers/char/ramoops.c~kexec-remove-kmsg_dump_kexec drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~kexec-remove-kmsg_dump_kexec
+++ a/drivers/char/ramoops.c
@@ -83,8 +83,7 @@ static void ramoops_do_dump(struct kmsg_
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
@@ -315,8 +315,7 @@ static void mtdoops_do_dump(struct kmsg_
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
@@ -18,7 +18,6 @@
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
 #include <linux/syscore_ops.h>
 
 #include <asm/page.h>
@@ -1094,8 +1093,6 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
-			kmsg_dump(KMSG_DUMP_KEXEC);
