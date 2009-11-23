From: akpm@linux-foundation.org
Subject: + fix-section-mismatch-in-early-ehci-dbgp.patch added to -mm tree
Date: Mon, 23 Nov 2009 14:48:40 -0800
Message-ID: <200911232248.nANMmeUD026802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608AbZKWWsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 17:48:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, greg@kroah.com, jason.wessel@windriver.com, jbeulich@novell.com


The patch titled
     usb: fix section mismatch in early ehci dbgp
has been added to the -mm tree.  Its filename is
     fix-section-mismatch-in-early-ehci-dbgp.patch

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
Subject: usb: fix section mismatch in early ehci dbgp
From: "Jan Beulich" <JBeulich@novell.com>

Commit 917778267fbe67703ab7d5c6f0b7a05d4c3df485 ("USB: ehci-dbgp:
stability improvements and external re-init") removed __init from
ehci_wait_for_port(), but left it in place on ehci_reset_port(), which is
being called from the former function.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/early/ehci-dbgp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/early/ehci-dbgp.c~fix-section-mismatch-in-early-ehci-dbgp drivers/usb/early/ehci-dbgp.c
--- a/drivers/usb/early/ehci-dbgp.c~fix-section-mismatch-in-early-ehci-dbgp
+++ a/drivers/usb/early/ehci-dbgp.c
@@ -613,7 +613,7 @@ err:
 }
 EXPORT_SYMBOL_GPL(dbgp_external_startup);
 
-static int __init ehci_reset_port(int port)
+static int ehci_reset_port(int port)
 {
 	u32 portsc;
 	u32 delay_time, delay;
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
kbuild-generate-modulesbuiltin-fix-2.patch
fix-section-mismatch-in-early-ehci-dbgp.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
mm-bootmemc-properly-__init-annotate-helper-functions.patch
dma-mapping-fix-off-by-one-error-in-dma_capable.patch

