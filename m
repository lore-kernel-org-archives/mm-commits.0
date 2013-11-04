From: akpm@linux-foundation.org
Subject: +
 kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix.patch added to
 -mm tree
Date: Mon, 04 Nov 2013 12:20:11 -0800
Message-ID: <5278017b.k49NbXFmgQksdg5S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3KDUUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 15:20:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dyoung@redhat.com

Subject: + kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix.patch added to -mm tree
To: dyoung@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 12:20:11 -0800


The patch titled
     Subject: kernel/printk/printk.c: boot_delay return value fix
has been added to the -mm tree.  Its filename is
     kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix.patch

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
kernel-printk-printkc-enable-boot-delay-for-earlyprintk-fix.patch

