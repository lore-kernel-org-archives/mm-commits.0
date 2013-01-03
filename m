From: akpm@linux-foundation.org
Subject: + mtip32xx-convert-to-batch-completion.patch added to -mm tree
Date: Thu, 03 Jan 2013 15:41:51 -0800
Message-ID: <20130103234157.D876F200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:41032 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3ACXmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 18:42:02 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so986235wib.5
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 15:42:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com


The patch titled
     Subject: mtip32xx: convert to batch completion
has been added to the -mm tree.  Its filename is
     mtip32xx-convert-to-batch-completion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: mtip32xx: convert to batch completion

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mtip32xx/mtip32xx.c |   68 ++++++++++++----------------
 drivers/block/mtip32xx/mtip32xx.h |    8 +--
 2 files changed, 34 insertions(+), 42 deletions(-)

diff -puN drivers/block/mtip32xx/mtip32xx.c~mtip32xx-convert-to-batch-completion drivers/block/mtip32xx/mtip32xx.c
--- a/drivers/block/mtip32xx/mtip32xx.c~mtip32xx-convert-to-batch-completion
+++ a/drivers/block/mtip32xx/mtip32xx.c
@@ -159,11 +159,9 @@ static void mtip_command_cleanup(struct 
 			command = &port->commands[commandindex];
 
 			if (atomic_read(&command->active)
-			    && (command->async_callback)) {
-				command->async_callback(command->async_data,
-					-ENODEV);
-				command->async_callback = NULL;
-				command->async_data = NULL;
+			    && (command->bio)) {
+				bio_endio(command->bio, -ENODEV);
+				command->bio = NULL;
 			}
 
 			dma_unmap_sg(&port->dd->pdev->dev,
@@ -603,11 +601,9 @@ static void mtip_timeout_function(unsign
 			writel(1 << bit, port->completed[group]);
 
 			/* Call the async completion callback. */
-			if (likely(command->async_callback))
-				command->async_callback(command->async_data,
-							 -EIO);
-			command->async_callback = NULL;
-			command->comp_func = NULL;
+			if (likely(command->bio))
+				bio_endio(command->bio, -EIO);
+			command->bio = NULL;
 
 			/* Unmap the DMA scatter list entries */
 			dma_unmap_sg(&port->dd->pdev->dev,
@@ -675,7 +671,8 @@ static void mtip_timeout_function(unsign
 static void mtip_async_complete(struct mtip_port *port,
 				int tag,
 				void *data,
-				int status)
+				int status,
+				struct batch_complete *batch)
 {
 	struct mtip_cmd *command;
 	struct driver_data *dd = data;
@@ -692,11 +689,10 @@ static void mtip_async_complete(struct m
 	}
 
 	/* Upper layer callback */
-	if (likely(command->async_callback))
-		command->async_callback(command->async_data, cb_status);
+	if (likely(command->bio))
+		bio_endio_batch(command->bio, cb_status, batch);
 
-	command->async_callback = NULL;
-	command->comp_func = NULL;
+	command->bio = NULL;
 
 	/* Unmap the DMA scatter list entries */
 	dma_unmap_sg(&dd->pdev->dev,
@@ -729,24 +725,22 @@ static void mtip_async_complete(struct m
 static void mtip_completion(struct mtip_port *port,
 			    int tag,
 			    void *data,
-			    int status)
+			    int status,
+			    struct batch_complete *batch)
 {
-	struct mtip_cmd *command = &port->commands[tag];
 	struct completion *waiting = data;
 	if (unlikely(status == PORT_IRQ_TF_ERR))
 		dev_warn(&port->dd->pdev->dev,
 			"Internal command %d completed with TFE\n", tag);
 
-	command->async_callback = NULL;
-	command->comp_func = NULL;
-
 	complete(waiting);
 }
 
 static void mtip_null_completion(struct mtip_port *port,
 			    int tag,
 			    void *data,
-			    int status)
+			    int status,
+			    struct batch_complete *batch)
 {
 	return;
 }
@@ -792,7 +786,7 @@ static void mtip_handle_tfe(struct drive
 		atomic_inc(&cmd->active); /* active > 1 indicates error */
 		if (cmd->comp_data && cmd->comp_func) {
 			cmd->comp_func(port, MTIP_TAG_INTERNAL,
-					cmd->comp_data, PORT_IRQ_TF_ERR);
+					cmd->comp_data, PORT_IRQ_TF_ERR, NULL);
 		}
 		goto handle_tfe_exit;
 	}
@@ -825,7 +819,7 @@ static void mtip_handle_tfe(struct drive
 				cmd->comp_func(port,
 					 tag,
 					 cmd->comp_data,
-					 0);
+					 0, NULL);
 			} else {
 				dev_err(&port->dd->pdev->dev,
 					"Missing completion func for tag %d",
@@ -912,7 +906,7 @@ static void mtip_handle_tfe(struct drive
 					if (cmd->comp_func) {
 						cmd->comp_func(port, tag,
 							cmd->comp_data,
-							-ENODATA);
+							-ENODATA, NULL);
 					}
 					continue;
 				}
@@ -942,7 +936,7 @@ static void mtip_handle_tfe(struct drive
 					port,
 					tag,
 					cmd->comp_data,
-					PORT_IRQ_TF_ERR);
+					PORT_IRQ_TF_ERR, NULL);
 			else
 				dev_warn(&port->dd->pdev->dev,
 					"Bad completion for tag %d\n",
@@ -969,6 +963,9 @@ static inline void mtip_process_sdbf(str
 	int group, tag, bit;
 	u32 completed;
 	struct mtip_cmd *command;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	/* walk all bits in all slot groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -997,7 +994,8 @@ static inline void mtip_process_sdbf(str
 						port,
 						tag,
 						command->comp_data,
-						0);
+						0,
+						&batch);
 				} else {
 					dev_warn(&dd->pdev->dev,
 						"Null completion "
@@ -1007,12 +1005,14 @@ static inline void mtip_process_sdbf(str
 					if (mtip_check_surprise_removal(
 						dd->pdev)) {
 						mtip_command_cleanup(dd);
-						return;
+						goto out;
 					}
 				}
 			}
 		}
 	}
+out:
+	batch_complete(&batch);
 }
 
 /*
@@ -1030,7 +1030,7 @@ static inline void mtip_process_legacy(s
 			cmd->comp_func(port,
 				MTIP_TAG_INTERNAL,
 				cmd->comp_data,
-				0);
+				0, NULL);
 			return;
 		}
 	}
@@ -2441,8 +2441,8 @@ static int mtip_hw_ioctl(struct driver_d
  *	None
  */
 static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
-			      int nsect, int nents, int tag, void *callback,
-			      void *data, int dir)
+			      int nsect, int nents, int tag,
+			      struct bio *bio, int dir)
 {
 	struct host_to_dev_fis	*fis;
 	struct mtip_port *port = dd->port;
@@ -2497,12 +2497,7 @@ static void mtip_hw_submit_io(struct dri
 	command->comp_func = mtip_async_complete;
 	command->direction = dma_dir;
 
-	/*
-	 * Set the completion function and data for the command passed
-	 * from the upper layer.
-	 */
-	command->async_data = data;
-	command->async_callback = callback;
+	command->bio = bio;
 
 	/*
 	 * To prevent this command from being issued
@@ -3672,7 +3667,6 @@ static void mtip_make_request(struct req
 				bio_sectors(bio),
 				nents,
 				tag,
-				bio_endio,
 				bio,
 				bio_data_dir(bio));
 	} else
diff -puN drivers/block/mtip32xx/mtip32xx.h~mtip32xx-convert-to-batch-completion drivers/block/mtip32xx/mtip32xx.h
--- a/drivers/block/mtip32xx/mtip32xx.h~mtip32xx-convert-to-batch-completion
+++ a/drivers/block/mtip32xx/mtip32xx.h
@@ -296,11 +296,9 @@ struct mtip_cmd {
 	void (*comp_func)(struct mtip_port *port,
 				int tag,
 				void *data,
-				int status);
-	/* Additional callback function that may be called by comp_func() */
-	void (*async_callback)(void *data, int status);
-
-	void *async_data; /* Addl. data passed to async_callback() */
+				int status,
+				struct batch_complete *batch);
+	struct bio *bio;
 
 	int scatter_ents; /* Number of scatter list entries used */
 
_

Patches currently in -mm which might be from koverstreet@google.com are

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
wait-add-wait_event_hrtimeout-fix.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
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
aio-smoosh-struct-kiocb.patch

