From: akpm@linux-foundation.org
Subject: + rtc-pcf8523-add-low-battery-voltage-support-fix.patch added to -mm tree
Date: Wed, 19 Dec 2012 14:04:27 -0800
Message-ID: <20121219220428.90A6E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:40204 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2LSWEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 17:04:31 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so136772wib.5
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 14:04:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jesper.nilsson@axis.com, thierry.reding@avionic-design.de


The patch titled
     Subject: rtc-pcf8523-add-low-battery-voltage-support-fix
has been added to the -mm tree.  Its filename is
     rtc-pcf8523-add-low-battery-voltage-support-fix.patch

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
Subject: rtc-pcf8523-add-low-battery-voltage-support-fix

omit pcf8563_rtc_ioctl() if CONFIG_RTC_INTF_DEV=n

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8523.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/rtc/rtc-pcf8523.c~rtc-pcf8523-add-low-battery-voltage-support-fix drivers/rtc/rtc-pcf8523.c
--- a/drivers/rtc/rtc-pcf8523.c~rtc-pcf8523-add-low-battery-voltage-support-fix
+++ a/drivers/rtc/rtc-pcf8523.c
@@ -251,6 +251,7 @@ static int pcf8523_rtc_set_time(struct d
 	return pcf8523_start_rtc(client);
 }
 
+#ifdef CONFIG_RTC_INTF_DEV
 static int pcf8523_rtc_ioctl(struct device *dev, unsigned int cmd,
 			     unsigned long arg)
 {
@@ -275,6 +276,9 @@ static int pcf8523_rtc_ioctl(struct devi
 		return -ENOIOCTLCMD;
 	}
 }
+#else
+#define pcf8523_rtc_ioctl NULL
+#endif
 
 static const struct rtc_class_ops pcf8523_rtc_ops = {
 	.read_time = pcf8523_rtc_read_time,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sendfile-allows-bypassing-of-notifier-events.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

