From: akpm@linux-foundation.org
Subject: + staging-iio-make-iio-depend-on-generic_hardirqs.patch added to -mm tree
Date: Tue, 07 Jun 2011 16:17:34 -0700
Message-ID: <201106072317.p57NHY9D001056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab1FGXRp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 19:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, gregkh@suse.de, jeffm@suse.com, jic23@cam.ac.uk


The patch titled
     staging/iio: make IIO depend on GENERIC_HARDIRQS
has been added to the -mm tree.  Its filename is
     staging-iio-make-iio-depend-on-generic_hardirqs.patch

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
Subject: staging/iio: make IIO depend on GENERIC_HARDIRQS
From: Geert Uytterhoeven <geert@linux-m68k.org>

On m68k (which doesn't support generic hardirqs yet):

drivers/staging/iio/industrialio-trigger.c: In function `iio_trigger_poll':
drivers/staging/iio/industrialio-trigger.c:180: error: implicit declaration of function `generic_handle_irq'
drivers/staging/iio/industrialio-trigger.c: In function `iio_trigger_poll_chained':
drivers/staging/iio/industrialio-trigger.c:200: error: implicit declaration of function `handle_nested_irq'
drivers/staging/iio/industrialio-trigger.c: In function `iio_trig_release':
drivers/staging/iio/industrialio-trigger.c:379: error: implicit declaration of function `irq_modify_status'
drivers/staging/iio/industrialio-trigger.c:382: error: implicit declaration of function `irq_set_chip'
drivers/staging/iio/industrialio-trigger.c:384: error: implicit declaration of function `irq_set_handler'
drivers/staging/iio/industrialio-trigger.c:388: error: implicit declaration of function `irq_free_descs'
drivers/staging/iio/industrialio-trigger.c: In function `iio_trig_subirqmask':
drivers/staging/iio/industrialio-trigger.c:402: error: implicit declaration of function `irq_data_get_irq_chip'
drivers/staging/iio/industrialio-trigger.c:402: warning: initialization makes pointer from integer without a cast
drivers/staging/iio/industrialio-trigger.c: In function `iio_trig_subirqunmask':
drivers/staging/iio/industrialio-trigger.c:411: warning: initialization makes pointer from integer without a cast
drivers/staging/iio/industrialio-trigger.c: In function `iio_allocate_trigger':
drivers/staging/iio/industrialio-trigger.c:432: error: implicit declaration of function `irq_alloc_descs'
drivers/staging/iio/industrialio-trigger.c:455: error: `handle_simple_irq' undeclared (first use in this function)
drivers/staging/iio/industrialio-trigger.c:455: error: (Each undeclared identifier is reported only once
drivers/staging/iio/industrialio-trigger.c:455: error: for each function it appears in.)

Hence IIO_TRIGGER should depend on GENERIC_HARDIRQS.  But as IIO_TRIGGER
and IIO_RING_BUFFER form a maze of dependencies and selects, just make the
whole IIO subsystem depend on GENERIC_HARDIRQS.

This dependency also covers !S390, so that one can be removed again.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/iio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/iio/Kconfig~staging-iio-make-iio-depend-on-generic_hardirqs drivers/staging/iio/Kconfig
--- a/drivers/staging/iio/Kconfig~staging-iio-make-iio-depend-on-generic_hardirqs
+++ a/drivers/staging/iio/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig IIO
 	tristate "Industrial I/O support"
-	depends on !S390
+	depends on GENERIC_HARDIRQS
 	help
 	  The industrial I/O subsystem provides a unified framework for
 	  drivers for many different types of embedded sensors using a
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
staging-iio-make-iio-depend-on-generic_hardirqs.patch

