From: akpm@osdl.org
Subject: - drivers-isdn-trivial-vsnprintf-conversion.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:48 -0800
Message-ID: <200612082010.kB8KAmPH002851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58956 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946513AbWLHUK7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@redhat.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/*: trivial vsnprintf() conversion
has been removed from the -mm tree.  Its filename was
     drivers-isdn-trivial-vsnprintf-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/isdn/*: trivial vsnprintf() conversion
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hardware/eicon/divasmain.c |    2 +-
 drivers/isdn/hisax/hisax_isac.c         |    2 +-
 drivers/isdn/hisax/st5481_d.c           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/isdn/hardware/eicon/divasmain.c~drivers-isdn-trivial-vsnprintf-conversion drivers/isdn/hardware/eicon/divasmain.c
--- a/drivers/isdn/hardware/eicon/divasmain.c~drivers-isdn-trivial-vsnprintf-conversion
+++ a/drivers/isdn/hardware/eicon/divasmain.c
@@ -185,7 +185,7 @@ void diva_log_info(unsigned char *format
 	unsigned char line[160];
 
 	va_start(args, format);
-	vsprintf(line, format, args);
+	vsnprintf(line, sizeof(line), format, args);
 	va_end(args);
 
 	printk(KERN_INFO "%s: %s\n", DRIVERLNAME, line);
diff -puN drivers/isdn/hisax/hisax_isac.c~drivers-isdn-trivial-vsnprintf-conversion drivers/isdn/hisax/hisax_isac.c
--- a/drivers/isdn/hisax/hisax_isac.c~drivers-isdn-trivial-vsnprintf-conversion
+++ a/drivers/isdn/hisax/hisax_isac.c
@@ -433,7 +433,7 @@ static void l1m_debug(struct FsmInst *fi
 	char buf[256];
 	
 	va_start(args, fmt);
-	vsprintf(buf, fmt, args);
+	vsnprintf(buf, sizeof(buf), fmt, args);
 	DBG(DBG_L1M, "%s", buf);
 	va_end(args);
 }
diff -puN drivers/isdn/hisax/st5481_d.c~drivers-isdn-trivial-vsnprintf-conversion drivers/isdn/hisax/st5481_d.c
--- a/drivers/isdn/hisax/st5481_d.c~drivers-isdn-trivial-vsnprintf-conversion
+++ a/drivers/isdn/hisax/st5481_d.c
@@ -173,7 +173,7 @@ static void l1m_debug(struct FsmInst *fi
 	char buf[256];
 	
 	va_start(args, fmt);
-	vsprintf(buf, fmt, args);
+	vsnprintf(buf, sizeof(buf), fmt, args);
 	DBG(8, "%s", buf);
 	va_end(args);
 }
@@ -275,7 +275,7 @@ static void dout_debug(struct FsmInst *f
 	char buf[256];
 	
 	va_start(args, fmt);
-	vsprintf(buf, fmt, args);
+	vsnprintf(buf, sizeof(buf), fmt, args);
 	DBG(0x2, "%s", buf);
 	va_end(args);
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
drivers-isdn-trivial-vsnprintf-conversion.patch
drivers-video-use-kmemdup.patch
git-cpufreq.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch

