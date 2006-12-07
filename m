From: akpm@osdl.org
Subject: - paride_register-shuffle-return-values.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:29 -0800
Message-ID: <200612072302.kB7N2T7u029857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51696 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163791AbWLGXCc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     paride_register(): shuffle return values
has been removed from the -mm tree.  Its filename was
     paride_register-shuffle-return-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paride_register(): shuffle return values
From: Alexey Dobriyan <adobriyan@gmail.com>

paride_register() returns 1 on success, 0 on failure and module init
code looks like

	static int __init foo_init(void)
	{
		return paride_register(&foo) - 1;
	}

which is not what one get used to. Converted to usual 0/-E convention.

In case of kbic driver, unwind registration. It was just

	return (paride_register(&k951)||paride_register(&k971))-1;

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/paride/aten.c   |    2 +-
 drivers/block/paride/bpck.c   |    2 +-
 drivers/block/paride/bpck6.c  |    2 +-
 drivers/block/paride/comm.c   |    2 +-
 drivers/block/paride/dstr.c   |    2 +-
 drivers/block/paride/epat.c   |    2 +-
 drivers/block/paride/epia.c   |    2 +-
 drivers/block/paride/fit2.c   |    2 +-
 drivers/block/paride/fit3.c   |    2 +-
 drivers/block/paride/friq.c   |    2 +-
 drivers/block/paride/frpw.c   |    2 +-
 drivers/block/paride/kbic.c   |   10 +++++++++-
 drivers/block/paride/ktti.c   |    2 +-
 drivers/block/paride/on20.c   |    2 +-
 drivers/block/paride/on26.c   |    2 +-
 drivers/block/paride/paride.c |    6 +++---
 16 files changed, 26 insertions(+), 18 deletions(-)

diff -puN drivers/block/paride/aten.c~paride_register-shuffle-return-values drivers/block/paride/aten.c
--- a/drivers/block/paride/aten.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/aten.c
@@ -149,7 +149,7 @@ static struct pi_protocol aten = {
 
 static int __init aten_init(void)
 {
-	return paride_register(&aten)-1;
+	return paride_register(&aten);
 }
 
 static void __exit aten_exit(void)
diff -puN drivers/block/paride/bpck.c~paride_register-shuffle-return-values drivers/block/paride/bpck.c
--- a/drivers/block/paride/bpck.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/bpck.c
@@ -464,7 +464,7 @@ static struct pi_protocol bpck = {
 
 static int __init bpck_init(void)
 {
-	return paride_register(&bpck)-1;
+	return paride_register(&bpck);
 }
 
 static void __exit bpck_exit(void)
diff -puN drivers/block/paride/bpck6.c~paride_register-shuffle-return-values drivers/block/paride/bpck6.c
--- a/drivers/block/paride/bpck6.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/bpck6.c
@@ -265,7 +265,7 @@ static int __init bpck6_init(void)
 	printk(KERN_INFO "bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. USA\n");
 	if(verbose)
 		printk(KERN_DEBUG "bpck6: verbose debug enabled.\n");
-	return paride_register(&bpck6) - 1;
+	return paride_register(&bpck6);
 }
 
 static void __exit bpck6_exit(void)
diff -puN drivers/block/paride/comm.c~paride_register-shuffle-return-values drivers/block/paride/comm.c
--- a/drivers/block/paride/comm.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/comm.c
@@ -205,7 +205,7 @@ static struct pi_protocol comm = {
 
 static int __init comm_init(void)
 {
-	return paride_register(&comm)-1;
+	return paride_register(&comm);
 }
 
 static void __exit comm_exit(void)
diff -puN drivers/block/paride/dstr.c~paride_register-shuffle-return-values drivers/block/paride/dstr.c
--- a/drivers/block/paride/dstr.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/dstr.c
@@ -220,7 +220,7 @@ static struct pi_protocol dstr = {
 
 static int __init dstr_init(void)
 {
-	return paride_register(&dstr)-1;
+	return paride_register(&dstr);
 }
 
 static void __exit dstr_exit(void)
diff -puN drivers/block/paride/epat.c~paride_register-shuffle-return-values drivers/block/paride/epat.c
--- a/drivers/block/paride/epat.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/epat.c
@@ -327,7 +327,7 @@ static int __init epat_init(void)
 #ifdef CONFIG_PARIDE_EPATC8
 	epatc8 = 1;
 #endif
-	return paride_register(&epat)-1;
+	return paride_register(&epat);
 }
 
 static void __exit epat_exit(void)
diff -puN drivers/block/paride/epia.c~paride_register-shuffle-return-values drivers/block/paride/epia.c
--- a/drivers/block/paride/epia.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/epia.c
@@ -303,7 +303,7 @@ static struct pi_protocol epia = {
 
 static int __init epia_init(void)
 {
-	return paride_register(&epia)-1;
+	return paride_register(&epia);
 }
 
 static void __exit epia_exit(void)
diff -puN drivers/block/paride/fit2.c~paride_register-shuffle-return-values drivers/block/paride/fit2.c
--- a/drivers/block/paride/fit2.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/fit2.c
@@ -138,7 +138,7 @@ static struct pi_protocol fit2 = {
 
 static int __init fit2_init(void)
 {
-	return paride_register(&fit2)-1;
+	return paride_register(&fit2);
 }
 
 static void __exit fit2_exit(void)
diff -puN drivers/block/paride/fit3.c~paride_register-shuffle-return-values drivers/block/paride/fit3.c
--- a/drivers/block/paride/fit3.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/fit3.c
@@ -198,7 +198,7 @@ static struct pi_protocol fit3 = {
 
 static int __init fit3_init(void)
 {
-	return paride_register(&fit3)-1;
+	return paride_register(&fit3);
 }
 
 static void __exit fit3_exit(void)
diff -puN drivers/block/paride/friq.c~paride_register-shuffle-return-values drivers/block/paride/friq.c
--- a/drivers/block/paride/friq.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/friq.c
@@ -263,7 +263,7 @@ static struct pi_protocol friq = {
 
 static int __init friq_init(void)
 {
-	return paride_register(&friq)-1;
+	return paride_register(&friq);
 }
 
 static void __exit friq_exit(void)
diff -puN drivers/block/paride/frpw.c~paride_register-shuffle-return-values drivers/block/paride/frpw.c
--- a/drivers/block/paride/frpw.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/frpw.c
@@ -300,7 +300,7 @@ static struct pi_protocol frpw = {
 
 static int __init frpw_init(void)
 {
-	return paride_register(&frpw)-1;
+	return paride_register(&frpw);
 }
 
 static void __exit frpw_exit(void)
diff -puN drivers/block/paride/kbic.c~paride_register-shuffle-return-values drivers/block/paride/kbic.c
--- a/drivers/block/paride/kbic.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/kbic.c
@@ -283,7 +283,15 @@ static struct pi_protocol k971 = {
 
 static int __init kbic_init(void)
 {
-	return (paride_register(&k951)||paride_register(&k971))-1;
+	int rv;
+
+	rv = paride_register(&k951);
+	if (rv < 0)
+		return rv;
+	rv = paride_register(&k971);
+	if (rv < 0)
+		paride_unregister(&k951);
+	return rv;
 }
 
 static void __exit kbic_exit(void)
diff -puN drivers/block/paride/ktti.c~paride_register-shuffle-return-values drivers/block/paride/ktti.c
--- a/drivers/block/paride/ktti.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/ktti.c
@@ -115,7 +115,7 @@ static struct pi_protocol ktti = {
 
 static int __init ktti_init(void)
 {
-	return paride_register(&ktti)-1;
+	return paride_register(&ktti);
 }
 
 static void __exit ktti_exit(void)
diff -puN drivers/block/paride/on20.c~paride_register-shuffle-return-values drivers/block/paride/on20.c
--- a/drivers/block/paride/on20.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/on20.c
@@ -140,7 +140,7 @@ static struct pi_protocol on20 = {
 
 static int __init on20_init(void)
 {
-	return paride_register(&on20)-1;
+	return paride_register(&on20);
 }
 
 static void __exit on20_exit(void)
diff -puN drivers/block/paride/on26.c~paride_register-shuffle-return-values drivers/block/paride/on26.c
--- a/drivers/block/paride/on26.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/on26.c
@@ -306,7 +306,7 @@ static struct pi_protocol on26 = {
 
 static int __init on26_init(void)
 {
-	return paride_register(&on26)-1;
+	return paride_register(&on26);
 }
 
 static void __exit on26_exit(void)
diff -puN drivers/block/paride/paride.c~paride_register-shuffle-return-values drivers/block/paride/paride.c
--- a/drivers/block/paride/paride.c~paride_register-shuffle-return-values
+++ a/drivers/block/paride/paride.c
@@ -237,19 +237,19 @@ int paride_register(PIP * pr)
 		if (protocols[k] && !strcmp(pr->name, protocols[k]->name)) {
 			printk("paride: %s protocol already registered\n",
 			       pr->name);
-			return 0;
+			return -1;
 		}
 	k = 0;
 	while ((k < MAX_PROTOS) && (protocols[k]))
 		k++;
 	if (k == MAX_PROTOS) {
 		printk("paride: protocol table full\n");
-		return 0;
+		return -1;
 	}
 	protocols[k] = pr;
 	pr->index = k;
 	printk("paride: %s registered as protocol %d\n", pr->name, k);
-	return 1;
+	return 0;
 }
 
 EXPORT_SYMBOL(paride_register);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-cpufreq.patch
git-ieee1394.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-isdn-trivial-vsnprintf-conversion.patch
drivers-video-use-kmemdup.patch

