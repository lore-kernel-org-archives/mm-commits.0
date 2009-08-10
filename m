From: akpm@linux-foundation.org
Subject: [merged] ipath-strncpy-does-not-null-terminate-string.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:28:26 -0700
Message-ID: <200908101928.n7AJSQOr027641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbZHJT23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ralph.campbell@qlogic.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     ipath: strncpy does not null terminate string
has been removed from the -mm tree.  Its filename was
     ipath-strncpy-does-not-null-terminate-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipath: strncpy does not null terminate string
From: Roel Kluin <roel.kluin@gmail.com>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
 drivers/infiniband/hw/ipath/ipath_mad.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/infiniband/hw/ipath/ipath_file_ops.c~ipath-strncpy-does-not-null-terminate-string drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c~ipath-strncpy-does-not-null-terminate-string
+++ a/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1616,7 +1616,7 @@ static int try_alloc_port(struct ipath_d
 		pd->port_cnt = 1;
 		port_fp(fp) = pd;
 		pd->port_pid = get_pid(task_pid(current));
-		strncpy(pd->port_comm, current->comm, sizeof(pd->port_comm));
+		strlcpy(pd->port_comm, current->comm, sizeof(pd->port_comm));
 		ipath_stats.sps_ports++;
 		ret = 0;
 	} else
diff -puN drivers/infiniband/hw/ipath/ipath_mad.c~ipath-strncpy-does-not-null-terminate-string drivers/infiniband/hw/ipath/ipath_mad.c
--- a/drivers/infiniband/hw/ipath/ipath_mad.c~ipath-strncpy-does-not-null-terminate-string
+++ a/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -60,7 +60,7 @@ static int recv_subn_get_nodedescription
 	if (smp->attr_mod)
 		smp->status |= IB_SMP_INVALID_FIELD;
 
-	strncpy(smp->data, ibdev->node_desc, sizeof(smp->data));
+	strlcpy(smp->data, ibdev->node_desc, sizeof(smp->data));
 
 	return reply(smp);
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

