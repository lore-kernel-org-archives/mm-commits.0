From: akpm@linux-foundation.org
Subject: + w1-w1_master_ds1wm-should-depend-on-generic_hardirqs.patch added to -mm tree
Date: Tue, 07 Jun 2011 16:16:52 -0700
Message-ID: <201106072316.p57NGqCp001022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757931Ab1FGXRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 19:17:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dagenaisj@sonatest.com, johnpol@2ka.mipt.ru, mreimer@vpop.net


The patch titled
     w1: W1_MASTER_DS1WM should depend on GENERIC_HARDIRQS
has been added to the -mm tree.  Its filename is
     w1-w1_master_ds1wm-should-depend-on-generic_hardirqs.patch

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
Subject: w1: W1_MASTER_DS1WM should depend on GENERIC_HARDIRQS
From: Geert Uytterhoeven <geert@linux-m68k.org>

On m68k (which doesn't support generic hardirqs yet):

drivers/w1/masters/ds1wm.c: In function `ds1wm_probe':
drivers/w1/masters/ds1wm.c: error: implicit declaration of function `irq_set_irq_type'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Jean-Franois Dagenais <dagenaisj@sonatest.com>
Cc: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/masters/Kconfig~w1-w1_master_ds1wm-should-depend-on-generic_hardirqs drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig~w1-w1_master_ds1wm-should-depend-on-generic_hardirqs
+++ a/drivers/w1/masters/Kconfig
@@ -42,7 +42,7 @@ config W1_MASTER_MXC
 
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
-	depends on W1
+	depends on W1 && GENERIC_HARDIRQS
 	help
 	  Say Y here to enable the DS1WM 1-wire driver, such as that
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
_

Patches currently in -mm which might be from geert@linux-m68k.org are

w1-w1_master_ds1wm-should-depend-on-generic_hardirqs.patch
mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch

