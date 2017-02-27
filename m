From: akpm@linux-foundation.org
Subject: [patch 57/78] scripts/spelling.txt: add "comsume(r)" pattern and
 fix typo instances
Date: Mon, 27 Feb 2017 14:29:25 -0800
Message-ID: <58b4a845.S3ldNOMr9O2wkcM3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdB0Wdi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "comsume(r)" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  comsume||consume
  comsumer||consumer
  comsuming||consuming

I see some variable names with this pattern, but this commit is only
touching comment blocks to avoid unexpected impact.

Link: http://lkml.kernel.org/r/1481573103-11329-19-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-kye.c                   |    2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c |    2 +-
 drivers/net/ethernet/sis/sis900.c       |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c            |    4 ++--
 drivers/tty/serial/ioc4_serial.c        |    2 +-
 fs/ext4/extents_status.c                |    2 +-
 mm/page-writeback.c                     |    2 +-
 scripts/spelling.txt                    |    3 +++
 8 files changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/hid/hid-kye.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances drivers/hid/hid-kye.c
--- a/drivers/hid/hid-kye.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances
+++ a/drivers/hid/hid-kye.c
@@ -487,7 +487,7 @@ static __u8 *kye_consumer_control_fixup(
 		unsigned int *rsize, int offset, const char *device_name) {
 	/*
 	 * the fixup that need to be done:
-	 *   - change Usage Maximum in the Comsumer Control
+	 *   - change Usage Maximum in the Consumer Control
 	 *     (report ID 3) to a reasonable value
 	 */
 	if (*rsize >= offset + 31 &&
diff -puN drivers/misc/vmw_vmci/vmci_queue_pair.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances drivers/misc/vmw_vmci/vmci_queue_pair.c
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances
+++ a/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -2928,7 +2928,7 @@ int vmci_qpair_get_produce_indexes(const
 EXPORT_SYMBOL_GPL(vmci_qpair_get_produce_indexes);
 
 /*
- * vmci_qpair_get_consume_indexes() - Retrieves the indexes of the comsumer.
+ * vmci_qpair_get_consume_indexes() - Retrieves the indexes of the consumer.
  * @qpair:      Pointer to the queue pair struct.
  * @consumer_tail:      Reference used for storing consumer tail index.
  * @producer_head:      Reference used for storing the producer head index.
diff -puN drivers/net/ethernet/sis/sis900.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances drivers/net/ethernet/sis/sis900.c
--- a/drivers/net/ethernet/sis/sis900.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/sis/sis900.c
@@ -176,7 +176,7 @@ struct sis900_private {
 
 	u32 msg_enable;
 
-	unsigned int cur_rx, dirty_rx; /* producer/comsumer pointers for Tx/Rx ring */
+	unsigned int cur_rx, dirty_rx; /* producer/consumer pointers for Tx/Rx ring */
 	unsigned int cur_tx, dirty_tx;
 
 	/* The saved address of a sent/receive-in-place packet buffer */
diff -puN drivers/scsi/lpfc/lpfc_sli.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -12079,7 +12079,7 @@ lpfc_sli4_sp_handle_els_wcqe(struct lpfc
  * @phba: Pointer to HBA context object.
  * @wcqe: Pointer to work-queue completion queue entry.
  *
- * This routine handles slow-path WQ entry comsumed event by invoking the
+ * This routine handles slow-path WQ entry consumed event by invoking the
  * proper WQ release routine to the slow-path WQ.
  **/
 static void
@@ -12451,7 +12451,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc
  * @cq: Pointer to completion queue.
  * @wcqe: Pointer to work-queue completion queue entry.
  *
- * This routine handles an fast-path WQ entry comsumed event by invoking the
+ * This routine handles an fast-path WQ entry consumed event by invoking the
  * proper WQ release routine to the slow-path WQ.
  **/
 static void
diff -puN drivers/tty/serial/ioc4_serial.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances drivers/tty/serial/ioc4_serial.c
--- a/drivers/tty/serial/ioc4_serial.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances
+++ a/drivers/tty/serial/ioc4_serial.c
@@ -210,7 +210,7 @@
 #define IOC4_SSCR_PAUSE_STATE   0x40000000  /* Sets when PAUSE takes effect */
 #define IOC4_SSCR_RESET	        0x80000000  /* Reset DMA channels */
 
-/* All producer/comsumer pointers are the same bitfield */
+/* All producer/consumer pointers are the same bitfield */
 #define IOC4_PROD_CONS_PTR_4K   0x00000ff8	/* For 4K buffers */
 #define IOC4_PROD_CONS_PTR_1K   0x000003f8	/* For 1K buffers */
 #define IOC4_PROD_CONS_PTR_OFF           3
diff -puN fs/ext4/extents_status.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances fs/ext4/extents_status.c
--- a/fs/ext4/extents_status.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances
+++ a/fs/ext4/extents_status.c
@@ -84,7 +84,7 @@
  *   --	writeout
  *	Writeout looks up whole page cache to see if a buffer is
  *	mapped, If there are not very many delayed buffers, then it is
- *	time comsuming.
+ *	time consuming.
  *
  * With extent status tree implementation, FIEMAP, SEEK_HOLE/DATA,
  * bigalloc and writeout can figure out if a block or a range of
diff -puN mm/page-writeback.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances mm/page-writeback.c
--- a/mm/page-writeback.c~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances
+++ a/mm/page-writeback.c
@@ -1797,7 +1797,7 @@ pause:
 		 * pages exceeds dirty_thresh, give the other good wb's a pipe
 		 * to go through, so that tasks on them still remain responsive.
 		 *
-		 * In theory 1 page is enough to keep the comsumer-producer
+		 * In theory 1 page is enough to keep the consumer-producer
 		 * pipe going: the flusher cleans 1 page => the task dirties 1
 		 * more page. However wb_dirty has accounting errors.  So use
 		 * the larger and more IO friendly wb_stat_error.
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -244,6 +244,9 @@ commited||committed
 commiting||committing
 committ||commit
 commoditiy||commodity
+comsume||consume
+comsumer||consumer
+comsuming||consuming
 compability||compatibility
 compaibility||compatibility
 compatability||compatibility
_
