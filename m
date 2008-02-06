From: akpm@linux-foundation.org
Subject: - page-owner-tracking-leak-detector-broken-on-s390.patch removed from -mm tree
Date: Wed, 06 Feb 2008 00:25:02 -0800
Message-ID: <200802060824.m168Ohfg001203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761AbYBFIYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 03:24:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     page-owner-tracking-leak-detector-broken-on-s390
has been removed from the -mm tree.  Its filename was
     page-owner-tracking-leak-detector-broken-on-s390.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-owner-tracking-leak-detector-broken-on-s390
From: Andrew Morton <akpm@linux-foundation.org>

This debug patch expands the size of struct page and causes this, in vmem.c:


	BUILD_BUG_ON((unsigned long)VMEM_MAP + VMEM_MAP_SIZE > VMEM_MAP_MAX);

to go boom.

This shouldn't happen - there are quite a few debug patches around the place
which add things to the pageframe.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 vmstat.c          |    0 
 2 files changed, 1 insertion(+)

diff -puN Documentation/page_owner.c~page-owner-tracking-leak-detector-broken-on-s390 Documentation/page_owner.c
diff -puN fs/proc/proc_misc.c~page-owner-tracking-leak-detector-broken-on-s390 fs/proc/proc_misc.c
diff -puN include/linux/mm_types.h~page-owner-tracking-leak-detector-broken-on-s390 include/linux/mm_types.h
diff -puN lib/Kconfig.debug~page-owner-tracking-leak-detector-broken-on-s390 lib/Kconfig.debug
--- a/lib/Kconfig.debug~page-owner-tracking-leak-detector-broken-on-s390
+++ a/lib/Kconfig.debug
@@ -58,6 +58,7 @@ config UNUSED_SYMBOLS
 config PAGE_OWNER
 	bool "Track page owner"
 	depends on DEBUG_KERNEL
+	depends on !S390
 	help
 	  This keeps track of what call chain is the owner of a page, may
 	  help to find bare alloc_page(s) leaks. Eats a fair amount of memory.
diff -puN mm/page_alloc.c~page-owner-tracking-leak-detector-broken-on-s390 mm/page_alloc.c
diff -puN mm/vmstat.c~page-owner-tracking-leak-detector-broken-on-s390 mm/vmstat.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
remove-support-for-un-needed-_extratext-section.patch
allow-auto-destruction-of-loop-devices.patch
read_current_time-cleanups.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
kallsyms-should-prefer-non-weak-symbols.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
stopmachine-semaphore-to-mutex.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec.patch
system-timer-fix-crash-in-100hz-system-timer.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
rtc-ds1302-rtc-support.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
fbmon-cleanup-trailing-whitespaces.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init.patch
isapnp-driver-semaphore-to-mutex.patch
ext3-fix-lock-inversion-in-direct-io.patch
