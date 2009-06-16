From: akpm@linux-foundation.org
Subject: [merged] qla2x-fix-printk-format-warnings.patch removed from -mm tree
Date: Tue, 16 Jun 2009 11:27:52 -0700
Message-ID: <200906161827.n5GIRqba028221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbZFPS2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 14:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, seokmann.ju@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     qla2x: fix printk format warnings
has been removed from the -mm tree.  Its filename was
     qla2x-fix-printk-format-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: qla2x: fix printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix qla2xxx printk format warnings:

drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/qla2xxx/qla_sup.c:915: warning: long long unsigned int format, u64 arg (arg 6)
drivers/scsi/qla2xxx/qla_sup.c:923: warning: long long unsigned int format, u64 arg (arg 5)
drivers/scsi/qla2xxx/qla_sup.c:923: warning: long long unsigned int format, u64 arg (arg 6)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_sup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_sup.c~qla2x-fix-printk-format-warnings drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c~qla2x-fix-printk-format-warnings
+++ a/drivers/scsi/qla2xxx/qla_sup.c
@@ -945,7 +945,9 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t 
 
 		DEBUG2(qla_printk(KERN_INFO, ha, "NPIV[%02x]: wwpn=%llx "
 			"wwnn=%llx vf_id=0x%x Q_qos=0x%x F_qos=0x%x.\n", cnt,
-			vid.port_name, vid.node_name, le16_to_cpu(entry->vf_id),
+			(unsigned long long)vid.port_name,
+			(unsigned long long)vid.node_name,
+			le16_to_cpu(entry->vf_id),
 			entry->q_qos, entry->f_qos));
 
 		if (i < QLA_PRECONFIG_VPORTS) {
@@ -954,7 +956,8 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t 
 				qla_printk(KERN_INFO, ha,
 				"NPIV-Config: Failed to create vport [%02x]: "
 				"wwpn=%llx wwnn=%llx.\n", cnt,
-				vid.port_name, vid.node_name);
+				(unsigned long long)vid.port_name,
+				(unsigned long long)vid.node_name);
 		}
 	}
 done:
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
hexdump-remove-the-trailing-space.patch
kmap_types-make-most-arches-use-generic-header-file.patch
lis3-use-input_polled_device-fix.patch
lis3-use-input_polled_device-fix-2.patch
proctxt-update-kernel-filesystem-proctxt-documentation.patch
cgroups-make-messages-more-readable.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

