From: akpm@linux-foundation.org
Subject: +
 tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch added
 to -mm tree
Date: Tue, 29 Oct 2013 13:15:14 -0700
Message-ID: <52701752.qTf3fzuGJAfH0Hoy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3J2UPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Oct 2013 16:15:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wsa@the-dreams.de, akpm@linux-foundation.org

Subject: + tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch added to -mm tree
To: akpm@linux-foundation.org,wsa@the-dreams.de
From: akpm@linux-foundation.org
Date: Tue, 29 Oct 2013 13:15:14 -0700


The patch titled
     Subject: tree-wide-use-reinit_completion-instead-of-init_completion-fix
has been added to the -mm tree.  Its filename is
     tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch

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
Subject: tree-wide-use-reinit_completion-instead-of-init_completion-fix

Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/mic/card/mic_virtio.c |    2 +-
 drivers/misc/mic/host/mic_boot.c   |    2 +-
 drivers/spi/spi.c                  |    2 +-
 sound/firewire/dice.c              |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/misc/mic/card/mic_virtio.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix drivers/misc/mic/card/mic_virtio.c
--- a/drivers/misc/mic/card/mic_virtio.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix
+++ a/drivers/misc/mic/card/mic_virtio.c
@@ -493,7 +493,7 @@ static int mic_remove_device(struct mic_
 			ioread8(&dc->config_change), ioread8(&d->type), mvdev);
 
 		status = ioread8(&d->status);
-		INIT_COMPLETION(mvdev->reset_done);
+		reinit_completion(&mvdev->reset_done);
 		unregister_virtio_device(&mvdev->vdev);
 		mic_free_card_irq(mvdev->virtio_cookie, mvdev);
 		if (status & VIRTIO_CONFIG_S_DRIVER_OK)
diff -puN drivers/misc/mic/host/mic_boot.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix drivers/misc/mic/host/mic_boot.c
--- a/drivers/misc/mic/host/mic_boot.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix
+++ a/drivers/misc/mic/host/mic_boot.c
@@ -37,7 +37,7 @@ static void mic_reset(struct mic_device
 
 #define MIC_RESET_TO (45)
 
-	INIT_COMPLETION(mdev->reset_wait);
+	reinit_completion(&mdev->reset_wait);
 	mdev->ops->reset_fw_ready(mdev);
 	mdev->ops->reset(mdev);
 
diff -puN drivers/spi/spi.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix drivers/spi/spi.c
--- a/drivers/spi/spi.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix
+++ a/drivers/spi/spi.c
@@ -571,7 +571,7 @@ static int spi_transfer_one_message(stru
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		trace_spi_transfer_start(msg, xfer);
 
-		INIT_COMPLETION(master->xfer_completion);
+		reinit_completion(&master->xfer_completion);
 
 		ret = master->transfer_one(master, msg->spi, xfer);
 		if (ret < 0) {
diff -puN sound/firewire/dice.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix sound/firewire/dice.c
--- a/sound/firewire/dice.c~tree-wide-use-reinit_completion-instead-of-init_completion-fix
+++ a/sound/firewire/dice.c
@@ -543,7 +543,7 @@ static int dice_change_rate(struct dice
 	__be32 value;
 	int err;
 
-	INIT_COMPLETION(dice->clock_accepted);
+	reinit_completion(&dice->clock_accepted);
 
 	value = cpu_to_be32(clock_rate | CLOCK_SOURCE_ARX1);
 	err = snd_fw_transaction(dice->unit, TCODE_WRITE_QUADLET_REQUEST,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

