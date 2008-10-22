From: akpm@linux-foundation.org
Subject: - drivers-pci-hotplug-cpqphp_ctrlc-convert-to.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:09:07 -0700
Message-ID: <200810222009.m9MK97uK013985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbYJVUJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:09:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, jbarnes@virtuousgeek.org, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/pci/hotplug/cpqphp_ctrl.c: Convert && to ||
has been removed from the -mm tree.  Its filename was
     drivers-pci-hotplug-cpqphp_ctrlc-convert-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/pci/hotplug/cpqphp_ctrl.c: Convert && to ||
From: Julia Lawall <julia@diku.dk>

The pattern !E && !E->fld is nonsensical.  The patch below updates this
according to the assumption that && should be ||.  But perhaps another
solution was intended.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@disable and_comm@
expression E;
identifier fld;
@@

- !E && !E->fld
+ !E || !E->fld
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/cpqphp_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/hotplug/cpqphp_ctrl.c~drivers-pci-hotplug-cpqphp_ctrlc-convert-to drivers/pci/hotplug/cpqphp_ctrl.c
--- a/drivers/pci/hotplug/cpqphp_ctrl.c~drivers-pci-hotplug-cpqphp_ctrlc-convert-to
+++ a/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -1139,7 +1139,7 @@ static u8 set_controller_speed(struct co
 	for(slot = ctrl->slot; slot; slot = slot->next) {
 		if (slot->device == (hp_slot + ctrl->slot_device_offset)) 
 			continue;
-		if (!slot->hotplug_slot && !slot->hotplug_slot->info) 
+		if (!slot->hotplug_slot || !slot->hotplug_slot->info)
 			continue;
 		if (slot->hotplug_slot->info->adapter_status == 0) 
 			continue;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch

