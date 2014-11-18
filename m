From: akpm@linux-foundation.org
Subject: + zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch added to -mm tree
Date: Tue, 18 Nov 2014 14:13:07 -0800
Message-ID: <546bc473.MdH7kb2uSeOPa6ql%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaKRWNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 17:13:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix zs_init cpu notifier error handling
has been added to the -mm tree.  Its filename is
     zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: fix zs_init cpu notifier error handling

Mahendran Ganesh reported that zpool-enabled zsmalloc should not call
zpool_unregister_driver() from zs_init() if cpu notifier registration has
failed, because error handling is performed before we register the driver
via zpool_register_driver() call.

Factor out cpu notifier registration and unregistration code and fix
zs_init() error handling.

link: http://lkml.iu.edu//hypermail/linux/kernel/1411.1/04156.html
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-zs_init-cpu-notifier-error-handling mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-zs_init-cpu-notifier-error-handling
+++ a/mm/zsmalloc.c
@@ -881,14 +881,10 @@ static struct notifier_block zs_cpu_nb =
 	.notifier_call = zs_cpu_notifier
 };
 
-static void zs_exit(void)
+static void zs_unregister_cpu_notifier(void)
 {
 	int cpu;
 
-#ifdef CONFIG_ZPOOL
-	zpool_unregister_driver(&zs_zpool_driver);
-#endif
-
 	cpu_notifier_register_begin();
 
 	for_each_online_cpu(cpu)
@@ -898,7 +894,7 @@ static void zs_exit(void)
 	cpu_notifier_register_done();
 }
 
-static int zs_init(void)
+static int zs_register_cpu_notifier(void)
 {
 	int cpu, ret;
 
@@ -907,22 +903,35 @@ static int zs_init(void)
 	__register_cpu_notifier(&zs_cpu_nb);
 	for_each_online_cpu(cpu) {
 		ret = zs_cpu_notifier(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
-		if (notifier_to_errno(ret)) {
-			cpu_notifier_register_done();
-			goto fail;
-		}
+		if (notifier_to_errno(ret))
+			break;
 	}
 
 	cpu_notifier_register_done();
+	return notifier_to_errno(ret);
+}
 
+static void zs_exit(void)
+{
 #ifdef CONFIG_ZPOOL
-	zpool_register_driver(&zs_zpool_driver);
+	zpool_unregister_driver(&zs_zpool_driver);
 #endif
+	zs_unregister_cpu_notifier();
+}
+
+static int zs_init(void)
+{
+	int ret = zs_register_cpu_notifier();
 
+	if (ret) {
+		zs_unregister_cpu_notifier();
+		return ret;
+	}
+
+#ifdef CONFIG_ZPOOL
+	zpool_register_driver(&zs_zpool_driver);
+#endif
 	return 0;
-fail:
-	zs_exit();
-	return notifier_to_errno(ret);
 }
 
 static unsigned int get_maxobj_per_zspage(int size, int pages_per_zspage)
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-merge-size_class-to-reduce-fragmentation.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch

