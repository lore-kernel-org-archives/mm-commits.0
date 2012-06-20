From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch added to -mm tree
Date: Wed, 20 Jun 2012 15:53:40 -0700
Message-ID: <20120620225341.1B34CA01BD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61959 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2FTWxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 18:53:42 -0400
Received: by vbnl22 with SMTP id l22so336vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 15:53:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, linus.walleij@linaro.org, ramesh.chandrasekaran@stericsson.com


The patch titled
     Subject: drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch

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
Subject: drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes

ERROR: spaces required around that '=' (ctx:VxV)
#36: FILE: drivers/rtc/rtc-ab8500.c:227:
+	unsigned long mins, secs = 0, cursec=0;
 	                                    ^

ERROR: space required before the open brace '{'
#51: FILE: drivers/rtc/rtc-ab8500.c:246:
+	if ((secs - cursec) < 59 ){

ERROR: space prohibited before that close parenthesis ')'
#51: FILE: drivers/rtc/rtc-ab8500.c:246:
+	if ((secs - cursec) < 59 ){

total: 3 errors, 0 warnings, 34 lines checked

./patches/drivers-rtc-rtc-ab8500c-use-uie-emulation.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Ramesh Chandrasekaran <ramesh.chandrasekaran@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes
+++ a/drivers/rtc/rtc-ab8500.c
@@ -224,7 +224,7 @@ static int ab8500_rtc_set_alarm(struct d
 {
 	int retval, i;
 	unsigned char buf[ARRAY_SIZE(ab8500_rtc_alarm_regs)];
-	unsigned long mins, secs = 0, cursec=0;
+	unsigned long mins, secs = 0, cursec = 0;
 	struct rtc_time curtm;
 
 	if (alarm->time.tm_year < (AB8500_RTC_EPOCH - 1900)) {
@@ -243,7 +243,7 @@ static int ab8500_rtc_set_alarm(struct d
 	 */
 	ab8500_rtc_read_time(dev, &curtm); /* Read current time */
 	rtc_tm_to_time(&curtm, &cursec);
-	if ((secs - cursec) < 59 ){
+	if ((secs - cursec) < 59) {
 		dev_dbg(dev, "Alarm less than 1 minute not supported\r\n");
 		return -EINVAL;
 	}
_
Subject: Subject: drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
backlight-l4f00242t03-use-devm_gpio_request_one-fix.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

