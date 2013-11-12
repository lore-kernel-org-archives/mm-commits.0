From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix.patch removed
 from -mm tree
Date: Tue, 12 Nov 2013 14:37:32 -0800
Message-ID: <5282adac.V8EuRAXbpKVDweq6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab3KLWhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:37:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dyoung@redhat.com

Subject: [folded-merged] kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix.patch removed from -mm tree
To: dyoung@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:37:32 -0800


The patch titled
     Subject: kernel/printk/printk.c: boot_delay return value fix
has been removed from the -mm tree.  Its filename was
     kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix.patch

This patch was dropped because it was folded into kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: kernel/printk/printk.c: boot_delay return value fix

Kernel report "Malformed early option boot_delay" because it returns
non-zero value.  Move to 'return 0' now because there's no reason it
should return 1.

Signed-off-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix kernel/printk/printk.c
--- a/kernel/printk/printk.c~kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix
+++ a/kernel/printk/printk.c
@@ -820,7 +820,7 @@ static int __init boot_delay_setup(char
 	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
 		"HZ: %d, loops_per_msec: %llu\n",
 		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
-	return 1;
+	return 0;
 }
 early_param("boot_delay", boot_delay_setup);
 
_

Patches currently in -mm which might be from dyoung@redhat.com are

kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch

