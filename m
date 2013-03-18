From: akpm@linux-foundation.org
Subject: [folded-merged] mtip32xx-convert-to-batch-completion-fix.patch removed from -mm tree
Date: Mon, 18 Mar 2013 13:38:28 -0700
Message-ID: <20130318203829.1B79031C349@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:50777 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3CRUia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:38:30 -0400
Received: by mail-oa0-f73.google.com with SMTP id o6so1332841oag.2
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:38:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: asamymuthupa@micron.com, axboe@kernel.dk, bcrl@kvack.org, jmoyer@redhat.com, koverstreet@google.com, tytso@mit.edu, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: conversion to bio batch completion
has been removed from the -mm tree.  Its filename was
     mtip32xx-convert-to-batch-completion-fix.patch

This patch was dropped because it was folded into mtip32xx-convert-to-batch-completion.patch

------------------------------------------------------
From: Asai Thambi S P <asamymuthupa@micron.com>
Subject: conversion to bio batch completion

	* changes for conversion to bio batch completion from Kent
	* fix to apply the above changes cleanly on latest mtip32xx code
	* batch bio completion changes in
		* mtip_command_cleanup()
		* mtip_timeout_function()
		* mtip_handle_tfe()

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zab@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mtip32xx/mtip32xx.c |   36 +++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff -puN drivers/block/mtip32xx/mtip32xx.c~mtip32xx-convert-to-batch-completion-fix drivers/block/mtip32xx/mtip32xx.c
--- a/drivers/block/mtip32xx/mtip32xx.c~mtip32xx-convert-to-batch-completion-fix
+++ a/drivers/block/mtip32xx/mtip32xx.c
@@ -146,6 +146,9 @@ static void mtip_command_cleanup(struct
 	struct mtip_cmd *command;
 	struct mtip_port *port = dd->port;
 	static int in_progress;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (in_progress)
 		return;
@@ -162,7 +165,7 @@ static void mtip_command_cleanup(struct
 
 			if (atomic_read(&command->active)
 			    && (command->bio)) {
-				bio_endio(command->bio, -ENODEV);
+				bio_endio_batch(command->bio, -ENODEV, &batch);
 				command->bio = NULL;
 			}
 
@@ -171,9 +174,10 @@ static void mtip_command_cleanup(struct
 				command->scatter_ents,
 				command->direction);
 		}
+		up(&port->cmd_slot);
 	}
 
-	up(&port->cmd_slot);
+	batch_complete(&batch);
 
 	set_bit(MTIP_DDF_CLEANUP_BIT, &dd->dd_flag);
 	in_progress = 0;
@@ -562,6 +566,9 @@ static void mtip_timeout_function(unsign
 	unsigned int bit, group;
 	unsigned int num_command_slots;
 	unsigned long to, tagaccum[SLOTBITS_IN_LONGS];
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (unlikely(!port))
 		return;
@@ -605,7 +612,7 @@ static void mtip_timeout_function(unsign
 
 			/* Call the async completion callback. */
 			if (likely(command->bio))
-				bio_endio(command->bio, -EIO);
+				bio_endio_batch(command->bio, -EIO, &batch);
 			command->bio = NULL;
 
 			/* Unmap the DMA scatter list entries */
@@ -625,6 +632,8 @@ static void mtip_timeout_function(unsign
 		}
 	}
 
+	batch_complete(&batch);
+
 	if (cmdto_cnt) {
 		print_tags(port->dd, "timed out", tagaccum, cmdto_cnt);
 		if (!test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags)) {
@@ -773,6 +782,7 @@ static void mtip_handle_tfe(struct drive
 	unsigned char *buf;
 	char *fail_reason = NULL;
 	int fail_all_ncq_write = 0, fail_all_ncq_cmds = 0;
+	struct batch_complete batch;
 
 	dev_warn(&dd->pdev->dev, "Taskfile error\n");
 
@@ -797,6 +807,7 @@ static void mtip_handle_tfe(struct drive
 
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
+	batch_complete_init(&batch);
 
 	/* Loop through all the groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -823,7 +834,7 @@ static void mtip_handle_tfe(struct drive
 				cmd->comp_func(port,
 					 tag,
 					 cmd->comp_data,
-					 0, NULL);
+					 0, &batch);
 			} else {
 				dev_err(&port->dd->pdev->dev,
 					"Missing completion func for tag %d",
@@ -836,6 +847,7 @@ static void mtip_handle_tfe(struct drive
 			}
 		}
 	}
+	batch_complete(&batch);
 
 	print_tags(dd, "completed (TFE)", tagaccum, cmd_cnt);
 
@@ -877,6 +889,7 @@ static void mtip_handle_tfe(struct drive
 
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
+	batch_complete_init(&batch);
 
 	/* Loop through all the groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -910,7 +923,7 @@ static void mtip_handle_tfe(struct drive
 					if (cmd->comp_func) {
 						cmd->comp_func(port, tag,
 							cmd->comp_data,
-							-ENODATA, NULL);
+							-ENODATA, &batch);
 					}
 					continue;
 				}
@@ -940,13 +953,15 @@ static void mtip_handle_tfe(struct drive
 					port,
 					tag,
 					cmd->comp_data,
-					PORT_IRQ_TF_ERR, NULL);
+					PORT_IRQ_TF_ERR, &batch);
 			else
 				dev_warn(&port->dd->pdev->dev,
 					"Bad completion for tag %d\n",
 					tag);
 		}
 	}
+
+	batch_complete(&batch);
 	print_tags(dd, "reissued (TFE)", tagaccum, cmd_cnt);
 
 handle_tfe_exit:
@@ -994,8 +1009,8 @@ static inline void mtip_workq_sdbfx(stru
 					port,
 					tag,
 					command->comp_data,
-						0,
-						&batch);
+					0,
+					&batch);
 			} else {
 				dev_warn(&dd->pdev->dev,
 					"Null completion "
@@ -1005,13 +1020,16 @@ static inline void mtip_workq_sdbfx(stru
 				if (mtip_check_surprise_removal(
 					dd->pdev)) {
 					mtip_command_cleanup(dd);
-					return;
+					goto out;
 				}
 			}
 		}
 		completed >>= 1;
 	}
 
+out:
+	batch_complete(&batch);
+
 	/* If last, re-enable interrupts */
 	if (atomic_dec_return(&dd->irq_workers_active) == 0)
 		writel(0xffffffff, dd->mmio + HOST_IRQ_STAT);
_

Patches currently in -mm which might be from asamymuthupa@micron.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch

