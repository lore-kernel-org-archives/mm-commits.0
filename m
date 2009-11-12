From: akpm@linux-foundation.org
Subject: + ocfs2-error-return-should-be-negative.patch added to -mm tree
Date: Thu, 12 Nov 2009 15:38:53 -0800
Message-ID: <200911122338.nACNcrmx015989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084AbZKLXj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 18:39:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, Joel.Becker@oracle.com, mfasheh@suse.com


The patch titled
     ocfs2: error return should be negative
has been added to the -mm tree.  Its filename is
     ocfs2-error-return-should-be-negative.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ocfs2: error return should be negative
From: Roel Kluin <roel.kluin@gmail.com>

Return a negative error value instead of a positive

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-error-return-should-be-negative fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-error-return-should-be-negative
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2639,7 +2639,7 @@ int dlm_begin_reco_handler(struct o2net_
 		     dlm->name, br->node_idx, br->dead_node,
 		     dlm->reco.dead_node, dlm->reco.new_master);
 		spin_unlock(&dlm->spinlock);
-		return EAGAIN;
+		return -EAGAIN;
 	}
 	spin_unlock(&dlm->spinlock);
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
omap-cs-should-be-positive-in-gpmc_cs_free.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
sms-cards-make-id-unsigned-in-sms_get_board.patch
mtd-error-return-eio-instead-of-eio.patch
ocfs2-error-return-should-be-negative.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch

