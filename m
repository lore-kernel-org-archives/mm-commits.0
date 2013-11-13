From: akpm@linux-foundation.org
Subject: [merged]
 kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:40:20 -0800
Message-ID: <5283e3b4.Fhwwp9KI59CP1QW6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3KMUkV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dyoung@redhat.com

Subject: [merged] kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch removed from -mm tree
To: dyoung@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:20 -0800


The patch titled
     Subject: kernel/printk/printk.c: enable boot delay for earlyprintk
has been removed from the -mm tree.  Its filename was
     kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: kernel/printk/printk.c: enable boot delay for earlyprintk

boot_delay does not work for earlyprintk because the kernel cmdline
parsing is late.

Change to use early_param so early kernel messages can also be delayed.

Signed-off-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk/printk.c~kernel-printk-printkc-enable-boot-delay-for-earlyprintk kernel/printk/printk.c
--- a/kernel/printk/printk.c~kernel-printk-printkc-enable-boot-delay-for-earlyprintk
+++ a/kernel/printk/printk.c
@@ -820,9 +820,9 @@ static int __init boot_delay_setup(char
 	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
 		"HZ: %d, loops_per_msec: %llu\n",
 		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
-	return 1;
+	return 0;
 }
-__setup("boot_delay=", boot_delay_setup);
+early_param("boot_delay", boot_delay_setup);
 
 static void boot_delay_msec(int level)
 {
_

Patches currently in -mm which might be from dyoung@redhat.com are

origin.patch
kexec-migrate-to-reboot-cpu.patch

