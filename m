From: akpm@linux-foundation.org
Subject: [to-be-updated] mtip32xx-convert-to-batch-completion.patch
 removed from -mm tree
Date: Thu, 23 May 2013 13:50:33 -0700
Message-ID: <519e8119.65eXqkqh+TWXNppP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393Ab3EWUue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 16:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zab@redhat.com, viro@zeniv.linux.org.uk, tytso@mit.edu, smani@micron.com, sbradshaw@micron.com, rusty@rustcorp.com.au, mfasheh@suse.com, jmoyer@redhat.com, jlbec@evilplan.org, gregkh@linuxfoundation.org, bcrl@kvack.org, balbi@ti.com, axboe@kernel.dk, asamymuthupa@micron.com, koverstreet@google.com

Subject: [to-be-updated] mtip32xx-convert-to-batch-completion.patch removed from -mm tree
To: koverstreet@google.com,asamymuthupa@micron.com,axboe@kernel.dk,balbi@ti.com,bcrl@kvack.org,gregkh@linuxfoundation.org,jlbec@evilplan.org,jmoyer@redhat.com,mfasheh@suse.com,rusty@rustcorp.com.au,sbradshaw@micron.com,smani@micron.com,tytso@mit.edu,viro@zeniv.linux.org.uk,zab@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 13:50:33 -0700


The patch titled
     Subject: mtip32xx: convert to batch completion
has been removed from the -mm tree.  Its filename was
     mtip32xx-convert-to-batch-completion.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: mtip32xx: convert to batch completion

[asamymuthupa@micron.com:
	* changes for conversion to bio batch completion from Kent
	* fix to apply the above changes cleanly on latest mtip32xx code
	* batch bio completion changes in
		* mtip_command_cleanup()
		* mtip_timeout_function()
		* mtip_handle_tfe()]

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
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
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mtip32xx/mtip32xx.c |   86 +++++++++++++++-------------
 drivers/block/mtip32xx/mtip32xx.h |    8 --
 2 files changed, 51 insertions(+), 43 deletions(-)

diff -puN drivers/block/mtip32xx/mtip32xx.c~mtip32xx-convert-to-batch-completion drivers/block/mtip32xx/mtip32xx.c
--- a/drivers/block/mtip32xx/mtip32xx.c~mtip32xx-convert-to-batch-completion
+++ a/drivers/block/mtip32xx/mtip32xx.c
@@ -151,6 +151,9 @@ static void mtip_command_cleanup(struct
 	struct mtip_cmd *command;
 	struct mtip_port *port = dd->port;
 	static int in_progress;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (in_progress)
 		return;
@@ -166,11 +169,9 @@ static void mtip_command_cleanup(struct
 			command = &port->commands[commandindex];
 
 			if (atomic_read(&command->active)
-			    && (command->async_callback)) {
-				command->async_callback(command->async_data,
-					-ENODEV);
-				command->async_callback = NULL;
-				command->async_data = NULL;
+			    && (command->bio)) {
+				bio_endio_batch(command->bio, -ENODEV, &batch);
+				command->bio = NULL;
 			}
 
 			dma_unmap_sg(&port->dd->pdev->dev,
@@ -178,9 +179,10 @@ static void mtip_command_cleanup(struct
 				command->scatter_ents,
 				command->direction);
 		}
+		up(&port->cmd_slot);
 	}
 
-	up(&port->cmd_slot);
+	batch_complete(&batch);
 
 	set_bit(MTIP_DDF_CLEANUP_BIT, &dd->dd_flag);
 	in_progress = 0;
@@ -580,6 +582,9 @@ static void mtip_timeout_function(unsign
 	unsigned int bit, group;
 	unsigned int num_command_slots;
 	unsigned long to, tagaccum[SLOTBITS_IN_LONGS];
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (unlikely(!port))
 		return;
@@ -622,11 +627,9 @@ static void mtip_timeout_function(unsign
 			writel(1 << bit, port->completed[group]);
 
 			/* Call the async completion callback. */
-			if (likely(command->async_callback))
-				command->async_callback(command->async_data,
-							 -EIO);
-			command->async_callback = NULL;
-			command->comp_func = NULL;
+			if (likely(command->bio))
+				bio_endio_batch(command->bio, -EIO, &batch);
+			command->bio = NULL;
 
 			/* Unmap the DMA scatter list entries */
 			dma_unmap_sg(&port->dd->pdev->dev,
@@ -645,6 +648,8 @@ static void mtip_timeout_function(unsign
 		}
 	}
 
+	batch_complete(&batch);
+
 	if (cmdto_cnt) {
 		print_tags(port->dd, "timed out", tagaccum, cmdto_cnt);
 		if (!test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags)) {
@@ -695,7 +700,8 @@ static void mtip_timeout_function(unsign
 static void mtip_async_complete(struct mtip_port *port,
 				int tag,
 				void *data,
-				int status)
+				int status,
+				struct batch_complete *batch)
 {
 	struct mtip_cmd *command;
 	struct driver_data *dd = data;
@@ -712,11 +718,10 @@ static void mtip_async_complete(struct m
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
@@ -752,24 +757,22 @@ static void mtip_async_complete(struct m
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
@@ -798,6 +801,7 @@ static void mtip_handle_tfe(struct drive
 	unsigned char *buf;
 	char *fail_reason = NULL;
 	int fail_all_ncq_write = 0, fail_all_ncq_cmds = 0;
+	struct batch_complete batch;
 
 	dev_warn(&dd->pdev->dev, "Taskfile error\n");
 
@@ -815,13 +819,14 @@ static void mtip_handle_tfe(struct drive
 		atomic_inc(&cmd->active); /* active > 1 indicates error */
 		if (cmd->comp_data && cmd->comp_func) {
 			cmd->comp_func(port, MTIP_TAG_INTERNAL,
-					cmd->comp_data, PORT_IRQ_TF_ERR);
+					cmd->comp_data, PORT_IRQ_TF_ERR, NULL);
 		}
 		goto handle_tfe_exit;
 	}
 
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
+	batch_complete_init(&batch);
 
 	/* Loop through all the groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -848,7 +853,7 @@ static void mtip_handle_tfe(struct drive
 				cmd->comp_func(port,
 					 tag,
 					 cmd->comp_data,
-					 0);
+					 0, &batch);
 			} else {
 				dev_err(&port->dd->pdev->dev,
 					"Missing completion func for tag %d",
@@ -861,6 +866,7 @@ static void mtip_handle_tfe(struct drive
 			}
 		}
 	}
+	batch_complete(&batch);
 
 	print_tags(dd, "completed (TFE)", tagaccum, cmd_cnt);
 
@@ -902,6 +908,7 @@ static void mtip_handle_tfe(struct drive
 
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
+	batch_complete_init(&batch);
 
 	/* Loop through all the groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -935,7 +942,7 @@ static void mtip_handle_tfe(struct drive
 					if (cmd->comp_func) {
 						cmd->comp_func(port, tag,
 							cmd->comp_data,
-							-ENODATA);
+							-ENODATA, &batch);
 					}
 					continue;
 				}
@@ -965,13 +972,15 @@ static void mtip_handle_tfe(struct drive
 					port,
 					tag,
 					cmd->comp_data,
-					PORT_IRQ_TF_ERR);
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
@@ -992,6 +1001,9 @@ static inline void mtip_workq_sdbfx(stru
 	struct driver_data *dd = port->dd;
 	int tag, bit;
 	struct mtip_cmd *command;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (!completed) {
 		WARN_ON_ONCE(!completed);
@@ -1016,7 +1028,8 @@ static inline void mtip_workq_sdbfx(stru
 					port,
 					tag,
 					command->comp_data,
-					0);
+					0,
+					&batch);
 			} else {
 				dev_warn(&dd->pdev->dev,
 					"Null completion "
@@ -1026,13 +1039,16 @@ static inline void mtip_workq_sdbfx(stru
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
@@ -1053,7 +1069,7 @@ static inline void mtip_process_legacy(s
 			cmd->comp_func(port,
 				MTIP_TAG_INTERNAL,
 				cmd->comp_data,
-				0);
+				0, NULL);
 			return;
 		}
 	}
@@ -2561,8 +2577,8 @@ static int mtip_hw_ioctl(struct driver_d
  *	None
  */
 static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
-			      int nsect, int nents, int tag, void *callback,
-			      void *data, int dir, int unaligned)
+			      int nsect, int nents, int tag,
+			      struct bio *bio, int dir, int unaligned)
 {
 	struct host_to_dev_fis	*fis;
 	struct mtip_port *port = dd->port;
@@ -2621,12 +2637,7 @@ static void mtip_hw_submit_io(struct dri
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
@@ -3936,7 +3947,6 @@ static void mtip_make_request(struct req
 				bio_sectors(bio),
 				nents,
 				tag,
-				bio_endio,
 				bio,
 				bio_data_dir(bio),
 				unaligned);
diff -puN drivers/block/mtip32xx/mtip32xx.h~mtip32xx-convert-to-batch-completion drivers/block/mtip32xx/mtip32xx.h
--- a/drivers/block/mtip32xx/mtip32xx.h~mtip32xx-convert-to-batch-completion
+++ a/drivers/block/mtip32xx/mtip32xx.h
@@ -328,11 +328,9 @@ struct mtip_cmd {
 	void (*comp_func)(struct mtip_port *port,
 				int tag,
 				void *data,
-				int status);
-	/* Additional callback function that may be called by comp_func() */
-	void (*async_callback)(void *data, int status);
