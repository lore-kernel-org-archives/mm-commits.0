From: akpm@linux-foundation.org
Subject: - lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch removed from -mm tree
Date: Mon, 26 Mar 2007 22:02:38 -0800
Message-ID: <200703270602.l2R62cC9008874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41043 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105AbXC0GCs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 02:02:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     lguest: block device speedup
has been removed from the -mm tree.  Its filename was
     lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch

This patch was dropped because it was folded into lguest-trivial-guest-block-driver.patch

------------------------------------------------------
Subject: lguest: block device speedup
From: Rusty Russell <rusty@rustcorp.com.au>

Jens Axboe pointed out that end_request() does not end the entire request.  Go
figure.  On the upside, he wrote the replacement for me!  Now we do far less
block traffic, and our performance sucks less.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/lguest_blk.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/block/lguest_blk.c~lguest-trivial-guest-block-driver-lguest-block-device-speedup drivers/block/lguest_blk.c
--- a/drivers/block/lguest_blk.c~lguest-trivial-guest-block-driver-lguest-block-device-speedup
+++ a/drivers/block/lguest_blk.c
@@ -45,6 +45,16 @@ struct blockdev
 	struct request *req;
 };
 
+/* Jens gave me this nice helper to end all chunks of a request. */
+static void end_entire_request(struct request *req, int uptodate)
+{
+	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+		BUG();
+	add_disk_randomness(req->rq_disk);
+	blkdev_dequeue_request(req);
+	end_that_request_last(req, uptodate);
+}
+
 static irqreturn_t lgb_irq(int irq, void *_bd)
 {
 	struct blockdev *bd = _bd;
@@ -61,7 +71,7 @@ static irqreturn_t lgb_irq(int irq, void
 	}
 
 	spin_lock_irqsave(&bd->lock, flags);
-	end_request(bd->req, bd->lb_page->result == 1);
+	end_entire_request(bd->req, bd->lb_page->result == 1);
 	bd->req = NULL;
 	bd->dma.used_len = 0;
 	blk_start_queue(bd->disk->queue);
@@ -149,7 +159,7 @@ again:
 		pr_debug("Got non-command 0x%08x\n", req->cmd_type);
 	error:
 		req->errors++;
-		end_request(req, 0);
+		end_entire_request(req, 0);
 		goto again;
 	} else {
 		if (rq_data_dir(req) == WRITE)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-clean-up-some-references-inittext-warnings.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-compile-hypervisors-into-the-lg-module-directly.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda.patch
i386-gdt-cleanups-use-per-cpu-variables-for-gdt-pda-fix.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot.patch
i386-gdt-cleanups-use-per-cpu-gdt-immediately-upon-boot-fix.patch
i386-gdt-cleanups-clean-up-cpu_init.patch
i386-gdt-cleanups-cleanup-gdt-access.patch
i386-gdt-cleanups-rename-boot_gdt_table-to-boot_gdt.patch
cleanup-rationalize-paravirt-wrappers.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
