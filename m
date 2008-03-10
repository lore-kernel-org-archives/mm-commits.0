From: akpm@linux-foundation.org
Subject: + pci-fix-small-mem-leak-in-ibm-hot-plug-controller-driver.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:01:59 -0700
Message-ID: <200803101901.m2AJ1xh9000475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbYCJTCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, greg@kroah.com, kristen.c.accardi@intel.com


The patch titled
     pci: fix small mem leak in IBM Hot Plug Controller Driver
has been added to the -mm tree.  Its filename is
     pci-fix-small-mem-leak-in-ibm-hot-plug-controller-driver.patch

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
Subject: pci: fix small mem leak in IBM Hot Plug Controller Driver
From: Jesper Juhl <jesper.juhl@gmail.com>

In drivers/pci/hotplug/ibmphp_ebda.c::ebda_rsrc_controller(), storage is
allocated with kzalloc() and assigned to 'tmp_slot'.  Then lots of stuff, like
->flag, ->supported_speed etc is set in tmp_slot.  A bit further down there's
then this test :

  if (!bus_info_ptr1) {
    rc = -ENODEV;
    goto error;
  }

At this point, tmp_slot has not been assigned to anything, so when
erroring-out we want to free it, but nothing at the 'error:' label free's
'tmp_slot' - and we can't really free 'tmp_slot' at 'error:' since we may jump
to that label later when 'tmp_slot' *has* been used and we do not want it
freed.  So, the only sane option left seems to be to kfree(tmp_slot) just
before jumping to the 'error:' label in the one place where this is what
actually makes sense.  The following patch does just that and thus kills off a
tiny potential memory leak.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_ebda.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/hotplug/ibmphp_ebda.c~pci-fix-small-mem-leak-in-ibm-hot-plug-controller-driver drivers/pci/hotplug/ibmphp_ebda.c
--- a/drivers/pci/hotplug/ibmphp_ebda.c~pci-fix-small-mem-leak-in-ibm-hot-plug-controller-driver
+++ a/drivers/pci/hotplug/ibmphp_ebda.c
@@ -963,6 +963,7 @@ static int __init ebda_rsrc_controller (
 
 			bus_info_ptr1 = ibmphp_find_same_bus_num (hpc_ptr->slots[index].slot_bus_num);
 			if (!bus_info_ptr1) {
+				kfree(tmp_slot);
 				rc = -ENODEV;
 				goto error;
 			}
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

pci-fix-small-mem-leak-in-ibm-hot-plug-controller-driver.patch

