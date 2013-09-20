From: akpm@linux-foundation.org
Subject: +
 drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit.patch added to
 -mm tree
Date: Fri, 20 Sep 2013 15:31:35 -0700
Message-ID: <523cccc7.Az4x0QYaHESju0Wd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3ITWbg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 18:31:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmoyer@redhat.com, axboe@kernel.dk, abhansali@stec-inc.com, akpm@linux-foundation.org

Subject: + drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit.patch added to -mm tree
To: akpm@linux-foundation.org,abhansali@stec-inc.com,axboe@kernel.dk,jmoyer@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 15:31:35 -0700


The patch titled
     Subject: drivers/block/skd_main.c: fix a few things, disable on 32-bit
has been added to the -mm tree.  Its filename is
     drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit.patch

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
Subject: drivers/block/skd_main.c: fix a few things, disable on 32-bit

Fix these (i386 allmodconfig):

drivers/block/skd_main.c:4559: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
drivers/block/skd_main.c:4614: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
drivers/block/skd_main.c:4614: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'unsigned int'
drivers/block/skd_main.c:4626: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
drivers/block/skd_main.c:4626: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'unsigned int'
drivers/block/skd_main.c:4671: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
drivers/block/skd_main.c:4671: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'unsigned int'

And what remains is these:

drivers/block/skd_main.c: In function 'skd_reg_write64':
drivers/block/skd_main.c:439: error: implicit declaration of function 'writeq'
drivers/block/skd_main.c:441: error: implicit declaration of function 'readq'
drivers/block/skd_main.c: In function 'skd_cons_skmsg':
drivers/block/skd_main.c:4589: warning: cast from pointer to integer of different size
drivers/block/skd_main.c:4592: warning: cast from pointer to integer of different size
drivers/block/skd_main.c:4593: warning: cast to pointer from integer of different size

Which is more than I'm prepared to address, so just disable the driver on
32-bit builds.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig    |    1 +
 drivers/block/skd_main.c |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/block/skd_main.c~drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit drivers/block/skd_main.c
--- a/drivers/block/skd_main.c~drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit
+++ a/drivers/block/skd_main.c
@@ -4556,7 +4556,7 @@ static int skd_cons_skmsg(struct skd_dev
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skmsg_table kzalloc, struct %lu, count %u total %lu\n",
+	VPRINTK(skdev, "skmsg_table kzalloc, struct %u, count %u total %lu\n",
 		sizeof(struct skd_fitmsg_context),
 		skdev->num_fitmsg_context,
 		(unsigned long) sizeof(struct skd_fitmsg_context) *
@@ -4611,7 +4611,7 @@ static int skd_cons_skreq(struct skd_dev
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skreq_table kzalloc, struct %lu, count %u total %lu\n",
+	VPRINTK(skdev, "skreq_table kzalloc, struct %u, count %u total %u\n",
 		sizeof(struct skd_request_context),
 		skdev->num_req_context,
 		sizeof(struct skd_request_context) * skdev->num_req_context);
@@ -4623,7 +4623,7 @@ static int skd_cons_skreq(struct skd_dev
 		goto err_out;
 	}
 
-	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %lu total %lu\n",
+	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %u total %u\n",
 		skdev->sgs_per_request, sizeof(struct scatterlist),
 		skdev->sgs_per_request * sizeof(struct scatterlist));
 
@@ -4668,7 +4668,7 @@ static int skd_cons_skspcl(struct skd_de
 	int rc = 0;
 	u32 i, nbytes;
 
-	VPRINTK(skdev, "skspcl_table kzalloc, struct %lu, count %u total %lu\n",
+	VPRINTK(skdev, "skspcl_table kzalloc, struct %u, count %u total %u\n",
 		sizeof(struct skd_special_context),
 		skdev->n_special,
 		sizeof(struct skd_special_context) * skdev->n_special);
diff -puN drivers/block/Kconfig~drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit drivers/block/Kconfig
--- a/drivers/block/Kconfig~drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit
+++ a/drivers/block/Kconfig
@@ -319,6 +319,7 @@ config BLK_DEV_NVME
 config BLK_DEV_SKD
 	tristate "STEC S1120 Block Driver"
 	depends on PCI
+	depends on 64BIT
 	---help---
 	Saying Y or M here will enable support for the
 	STEC, Inc. S1120 PCIe SSD.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly-fix.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
drivers-block-skd_mainc-fix-a-few-things-disable-on-32-bit.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

