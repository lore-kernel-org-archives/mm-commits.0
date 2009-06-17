From: akpm@linux-foundation.org
Subject: [merged] use-printk_once-in-several-places.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:33 -0700
Message-ID: <200906171837.n5HIbX7J003624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936AbZFQSxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, davem@davemloft.net, kosaki.motohiro@jp.fujitsu.com, linux@dominikbrodowski.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     use printk_once() in several places
has been removed from the -mm tree.  Its filename was
     use-printk_once-in-several-places.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use printk_once() in several places
From: Minchan Kim <minchan.kim@gmail.com>

There are some places to be able to use printk_once instead of hard coding.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common.c  |   11 +++--------
 drivers/pcmcia/pcmcia_ioctl.c |    9 +++------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/cpu/common.c~use-printk_once-in-several-places arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~use-printk_once-in-several-places
+++ a/arch/x86/kernel/cpu/common.c
@@ -487,7 +487,6 @@ out:
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
-	static int printed;
 	int i;
 
 	for (i = 0; i < X86_VENDOR_NUM; i++) {
@@ -504,13 +503,9 @@ static void __cpuinit get_cpu_vendor(str
 		}
 	}
 
-	if (!printed) {
-		printed++;
-		printk(KERN_ERR
-		    "CPU: vendor_id '%s' unknown, using generic init.\n", v);
-
-		printk(KERN_ERR "CPU: Your system may be unstable.\n");
-	}
+	printk_once(KERN_ERR
+			"CPU: vendor_id '%s' unknown, using generic init.\n" \
+			"CPU: Your system may be unstable.\n", v);
 
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	this_cpu = &default_cpu;
diff -puN drivers/pcmcia/pcmcia_ioctl.c~use-printk_once-in-several-places drivers/pcmcia/pcmcia_ioctl.c
--- a/drivers/pcmcia/pcmcia_ioctl.c~use-printk_once-in-several-places
+++ a/drivers/pcmcia/pcmcia_ioctl.c
@@ -915,12 +915,9 @@ static int ds_ioctl(struct inode * inode
 		err = -EPERM;
 		goto free_out;
 	} else {
-		static int printed = 0;
-		if (!printed) {
-			printk(KERN_WARNING "2.6. kernels use pcmciamtd instead of memory_cs.c and do not require special\n");
-			printk(KERN_WARNING "MTD handling any more.\n");
-			printed++;
-		}
+			printk_once(KERN_WARNING
+				"2.6. kernels use pcmciamtd instead of memory_cs.c and do not require special\n");
+			printk_once(KERN_WARNING "MTD handling any more.\n");
 	}
 	err = -EINVAL;
 	goto free_out;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
memcg-fix-lru-rotation-in-isolate_pages.patch

