From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch added to -mm tree
Date: Thu, 21 Jun 2012 13:51:47 -0700
Message-ID: <20120621205147.CE969A0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:39000 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760272Ab2FUUvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 16:51:50 -0400
Received: by lbbgp10 with SMTP id gp10so128454lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 13:51:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, agust@denx.de, andreas.dumberger@tqs.de, devendra.aaru@gmail.com


The patch titled
     Subject: drivers/rtc/rtc-r9701.c: check that r9701_set_datetime() succeeded
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/rtc/rtc-r9701.c: check that r9701_set_datetime() succeeded

When the driver detects that the clock time is invalid, it attempts to
write a sane time into the hardware.  We curently assume that everything
is OK is those writes succeeded.  But it is better to re-read the time
from the hardware to ensure that the new settings got there OK.

Cc: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Andreas Dumberger <andreas.dumberger@tqs.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded
+++ a/drivers/rtc/rtc-r9701.c
@@ -147,7 +147,8 @@ static int __devinit r9701_probe(struct 
 		dt.tm_mon  = 0;
 		dt.tm_year = 100;
 
-		if (r9701_set_datetime(&spi->dev, &dt)) {
+		if (r9701_set_datetime(&spi->dev, &dt) ||
+				r9701_get_datetime(&spi->dev, &dt)) {
 			dev_err(&spi->dev, "cannot repair RTC register\n");
 			return -ENODEV;
 		}
_
Subject: Subject: drivers/rtc/rtc-r9701.c: check that r9701_set_datetime() succeeded

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

