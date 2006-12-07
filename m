From: akpm@osdl.org
Subject: - paride-rename-pi_register-and-pi_unregister.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:27 -0800
Message-ID: <200612072302.kB7N2R6M029853@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51690 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163790AbWLGXCa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     paride: rename pi_register() and pi_unregister()
has been removed from the -mm tree.  Its filename was
     paride-rename-pi_register-and-pi_unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paride: rename pi_register() and pi_unregister()
From: Alexey Dobriyan <adobriyan@gmail.com>

We're about to change the semantics of pi_register()'s return value, so
rename it to something else first, so that any unconverted code reliaby
breaks.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/paride/aten.c   |    4 ++--
 drivers/block/paride/bpck.c   |    4 ++--
 drivers/block/paride/bpck6.c  |    4 ++--
 drivers/block/paride/comm.c   |    4 ++--
 drivers/block/paride/dstr.c   |    4 ++--
 drivers/block/paride/epat.c   |    4 ++--
 drivers/block/paride/epia.c   |    4 ++--
 drivers/block/paride/fit2.c   |    4 ++--
 drivers/block/paride/fit3.c   |    4 ++--
 drivers/block/paride/friq.c   |    4 ++--
 drivers/block/paride/frpw.c   |    4 ++--
 drivers/block/paride/kbic.c   |    6 +++---
 drivers/block/paride/ktti.c   |    4 ++--
 drivers/block/paride/on20.c   |    4 ++--
 drivers/block/paride/on26.c   |    4 ++--
 drivers/block/paride/paride.c |    8 ++++----
 drivers/block/paride/paride.h |    4 ++--
 17 files changed, 37 insertions(+), 37 deletions(-)

diff -puN drivers/block/paride/aten.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/aten.c
--- a/drivers/block/paride/aten.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/aten.c
@@ -149,12 +149,12 @@ static struct pi_protocol aten = {
 
 static int __init aten_init(void)
 {
-	return pi_register(&aten)-1;
+	return paride_register(&aten)-1;
 }
 
 static void __exit aten_exit(void)
 {
-	pi_unregister( &aten );
+	paride_unregister( &aten );
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/bpck.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/bpck.c
--- a/drivers/block/paride/bpck.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/bpck.c
@@ -464,12 +464,12 @@ static struct pi_protocol bpck = {
 
 static int __init bpck_init(void)
 {
-	return pi_register(&bpck)-1;
+	return paride_register(&bpck)-1;
 }
 
 static void __exit bpck_exit(void)
 {
-	pi_unregister(&bpck);
+	paride_unregister(&bpck);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/bpck6.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/bpck6.c
--- a/drivers/block/paride/bpck6.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/bpck6.c
@@ -265,12 +265,12 @@ static int __init bpck6_init(void)
 	printk(KERN_INFO "bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. USA\n");
 	if(verbose)
 		printk(KERN_DEBUG "bpck6: verbose debug enabled.\n");
-	return pi_register(&bpck6) - 1;  
+	return paride_register(&bpck6) - 1;
 }
 
 static void __exit bpck6_exit(void)
 {
-	pi_unregister(&bpck6);
+	paride_unregister(&bpck6);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/comm.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/comm.c
--- a/drivers/block/paride/comm.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/comm.c
@@ -205,12 +205,12 @@ static struct pi_protocol comm = {
 
 static int __init comm_init(void)
 {
-	return pi_register(&comm)-1;
+	return paride_register(&comm)-1;
 }
 
 static void __exit comm_exit(void)
 {
-	pi_unregister(&comm);
+	paride_unregister(&comm);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/dstr.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/dstr.c
--- a/drivers/block/paride/dstr.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/dstr.c
@@ -220,12 +220,12 @@ static struct pi_protocol dstr = {
 
 static int __init dstr_init(void)
 {
-	return pi_register(&dstr)-1;
+	return paride_register(&dstr)-1;
 }
 
 static void __exit dstr_exit(void)
 {
-	pi_unregister(&dstr);
+	paride_unregister(&dstr);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/epat.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/epat.c
--- a/drivers/block/paride/epat.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/epat.c
@@ -327,12 +327,12 @@ static int __init epat_init(void)
 #ifdef CONFIG_PARIDE_EPATC8
 	epatc8 = 1;
 #endif
-	return pi_register(&epat)-1;
+	return paride_register(&epat)-1;
 }
 
 static void __exit epat_exit(void)
 {
-	pi_unregister(&epat);
+	paride_unregister(&epat);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/epia.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/epia.c
--- a/drivers/block/paride/epia.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/epia.c
@@ -303,12 +303,12 @@ static struct pi_protocol epia = {
 
 static int __init epia_init(void)
 {
-	return pi_register(&epia)-1;
+	return paride_register(&epia)-1;
 }
 
 static void __exit epia_exit(void)
 {
-	pi_unregister(&epia);
+	paride_unregister(&epia);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/fit2.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/fit2.c
--- a/drivers/block/paride/fit2.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/fit2.c
@@ -138,12 +138,12 @@ static struct pi_protocol fit2 = {
 
 static int __init fit2_init(void)
 {
-	return pi_register(&fit2)-1;
+	return paride_register(&fit2)-1;
 }
 
 static void __exit fit2_exit(void)
 {
-	pi_unregister(&fit2);
+	paride_unregister(&fit2);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/fit3.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/fit3.c
--- a/drivers/block/paride/fit3.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/fit3.c
@@ -198,12 +198,12 @@ static struct pi_protocol fit3 = {
 
 static int __init fit3_init(void)
 {
-	return pi_register(&fit3)-1;
+	return paride_register(&fit3)-1;
 }
 
 static void __exit fit3_exit(void)
 {
-	pi_unregister(&fit3);
+	paride_unregister(&fit3);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/friq.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/friq.c
--- a/drivers/block/paride/friq.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/friq.c
@@ -263,12 +263,12 @@ static struct pi_protocol friq = {
 
 static int __init friq_init(void)
 {
-	return pi_register(&friq)-1;
+	return paride_register(&friq)-1;
 }
 
 static void __exit friq_exit(void)
 {
-	pi_unregister(&friq);
+	paride_unregister(&friq);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/frpw.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/frpw.c
--- a/drivers/block/paride/frpw.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/frpw.c
@@ -300,12 +300,12 @@ static struct pi_protocol frpw = {
 
 static int __init frpw_init(void)
 {
-	return pi_register(&frpw)-1;
+	return paride_register(&frpw)-1;
 }
 
 static void __exit frpw_exit(void)
 {
-	pi_unregister(&frpw);
+	paride_unregister(&frpw);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/kbic.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/kbic.c
--- a/drivers/block/paride/kbic.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/kbic.c
@@ -283,13 +283,13 @@ static struct pi_protocol k971 = {
 
 static int __init kbic_init(void)
 {
-	return (pi_register(&k951)||pi_register(&k971))-1;
+	return (paride_register(&k951)||paride_register(&k971))-1;
 }
 
 static void __exit kbic_exit(void)
 {
-	pi_unregister(&k951);
-	pi_unregister(&k971);
+	paride_unregister(&k951);
+	paride_unregister(&k971);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/ktti.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/ktti.c
--- a/drivers/block/paride/ktti.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/ktti.c
@@ -115,12 +115,12 @@ static struct pi_protocol ktti = {
 
 static int __init ktti_init(void)
 {
-	return pi_register(&ktti)-1;
+	return paride_register(&ktti)-1;
 }
 
 static void __exit ktti_exit(void)
 {
-	pi_unregister(&ktti);
+	paride_unregister(&ktti);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/on20.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/on20.c
--- a/drivers/block/paride/on20.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/on20.c
@@ -140,12 +140,12 @@ static struct pi_protocol on20 = {
 
 static int __init on20_init(void)
 {
-	return pi_register(&on20)-1;
+	return paride_register(&on20)-1;
 }
 
 static void __exit on20_exit(void)
 {
-	pi_unregister(&on20);
+	paride_unregister(&on20);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/on26.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/on26.c
--- a/drivers/block/paride/on26.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/on26.c
@@ -306,12 +306,12 @@ static struct pi_protocol on26 = {
 
 static int __init on26_init(void)
 {
-	return pi_register(&on26)-1;
+	return paride_register(&on26)-1;
 }
 
 static void __exit on26_exit(void)
 {
-	pi_unregister(&on26);
+	paride_unregister(&on26);
 }
 
 MODULE_LICENSE("GPL");
diff -puN drivers/block/paride/paride.c~paride-rename-pi_register-and-pi_unregister drivers/block/paride/paride.c
--- a/drivers/block/paride/paride.c~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/paride.c
@@ -229,7 +229,7 @@ static int pi_test_proto(PIA * pi, char 
 	return res;
 }
 
-int pi_register(PIP * pr)
+int paride_register(PIP * pr)
 {
 	int k;
 
@@ -252,9 +252,9 @@ int pi_register(PIP * pr)
 	return 1;
 }
 
-EXPORT_SYMBOL(pi_register);
+EXPORT_SYMBOL(paride_register);
 
-void pi_unregister(PIP * pr)
+void paride_unregister(PIP * pr)
 {
 	if (!pr)
 		return;
@@ -265,7 +265,7 @@ void pi_unregister(PIP * pr)
 	protocols[pr->index] = NULL;
 }
 
-EXPORT_SYMBOL(pi_unregister);
+EXPORT_SYMBOL(paride_unregister);
 
 static int pi_register_parport(PIA * pi, int verbose)
 {
diff -puN drivers/block/paride/paride.h~paride-rename-pi_register-and-pi_unregister drivers/block/paride/paride.h
--- a/drivers/block/paride/paride.h~paride-rename-pi_register-and-pi_unregister
+++ a/drivers/block/paride/paride.h
@@ -163,8 +163,8 @@ struct pi_protocol {
 
 typedef struct pi_protocol PIP;
 
-extern int pi_register( PIP * );
-extern void pi_unregister ( PIP * );
+extern int paride_register( PIP * );
+extern void paride_unregister ( PIP * );
 
 #endif /* __DRIVERS_PARIDE_H__ */
 /* end of paride.h */
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-cpufreq.patch
git-ieee1394.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-isdn-trivial-vsnprintf-conversion.patch
drivers-video-use-kmemdup.patch

