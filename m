Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B4CC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA28611B0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbhIIVGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346995AbhIIVFl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97432611B0;
        Thu,  9 Sep 2021 21:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221471;
        bh=WUWjjYOUw/Sbc3QLp0G5UOTiurUr73TvQmFvC02ZClw=;
        h=Date:From:To:Subject:From;
        b=keAcyB5FHYjAf9BM+EZYivLIXbC2I5Pt5/bheU976aSGQQJCs7zDqLyK/VlSMr1XC
         +jI122rP4KLsPiThL/UoC2epfv2JHETaFqKXrZDWbDtjQ3GvXGTotZFqTsrWlQ8/yp
         7JmPP2D8qpn+m2G5dqAQXdmjNwQ7AFqWQArKIXnQ=
Date:   Thu, 09 Sep 2021 14:04:31 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, mm-commits@vger.kernel.org,
        ulf.hansson@linaro.org, will@kernel.org,
        wsa+renesas@sang-engineering.com, yury.norov@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?all-replace-find=5Fnext=5Fzero=5Fbit-with-find=5Ffirst=5F?=
 =?US-ASCII?Q?zero=5Fbit-where-appropriate.patch?= removed from -mm tree
Message-ID: <20210909210431.-9li-DH57%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: all: replace find_next{,_zero}_bit with find_first{,_zero}_bit where appropriate
has been removed from the -mm tree.  Its filename was
     all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: all: replace find_next{,_zero}_bit with find_first{,_zero}_bit where appropriate

find_first{,_zero}_bit is a more effective analogue of 'next' version if
start == 0.  This patch replaces 'next' with 'first' where things look
trivial.

Link: https://lkml.kernel.org/r/20210814211713.180533-8-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pasemi/dma_lib.c |    4 ++--
 arch/s390/kvm/kvm-s390.c                |    2 +-
 drivers/block/rnbd/rnbd-clt.c           |    2 +-
 drivers/dma/ti/edma.c                   |    2 +-
 drivers/iio/adc/ad7124.c                |    2 +-
 drivers/infiniband/hw/irdma/hw.c        |   16 ++++++++--------
 drivers/media/cec/core/cec-core.c       |    2 +-
 drivers/media/mc/mc-devnode.c           |    2 +-
 drivers/pci/controller/dwc/pci-dra7xx.c |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c            |   10 +++++-----
 drivers/soc/ti/k3-ringacc.c             |    4 ++--
 drivers/tty/n_tty.c                     |    2 +-
 drivers/virt/acrn/ioreq.c               |    3 +--
 fs/f2fs/segment.c                       |    8 ++++----
 fs/ocfs2/cluster/heartbeat.c            |    2 +-
 fs/ocfs2/dlm/dlmdomain.c                |    4 ++--
 fs/ocfs2/dlm/dlmmaster.c                |   18 +++++++++---------
 fs/ocfs2/dlm/dlmrecovery.c              |    2 +-
 fs/ocfs2/dlm/dlmthread.c                |    2 +-
 lib/genalloc.c                          |    2 +-
 net/ncsi/ncsi-manage.c                  |    4 ++--
 21 files changed, 47 insertions(+), 48 deletions(-)

--- a/arch/powerpc/platforms/pasemi/dma_lib.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/arch/powerpc/platforms/pasemi/dma_lib.c
@@ -375,7 +375,7 @@ int pasemi_dma_alloc_flag(void)
 	int bit;
 
 retry:
-	bit = find_next_bit(flags_free, MAX_FLAGS, 0);
+	bit = find_first_bit(flags_free, MAX_FLAGS);
 	if (bit >= MAX_FLAGS)
 		return -ENOSPC;
 	if (!test_and_clear_bit(bit, flags_free))
@@ -440,7 +440,7 @@ int pasemi_dma_alloc_fun(void)
 	int bit;
 
 retry:
-	bit = find_next_bit(fun_free, MAX_FLAGS, 0);
+	bit = find_first_bit(fun_free, MAX_FLAGS);
 	if (bit >= MAX_FLAGS)
 		return -ENOSPC;
 	if (!test_and_clear_bit(bit, fun_free))
--- a/arch/s390/kvm/kvm-s390.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/arch/s390/kvm/kvm-s390.c
@@ -2023,7 +2023,7 @@ static unsigned long kvm_s390_next_dirty
 	while ((slotidx > 0) && (ofs >= ms->npages)) {
 		slotidx--;
 		ms = slots->memslots + slotidx;
-		ofs = find_next_bit(kvm_second_dirty_bitmap(ms), ms->npages, 0);
+		ofs = find_first_bit(kvm_second_dirty_bitmap(ms), ms->npages);
 	}
 	return ms->base_gfn + ofs;
 }
--- a/drivers/block/rnbd/rnbd-clt.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/block/rnbd/rnbd-clt.c
@@ -196,7 +196,7 @@ rnbd_get_cpu_qlist(struct rnbd_clt_sessi
 		return per_cpu_ptr(sess->cpu_queues, bit);
 	} else if (cpu != 0) {
 		/* Search from 0 to cpu */
-		bit = find_next_bit(sess->cpu_queues_bm, cpu, 0);
+		bit = find_first_bit(sess->cpu_queues_bm, cpu);
 		if (bit < cpu)
 			return per_cpu_ptr(sess->cpu_queues, bit);
 	}
--- a/drivers/dma/ti/edma.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/dma/ti/edma.c
@@ -1681,7 +1681,7 @@ static irqreturn_t dma_ccerr_handler(int
 
 			dev_dbg(ecc->dev, "EMR%d 0x%08x\n", j, val);
 			emr = val;
-			for (i = find_next_bit(&emr, 32, 0); i < 32;
+			for (i = find_first_bit(&emr, 32); i < 32;
 			     i = find_next_bit(&emr, 32, i + 1)) {
 				int k = (j << 5) + i;
 
--- a/drivers/iio/adc/ad7124.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/iio/adc/ad7124.c
@@ -347,7 +347,7 @@ static int ad7124_find_free_config_slot(
 {
 	unsigned int free_cfg_slot;
 
-	free_cfg_slot = find_next_zero_bit(&st->cfg_slots_status, AD7124_MAX_CONFIGS, 0);
+	free_cfg_slot = find_first_zero_bit(&st->cfg_slots_status, AD7124_MAX_CONFIGS);
 	if (free_cfg_slot == AD7124_MAX_CONFIGS)
 		return -1;
 
--- a/drivers/infiniband/hw/irdma/hw.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/infiniband/hw/irdma/hw.c
@@ -1696,14 +1696,14 @@ clean_msixtbl:
  */
 static void irdma_get_used_rsrc(struct irdma_device *iwdev)
 {
-	iwdev->rf->used_pds = find_next_zero_bit(iwdev->rf->allocated_pds,
-						 iwdev->rf->max_pd, 0);
-	iwdev->rf->used_qps = find_next_zero_bit(iwdev->rf->allocated_qps,
-						 iwdev->rf->max_qp, 0);
-	iwdev->rf->used_cqs = find_next_zero_bit(iwdev->rf->allocated_cqs,
-						 iwdev->rf->max_cq, 0);
-	iwdev->rf->used_mrs = find_next_zero_bit(iwdev->rf->allocated_mrs,
-						 iwdev->rf->max_mr, 0);
+	iwdev->rf->used_pds = find_first_zero_bit(iwdev->rf->allocated_pds,
+						 iwdev->rf->max_pd);
+	iwdev->rf->used_qps = find_first_zero_bit(iwdev->rf->allocated_qps,
+						 iwdev->rf->max_qp);
+	iwdev->rf->used_cqs = find_first_zero_bit(iwdev->rf->allocated_cqs,
+						 iwdev->rf->max_cq);
+	iwdev->rf->used_mrs = find_first_zero_bit(iwdev->rf->allocated_mrs,
+						 iwdev->rf->max_mr);
 }
 
 void irdma_ctrl_deinit_hw(struct irdma_pci_f *rf)
--- a/drivers/media/cec/core/cec-core.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/media/cec/core/cec-core.c
@@ -106,7 +106,7 @@ static int __must_check cec_devnode_regi
 
 	/* Part 1: Find a free minor number */
 	mutex_lock(&cec_devnode_lock);
-	minor = find_next_zero_bit(cec_devnode_nums, CEC_NUM_DEVICES, 0);
+	minor = find_first_zero_bit(cec_devnode_nums, CEC_NUM_DEVICES);
 	if (minor == CEC_NUM_DEVICES) {
 		mutex_unlock(&cec_devnode_lock);
 		pr_err("could not get a free minor\n");
--- a/drivers/media/mc/mc-devnode.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/media/mc/mc-devnode.c
@@ -217,7 +217,7 @@ int __must_check media_devnode_register(
 
 	/* Part 1: Find a free minor number */
 	mutex_lock(&media_devnode_lock);
-	minor = find_next_zero_bit(media_devnode_nums, MEDIA_NUM_DEVICES, 0);
+	minor = find_first_zero_bit(media_devnode_nums, MEDIA_NUM_DEVICES);
 	if (minor == MEDIA_NUM_DEVICES) {
 		mutex_unlock(&media_devnode_lock);
 		pr_err("could not get a free minor\n");
--- a/drivers/pci/controller/dwc/pci-dra7xx.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -211,7 +211,7 @@ static int dra7xx_pcie_handle_msi(struct
 	if (!val)
 		return 0;
 
-	pos = find_next_bit(&val, MAX_MSI_IRQS_PER_CTRL, 0);
+	pos = find_first_bit(&val, MAX_MSI_IRQS_PER_CTRL);
 	while (pos != MAX_MSI_IRQS_PER_CTRL) {
 		irq = irq_find_mapping(pp->irq_domain,
 				       (index * MAX_MSI_IRQS_PER_CTRL) + pos);
--- a/drivers/scsi/lpfc/lpfc_sli.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -17250,8 +17250,8 @@ lpfc_sli4_alloc_xri(struct lpfc_hba *phb
 	 * the driver starts at 0 each time.
 	 */
 	spin_lock_irq(&phba->hbalock);
-	xri = find_next_zero_bit(phba->sli4_hba.xri_bmask,
-				 phba->sli4_hba.max_cfg_param.max_xri, 0);
+	xri = find_first_zero_bit(phba->sli4_hba.xri_bmask,
+				 phba->sli4_hba.max_cfg_param.max_xri);
 	if (xri >= phba->sli4_hba.max_cfg_param.max_xri) {
 		spin_unlock_irq(&phba->hbalock);
 		return NO_XRI;
@@ -18928,7 +18928,7 @@ lpfc_sli4_alloc_rpi(struct lpfc_hba *phb
 	max_rpi = phba->sli4_hba.max_cfg_param.max_rpi;
 	rpi_limit = phba->sli4_hba.next_rpi;
 
-	rpi = find_next_zero_bit(phba->sli4_hba.rpi_bmask, rpi_limit, 0);
+	rpi = find_first_zero_bit(phba->sli4_hba.rpi_bmask, rpi_limit);
 	if (rpi >= rpi_limit)
 		rpi = LPFC_RPI_ALLOC_ERROR;
 	else {
@@ -19571,8 +19571,8 @@ next_priority:
 		 * have been tested so that we can detect when we should
 		 * change the priority level.
 		 */
-		next_fcf_index = find_next_bit(phba->fcf.fcf_rr_bmask,
-					       LPFC_SLI4_FCF_TBL_INDX_MAX, 0);
+		next_fcf_index = find_first_bit(phba->fcf.fcf_rr_bmask,
+					       LPFC_SLI4_FCF_TBL_INDX_MAX);
 	}
 
 
--- a/drivers/soc/ti/k3-ringacc.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/soc/ti/k3-ringacc.c
@@ -358,8 +358,8 @@ struct k3_ring *k3_ringacc_request_ring(
 		goto out;
 
 	if (flags & K3_RINGACC_RING_USE_PROXY) {
-		proxy_id = find_next_zero_bit(ringacc->proxy_inuse,
-					      ringacc->num_proxies, 0);
+		proxy_id = find_first_zero_bit(ringacc->proxy_inuse,
+					      ringacc->num_proxies);
 		if (proxy_id == ringacc->num_proxies)
 			goto error;
 	}
--- a/drivers/tty/n_tty.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/tty/n_tty.c
@@ -1975,7 +1975,7 @@ static bool canon_copy_from_read_buf(str
 	more = n - (size - tail);
 	if (eol == N_TTY_BUF_SIZE && more) {
 		/* scan wrapped without finding set bit */
-		eol = find_next_bit(ldata->read_flags, more, 0);
+		eol = find_first_bit(ldata->read_flags, more);
 		found = eol != more;
 	} else
 		found = eol != size;
--- a/drivers/virt/acrn/ioreq.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/drivers/virt/acrn/ioreq.c
@@ -246,8 +246,7 @@ void acrn_ioreq_request_clear(struct acr
 	spin_lock_bh(&vm->ioreq_clients_lock);
 	client = vm->default_client;
 	if (client) {
-		vcpu = find_next_bit(client->ioreqs_map,
-				     ACRN_IO_REQUEST_MAX, 0);
+		vcpu = find_first_bit(client->ioreqs_map, ACRN_IO_REQUEST_MAX);
 		while (vcpu < ACRN_IO_REQUEST_MAX) {
 			acrn_ioreq_complete_request(client, vcpu, NULL);
 			vcpu = find_next_bit(client->ioreqs_map,
--- a/fs/f2fs/segment.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/fs/f2fs/segment.c
@@ -2495,8 +2495,8 @@ find_other_zone:
 	secno = find_next_zero_bit(free_i->free_secmap, MAIN_SECS(sbi), hint);
 	if (secno >= MAIN_SECS(sbi)) {
 		if (dir == ALLOC_RIGHT) {
-			secno = find_next_zero_bit(free_i->free_secmap,
-							MAIN_SECS(sbi), 0);
+			secno = find_first_zero_bit(free_i->free_secmap,
+							MAIN_SECS(sbi));
 			f2fs_bug_on(sbi, secno >= MAIN_SECS(sbi));
 		} else {
 			go_left = 1;
@@ -2511,8 +2511,8 @@ find_other_zone:
 			left_start--;
 			continue;
 		}
-		left_start = find_next_zero_bit(free_i->free_secmap,
-							MAIN_SECS(sbi), 0);
+		left_start = find_first_zero_bit(free_i->free_secmap,
+							MAIN_SECS(sbi));
 		f2fs_bug_on(sbi, left_start >= MAIN_SECS(sbi));
 		break;
 	}
--- a/fs/ocfs2/cluster/heartbeat.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -379,7 +379,7 @@ static void o2hb_nego_timeout(struct wor
 
 	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
 	/* lowest node as master node to make negotiate decision. */
-	master_node = find_next_bit(live_node_bitmap, O2NM_MAX_NODES, 0);
+	master_node = find_first_bit(live_node_bitmap, O2NM_MAX_NODES);
 
 	if (master_node == o2nm_this_node()) {
 		if (!test_bit(master_node, reg->hr_nego_node_bitmap)) {
--- a/fs/ocfs2/dlm/dlmdomain.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1045,7 +1045,7 @@ static int dlm_send_regions(struct dlm_c
 	int status, ret = 0, i;
 	char *p;
 
-	if (find_next_bit(node_map, O2NM_MAX_NODES, 0) >= O2NM_MAX_NODES)
+	if (find_first_bit(node_map, O2NM_MAX_NODES) >= O2NM_MAX_NODES)
 		goto bail;
 
 	qr = kzalloc(sizeof(struct dlm_query_region), GFP_KERNEL);
@@ -1217,7 +1217,7 @@ static int dlm_send_nodeinfo(struct dlm_
 	struct o2nm_node *node;
 	int ret = 0, status, count, i;
 
-	if (find_next_bit(node_map, O2NM_MAX_NODES, 0) >= O2NM_MAX_NODES)
+	if (find_first_bit(node_map, O2NM_MAX_NODES) >= O2NM_MAX_NODES)
 		goto bail;
 
 	qn = kzalloc(sizeof(struct dlm_query_nodeinfo), GFP_KERNEL);
--- a/fs/ocfs2/dlm/dlmmaster.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -861,7 +861,7 @@ lookup:
 		 * to see if there are any nodes that still need to be
 		 * considered.  these will not appear in the mle nodemap
 		 * but they might own this lockres.  wait on them. */
-		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
+		bit = find_first_bit(dlm->recovery_map, O2NM_MAX_NODES);
 		if (bit < O2NM_MAX_NODES) {
 			mlog(0, "%s: res %.*s, At least one node (%d) "
 			     "to recover before lock mastery can begin\n",
@@ -912,7 +912,7 @@ redo_request:
 		dlm_wait_for_recovery(dlm);
 
 		spin_lock(&dlm->spinlock);
-		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
+		bit = find_first_bit(dlm->recovery_map, O2NM_MAX_NODES);
 		if (bit < O2NM_MAX_NODES) {
 			mlog(0, "%s: res %.*s, At least one node (%d) "
 			     "to recover before lock mastery can begin\n",
@@ -1079,7 +1079,7 @@ recheck:
 		sleep = 1;
 		/* have all nodes responded? */
 		if (voting_done && !*blocked) {
-			bit = find_next_bit(mle->maybe_map, O2NM_MAX_NODES, 0);
+			bit = find_first_bit(mle->maybe_map, O2NM_MAX_NODES);
 			if (dlm->node_num <= bit) {
 				/* my node number is lowest.
 			 	 * now tell other nodes that I am
@@ -1234,8 +1234,8 @@ static int dlm_restart_lock_mastery(stru
 		} else {
 			mlog(ML_ERROR, "node down! %d\n", node);
 			if (blocked) {
-				int lowest = find_next_bit(mle->maybe_map,
-						       O2NM_MAX_NODES, 0);
+				int lowest = find_first_bit(mle->maybe_map,
+						       O2NM_MAX_NODES);
 
 				/* act like it was never there */
 				clear_bit(node, mle->maybe_map);
@@ -1795,7 +1795,7 @@ int dlm_assert_master_handler(struct o2n
 		     "MLE for it! (%.*s)\n", assert->node_idx,
 		     namelen, name);
 	} else {
-		int bit = find_next_bit (mle->maybe_map, O2NM_MAX_NODES, 0);
+		int bit = find_first_bit(mle->maybe_map, O2NM_MAX_NODES);
 		if (bit >= O2NM_MAX_NODES) {
 			/* not necessarily an error, though less likely.
 			 * could be master just re-asserting. */
@@ -2521,7 +2521,7 @@ static int dlm_is_lockres_migratable(str
 	}
 
 	if (!nonlocal) {
-		node_ref = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
+		node_ref = find_first_bit(res->refmap, O2NM_MAX_NODES);
 		if (node_ref >= O2NM_MAX_NODES)
 			return 0;
 	}
@@ -3303,7 +3303,7 @@ static void dlm_clean_block_mle(struct d
 	BUG_ON(mle->type != DLM_MLE_BLOCK);
 
 	spin_lock(&mle->spinlock);
-	bit = find_next_bit(mle->maybe_map, O2NM_MAX_NODES, 0);
+	bit = find_first_bit(mle->maybe_map, O2NM_MAX_NODES);
 	if (bit != dead_node) {
 		mlog(0, "mle found, but dead node %u would not have been "
 		     "master\n", dead_node);
@@ -3542,7 +3542,7 @@ void dlm_force_free_mles(struct dlm_ctxt
 	spin_lock(&dlm->master_lock);
 
 	BUG_ON(dlm->dlm_state != DLM_CTXT_LEAVING);
-	BUG_ON((find_next_bit(dlm->domain_map, O2NM_MAX_NODES, 0) < O2NM_MAX_NODES));
+	BUG_ON((find_first_bit(dlm->domain_map, O2NM_MAX_NODES) < O2NM_MAX_NODES));
 
 	for (i = 0; i < DLM_HASH_BUCKETS; i++) {
 		bucket = dlm_master_hash(dlm, i);
--- a/fs/ocfs2/dlm/dlmrecovery.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -451,7 +451,7 @@ static int dlm_do_recovery(struct dlm_ct
 	if (dlm->reco.dead_node == O2NM_INVALID_NODE_NUM) {
 		int bit;
 
-		bit = find_next_bit (dlm->recovery_map, O2NM_MAX_NODES, 0);
+		bit = find_first_bit(dlm->recovery_map, O2NM_MAX_NODES);
 		if (bit >= O2NM_MAX_NODES || bit < 0)
 			dlm_set_reco_dead_node(dlm, O2NM_INVALID_NODE_NUM);
 		else
--- a/fs/ocfs2/dlm/dlmthread.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -92,7 +92,7 @@ int __dlm_lockres_unused(struct dlm_lock
 		return 0;
 
 	/* Another node has this resource with this node as the master */
-	bit = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
+	bit = find_first_bit(res->refmap, O2NM_MAX_NODES);
 	if (bit < O2NM_MAX_NODES)
 		return 0;
 
--- a/lib/genalloc.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/lib/genalloc.c
@@ -251,7 +251,7 @@ void gen_pool_destroy(struct gen_pool *p
 		list_del(&chunk->next_chunk);
 
 		end_bit = chunk_size(chunk) >> order;
-		bit = find_next_bit(chunk->bits, end_bit, 0);
+		bit = find_first_bit(chunk->bits, end_bit);
 		BUG_ON(bit < end_bit);
 
 		vfree(chunk);
--- a/net/ncsi/ncsi-manage.c~all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate
+++ a/net/ncsi/ncsi-manage.c
@@ -608,7 +608,7 @@ static int clear_one_vid(struct ncsi_dev
 	bitmap = &ncf->bitmap;
 
 	spin_lock_irqsave(&nc->lock, flags);
-	index = find_next_bit(bitmap, ncf->n_vids, 0);
+	index = find_first_bit(bitmap, ncf->n_vids);
 	if (index >= ncf->n_vids) {
 		spin_unlock_irqrestore(&nc->lock, flags);
 		return -1;
@@ -667,7 +667,7 @@ static int set_one_vid(struct ncsi_dev_p
 		return -1;
 	}
 
-	index = find_next_zero_bit(bitmap, ncf->n_vids, 0);
+	index = find_first_zero_bit(bitmap, ncf->n_vids);
 	if (index < 0 || index >= ncf->n_vids) {
 		netdev_err(ndp->ndev.dev,
 			   "Channel %u already has all VLAN filters set\n",
_

Patches currently in -mm which might be from yury.norov@gmail.com are


