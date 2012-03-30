From: akpm@linux-foundation.org
Subject: + leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch added to -mm tree
Date: Fri, 30 Mar 2012 11:42:11 -0700
Message-ID: <20120330184211.4A0CEA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:57445 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab2C3SmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Mar 2012 14:42:12 -0400
Received: by vcbfk26 with SMTP id fk26so95847vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Mar 2012 11:42:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, axel.lin@gmail.com, daniel.jeong@ti.com, gshark.jeong@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch

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
Subject: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes

WARNING: please write a paragraph that describes the config symbol fully
#31: FILE: drivers/leds/Kconfig:397:
+config LEDS_LM3556

ERROR: "foo * bar" should be "foo *bar"
#201: FILE: drivers/leds/leds-lm3556.c:143:
+int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * val)

WARNING: simple_strtoul is obsolete, use kstrtoul instead
#380: FILE: drivers/leds/leds-lm3556.c:322:
+	unsigned long state = simple_strtoul(buf, &after, 10);

total: 1 errors, 2 warnings, 727 lines checked

./patches/leds-add-led-driver-for-lm3556-chip.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Cc: Axel Lin <axel.lin@gmail.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>
Cc: Geon Si Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3556.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-checkpatch-fixes drivers/leds/leds-lm3556.c
--- a/drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
+++ a/drivers/leds/leds-lm3556.c
@@ -141,7 +141,7 @@ static struct indicator indicator_patter
 };
 
 /* i2c access*/
-int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * val)
+int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 *val)
 {
 	int ret;
 	struct lm3556_chip_data *chip = i2c_get_clientdata(client);
@@ -317,12 +317,15 @@ static ssize_t lm3556_indicator_pattern_
 					      const char *buf, size_t size)
 {
 	char *after;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
 	struct i2c_client *client = container_of(dev->parent,
 						 struct i2c_client, dev);
-	unsigned long state = simple_strtoul(buf, &after, 10);
+	unsigned long state;
 	size_t count = after - buf;
 
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		goto out;
 	if (isspace(*after))
 		count++;
 
@@ -336,6 +339,7 @@ static ssize_t lm3556_indicator_pattern_
 		lm3556_write_reg(client, REG_INDIC_PERIOD,
 				 indicator_pattern[state].period_cnt);
 	}
+out:
 	return ret;
 }
 
_
Subject: Subject: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-2.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

