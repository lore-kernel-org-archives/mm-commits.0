From: akpm@linux-foundation.org
Subject: + use-printk_once-in-several-places.patch added to -mm tree
Date: Tue, 26 May 2009 13:38:23 -0700
Message-ID: <200905262038.n4QKcNbj017783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbZEZUjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 16:39:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, davem@davemloft.net, kosaki.motohiro@jp.fujitsu.com, linux@dominikbrodowski.net, mingo@elte.hu


The patch titled
     use printk_once() in several places
has been added to the -mm tree.  Its filename is
     use-printk_once-in-several-places.patch

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

 arch/x86/kernel/cpu/common.c  |    8 ++------
 drivers/net/3c515.c           |    7 ++-----
 drivers/pcmcia/pcmcia_ioctl.c |    9 +++------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff -puN arch/x86/kernel/cpu/common.c~use-printk_once-in-several-places arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~use-printk_once-in-several-places
+++ a/arch/x86/kernel/cpu/common.c
@@ -503,13 +503,9 @@ static void __cpuinit get_cpu_vendor(str
 		}
 	}
 
-	if (!printed) {
-		printed++;
-		printk(KERN_ERR
+	printk_once(KERN_ERR
 		    "CPU: vendor_id '%s' unknown, using generic init.\n", v);
-
-		printk(KERN_ERR "CPU: Your system may be unstable.\n");
-	}
+	printk_once(KERN_ERR "CPU: Your system may be unstable.\n");
 
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	this_cpu = &default_cpu;
diff -puN drivers/net/3c515.c~use-printk_once-in-several-places drivers/net/3c515.c
--- a/drivers/net/3c515.c~use-printk_once-in-several-places
+++ a/drivers/net/3c515.c
@@ -430,15 +430,12 @@ int init_module(void)
 struct net_device *tc515_probe(int unit)
 {
 	struct net_device *dev = corkscrew_scan(unit);
-	static int printed;
 
 	if (!dev)
 		return ERR_PTR(-ENODEV);
 
-	if (corkscrew_debug > 0 && !printed) {
-		printed = 1;
-		printk(version);
-	}
+	if (corkscrew_debug > 0)
+		printk_once(version);
 
 	return dev;
 }
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

linux-next.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
vmscan-prevent-shrinking-of-active-anon-lru-list-in-case-of-no-swap-space-v3.patch
use-printk_once-in-several-places.patch

