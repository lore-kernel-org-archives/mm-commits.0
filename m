From: akpm@linux-foundation.org
Subject: [folded] drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:25:37 -0700
Message-ID: <20120730212537.980AE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:38687 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3VZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:25:39 -0400
Received: by obbwc20 with SMTP id wc20so4009427obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:25:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, linus.walleij@linaro.org, ramesh.chandrasekaran@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-rtc-rtc-ab8500c-use-uie-emulation.patch

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
@@ -225,7 +225,7 @@ static int ab8500_rtc_set_alarm(struct d
 {
 	int retval, i;
 	unsigned char buf[ARRAY_SIZE(ab8500_rtc_alarm_regs)];
-	unsigned long mins, secs = 0, cursec=0;
+	unsigned long mins, secs = 0, cursec = 0;
 	struct rtc_time curtm;
 
 	if (alarm->time.tm_year < (AB8500_RTC_EPOCH - 1900)) {
@@ -244,7 +244,7 @@ static int ab8500_rtc_set_alarm(struct d
 	 */
 	ab8500_rtc_read_time(dev, &curtm); /* Read current time */
 	rtc_tm_to_time(&curtm, &cursec);
-	if ((secs - cursec) < 59 ){
+	if ((secs - cursec) < 59) {
 		dev_dbg(dev, "Alarm less than 1 minute not supported\r\n");
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
minixfs-fix-block-limit-check-fix.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch

