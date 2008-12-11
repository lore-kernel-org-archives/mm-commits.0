From: akpm@linux-foundation.org
Subject: + ibmphp-fix-module-ref-count-underflow.patch added to -mm tree
Date: Thu, 11 Dec 2008 14:52:14 -0800
Message-ID: <200812112252.mBBMqEKA021924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767AbYLKWxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 17:53:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, gregkh@suse.de, jbarnes@virtuousgeek.org


The patch titled
     ibmphp: fix module ref count underflow
has been added to the -mm tree.  Its filename is
     ibmphp-fix-module-ref-count-underflow.patch

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
Subject: ibmphp: fix module ref count underflow
From: Neil Horman <nhorman@tuxdriver.com>

The ibmphp hotplug driver does something rather silly in its init routine.
It purposely calls module_put so as to underflow its module ref count to
avoid being removed from the kernel.

This is bad practice, and wrong, since it provides a window for subsequent
module_gets to reset the refcount to zero, allowing an unload to race in
and cause all sorts of mysterious panics.  If the module is unsafe to
load, it should inform the kernel as such with a call to __unsafe.  The
patch does that.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/pci/hotplug/ibmphp_core.c~ibmphp-fix-module-ref-count-underflow drivers/pci/hotplug/ibmphp_core.c
--- a/drivers/pci/hotplug/ibmphp_core.c~ibmphp-fix-module-ref-count-underflow
+++ a/drivers/pci/hotplug/ibmphp_core.c
@@ -1402,9 +1402,11 @@ static int __init ibmphp_init(void)
 		goto error;
 	}
 
-	/* lock ourselves into memory with a module 
-	 * count of -1 so that no one can unload us. */
-	module_put(THIS_MODULE);
+	/*
+	 * Its unsafe to unload this module, so tell
+	 * the kernel to avoid inadvertent unloads
+	 */
+	__unsafe(THIS_MODULE);
 
 exit:
 	return rc;
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
ibmphp-fix-module-ref-count-underflow.patch

