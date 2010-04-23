From: akpm@linux-foundation.org
Subject: [merged] scsi-fix-operator-precedence-warning.patch removed from -mm tree
Date: Fri, 23 Apr 2010 10:49:22 -0400
Message-ID: <201004231750.o3NHov2K002977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758466Ab0DWR6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Apr 2010 13:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, david.somayajulu@qlogic.com, karen.higgins@qlogic.com, ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com, mm-commits@vg


The patch titled
     scsi: fix operator precedence warning
has been removed from the -mm tree.  Its filename was
     scsi-fix-operator-precedence-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: fix operator precedence warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix operator precedence warning (from sparse), which results in the data
value always being 0:

drivers/scsi/qla4xxx/ql4_mbx.c:470:66: warning: right shift by bigger than source value

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Ravi Anand <ravi.anand@qlogic.com>
Cc: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: Karen Higgins <karen.higgins@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla4xxx/ql4_mbx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla4xxx/ql4_mbx.c~scsi-fix-operator-precedence-warning drivers/scsi/qla4xxx/ql4_mbx.c
--- a/drivers/scsi/qla4xxx/ql4_mbx.c~scsi-fix-operator-precedence-warning
+++ a/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -467,7 +467,7 @@ int qla4xxx_get_fwddb_entry(struct scsi_
 	if (conn_err_detail)
 		*conn_err_detail = mbox_sts[5];
 	if (tcp_source_port_num)
-		*tcp_source_port_num = (uint16_t) mbox_sts[6] >> 16;
+		*tcp_source_port_num = (uint16_t) (mbox_sts[6] >> 16);
 	if (connection_id)
 		*connection_id = (uint16_t) mbox_sts[6] & 0x00FF;
 	status = QLA_SUCCESS;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
uv_irqc-fix-all-sparse-warnings.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
usb-fix-serial-build-when-sysrq-is-disabled.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
documentation-additions-to-submitchecklist.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

