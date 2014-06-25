From: akpm@linux-foundation.org
Subject: + ipw2100-use-pci_zalloc_consistent.patch added to -mm tree
Date: Wed, 25 Jun 2014 12:30:19 -0700
Message-ID: <53ab234b.5PlmeLONHodQq2eF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaFYTaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 15:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linville@tuxdriver.com, stas.yakovlev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipw2100: use pci_zalloc_consistent
has been added to the -mm tree.  Its filename is
     ipw2100-use-pci_zalloc_consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipw2100-use-pci_zalloc_consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipw2100-use-pci_zalloc_consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ipw2100: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ipw2x00/ipw2100.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/net/wireless/ipw2x00/ipw2100.c~ipw2100-use-pci_zalloc_consistent drivers/net/wireless/ipw2x00/ipw2100.c
--- a/drivers/net/wireless/ipw2x00/ipw2100.c~ipw2100-use-pci_zalloc_consistent
+++ a/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -3449,8 +3449,9 @@ static int ipw2100_msg_allocate(struct i
 		return -ENOMEM;
 
 	for (i = 0; i < IPW_COMMAND_POOL_SIZE; i++) {
-		v = pci_alloc_consistent(priv->pci_dev,
-					 sizeof(struct ipw2100_cmd_header), &p);
+		v = pci_zalloc_consistent(priv->pci_dev,
+					  sizeof(struct ipw2100_cmd_header),
+					  &p);
 		if (!v) {
 			printk(KERN_ERR DRV_NAME ": "
 			       "%s: PCI alloc failed for msg "
@@ -3459,8 +3460,6 @@ static int ipw2100_msg_allocate(struct i
 			break;
 		}
 
-		memset(v, 0, sizeof(struct ipw2100_cmd_header));
-
 		priv->msg_buffers[i].type = COMMAND;
 		priv->msg_buffers[i].info.c_struct.cmd =
 		    (struct ipw2100_cmd_header *)v;
@@ -4336,16 +4335,12 @@ static int status_queue_allocate(struct
 	IPW_DEBUG_INFO("enter\n");
 
 	q->size = entries * sizeof(struct ipw2100_status);
-	q->drv =
-	    (struct ipw2100_status *)pci_alloc_consistent(priv->pci_dev,
-							  q->size, &q->nic);
+	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
 	if (!q->drv) {
 		IPW_DEBUG_WARNING("Can not allocate status queue.\n");
 		return -ENOMEM;
 	}
 
-	memset(q->drv, 0, q->size);
-
 	IPW_DEBUG_INFO("exit\n");
 
 	return 0;
@@ -4374,13 +4369,12 @@ static int bd_queue_allocate(struct ipw2
 
 	q->entries = entries;
 	q->size = entries * sizeof(struct ipw2100_bd);
-	q->drv = pci_alloc_consistent(priv->pci_dev, q->size, &q->nic);
+	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
 	if (!q->drv) {
 		IPW_DEBUG_INFO
 		    ("can't allocate shared memory for buffer descriptors\n");
 		return -ENOMEM;
 	}
-	memset(q->drv, 0, q->size);
 
 	IPW_DEBUG_INFO("exit\n");
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch

