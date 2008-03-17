From: akpm@linux-foundation.org
Subject: + pciehp-dont-enable-slot-unless-forced.patch added to -mm tree
Date: Mon, 17 Mar 2008 14:48:23 -0700
Message-ID: <200803172148.m2HLmNvX032564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbYCQVtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, achiang@hp.com, greg@kroah.com, kristen.c.accardi@intel.com, mlord@pobox.com


The patch titled
     pciehp: don't enable slot unless forced
has been added to the -mm tree.  Its filename is
     pciehp-dont-enable-slot-unless-forced.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pciehp: don't enable slot unless forced
From: Mark Lord <lkml@rtr.ca>

This fixes a 2.6.25 regression reported by Alex Chiang.

Invoke pciehp_enable_slot() at startup only when pciehp_force=1.
Some HP equipment apparently cannot cope with it otherwise.

This restores the (previously working) 2.6.24 behaviour here,
while allowing machines that need a kick to use pciehp_force=1.

This was the original design back in October 2007,
but Kristen suggested we try without it first:

   Kristen Carlson Accardi wrote:
   >I think it would be ok to try allowing the slot to be enabled when not
   >using pciehp_force mode.  We can wrap it later if it proves to break things

This ended up breaking one of Alex's setups,
so it's time to put the wrapper back in now.

Signed-off-by: Mark Lord <mlord@pobox.com>
Acked-by: Alex Chiang <achiang@hp.com>
Acked-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/hotplug/pciehp_core.c~pciehp-dont-enable-slot-unless-forced drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pciehp-dont-enable-slot-unless-forced
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -467,7 +467,7 @@ static int pciehp_probe(struct pcie_devi
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 
 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
-	if (value) {
+	if (value && pciehp_force) {
 		rc = pciehp_enable_slot(t_slot);
 		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
 			value = 0;
_

Patches currently in -mm which might be from lkml@rtr.ca are

pciehp-dont-enable-slot-unless-forced.patch

