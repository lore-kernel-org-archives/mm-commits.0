From: akpm@linux-foundation.org
Subject: + rtc-max77686-add-maxim-77686-driver-fix.patch added to -mm tree
Date: Tue, 18 Dec 2012 16:30:29 -0800
Message-ID: <20121219003029.AC0C6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49224 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2LSAab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 19:30:31 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so192712qaq.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 16:30:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jonghwa3.lee@samsung.com, kyungmin.park@samsung.com, myungjoo.ham@samsung.com, woong.byun@samsung.com


The patch titled
     Subject: rtc-max77686-add-maxim-77686-driver-fix
has been added to the -mm tree.  Its filename is
     rtc-max77686-add-maxim-77686-driver-fix.patch

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
Subject: rtc-max77686-add-maxim-77686-driver-fix

remove inline, __devinit annotations

Cc: Chiwoong Byun <woong.byun@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Myugnjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-add-maxim-77686-driver-fix drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-add-maxim-77686-driver-fix
+++ a/drivers/rtc/rtc-max77686.c
@@ -129,7 +129,7 @@ static int max77686_rtc_tm_to_data(struc
 	return 0;
 }
 
-static inline int max77686_rtc_update(struct max77686_rtc_info *info,
+static int max77686_rtc_update(struct max77686_rtc_info *info,
 	enum MAX77686_RTC_OP op)
 {
 	int ret;
@@ -501,7 +501,7 @@ static struct regmap_config max77686_rtc
 	.val_bits = 8,
 };
 
-static int __devinit max77686_rtc_probe(struct platform_device *pdev)
+static int max77686_rtc_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *max77686 = dev_get_drvdata(pdev->dev.parent);
 	struct max77686_rtc_info *info;
@@ -575,7 +575,7 @@ out:
 	return ret;
 }
 
-static int __devexit max77686_rtc_remove(struct platform_device *pdev)
+static int max77686_rtc_remove(struct platform_device *pdev)
 {
 	struct max77686_rtc_info *info = platform_get_drvdata(pdev);
 
@@ -623,7 +623,7 @@ static struct platform_driver max77686_r
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max77686_rtc_probe,
-	.remove		= __devexit_p(max77686_rtc_remove),
+	.remove		= max77686_rtc_remove,
 	.shutdown	= max77686_rtc_shutdown,
 	.id_table	= rtc_id,
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
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
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

