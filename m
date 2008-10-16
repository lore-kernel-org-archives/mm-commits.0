From: akpm@linux-foundation.org
Subject: + drivers-pci-hotplug-cpqphp_ctrlc-convert-to.patch added to -mm tree
Date: Thu, 16 Oct 2008 14:41:22 -0700
Message-ID: <200810162141.m9GLfM5f024720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756935AbYJPVl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 17:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jbarnes@virtuousgeek.org, willy@linux.intel.com


The patch titled
     drivers/pci/hotplug/cpqphp_ctrl.c: Convert && to ||
has been added to the -mm tree.  Its filename is
     drivers-pci-hotplug-cpqphp_ctrlc-convert-to.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
drivers-misc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
drivers-i2c-busses-i2c-s3c2410c-correct-use-of-and.patch
drivers-pci-hotplug-cpqphp_ctrlc-convert-to.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch

