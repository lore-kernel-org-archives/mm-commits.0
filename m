From: akpm@linux-foundation.org
Subject: + kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch
 added to -mm tree
Date: Thu, 31 Oct 2013 14:24:24 -0700
Message-ID: <5272ca88.BKzpLtvuGEbgMWu7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3JaVYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 17:24:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dyoung@redhat.com

Subject: + kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch added to -mm tree
To: dyoung@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 14:24:24 -0700


The patch titled
     Subject: kernel/printk/printk.c: enable boot delay for earlyprintk
has been added to the -mm tree.  Its filename is
     kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: kernel/printk/printk.c: enable boot delay for earlyprintk

boot_delay does not work for earlyprintk because the kernel cmdline
parsing is late.

Change to use early_param so early kernel messages can also be delayed.

Signed-off-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~kernel-printk-printkc-enable-boot-delay-for-earlyprintk kernel/printk/printk.c
--- a/kernel/printk/printk.c~kernel-printk-printkc-enable-boot-delay-for-earlyprintk
+++ a/kernel/printk/printk.c
@@ -822,7 +822,7 @@ static int __init boot_delay_setup(char
 		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
 	return 1;
 }
-__setup("boot_delay=", boot_delay_setup);
+early_param("boot_delay", boot_delay_setup);
 
 static void boot_delay_msec(int level)
 {
_

Patches currently in -mm which might be from dyoung@redhat.com are

kernel-printk-printkc-enable-boot-delay-for-earlyprintk.patch

