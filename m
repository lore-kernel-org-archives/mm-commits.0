From: akpm@linux-foundation.org
Subject: + drivers-misc-spear13xx_pcie_gadgetc-fix-a-memory-leak-in-spear_pcie_gadget_probe-error-path.patch added to -mm tree
Date: Fri, 03 Jun 2011 15:16:29 -0700
Message-ID: <201106032216.p53MGTjZ010688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516Ab1FCWRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 18:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, pratyush.anand@st.com


The patch titled
     drivers/misc/spear13xx_pcie_gadget.c: fix a memory leak in spear_pcie_gadget_probe error path
has been added to the -mm tree.  Its filename is
     drivers-misc-spear13xx_pcie_gadgetc-fix-a-memory-leak-in-spear_pcie_gadget_probe-error-path.patch

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
Subject: drivers/misc/spear13xx_pcie_gadget.c: fix a memory leak in spear_pcie_gadget_probe error path
From: Axel Lin <axel.lin@gmail.com>

In the case of goto err_kzalloc, we should kfree target.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/spear13xx_pcie_gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/spear13xx_pcie_gadget.c~drivers-misc-spear13xx_pcie_gadgetc-fix-a-memory-leak-in-spear_pcie_gadget_probe-error-path drivers/misc/spear13xx_pcie_gadget.c
--- a/drivers/misc/spear13xx_pcie_gadget.c~drivers-misc-spear13xx_pcie_gadgetc-fix-a-memory-leak-in-spear_pcie_gadget_probe-error-path
+++ a/drivers/misc/spear13xx_pcie_gadget.c
@@ -845,7 +845,7 @@ err_iounmap:
 err_iounmap_app:
 	iounmap(config->va_app_base);
 err_kzalloc:
-	kfree(config);
+	kfree(target);
 err_rel_res:
 	release_mem_region(res1->start, resource_size(res1));
 err_rel_res0:
_

Patches currently in -mm which might be from axel.lin@gmail.com are

drivers-misc-spear13xx_pcie_gadgetc-fix-a-memory-leak-in-spear_pcie_gadget_probe-error-path.patch
linux-next.patch

