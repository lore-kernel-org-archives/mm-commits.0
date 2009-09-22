From: akpm@linux-foundation.org
Subject: [merged] pcmcia-yenta-add-missing-__devexit-marking.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:56 -0700
Message-ID: <200909222043.n8MKhuup012612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752900AbZIVUoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, daniel.ritz-ml@swissonline.ch, greg@kroah.com, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     pcmcia: yenta: add missing __devexit marking
has been removed from the -mm tree.  Its filename was
     pcmcia-yenta-add-missing-__devexit-marking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: yenta: add missing __devexit marking
From: Mike Frysinger <vapier@gentoo.org>

The remove member of the pci_driver yenta_cardbus_driver uses
__devexit_p(), so the remove function itself should be marked with
__devexit.  Even more so considering the probe function is marked with
__devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/yenta_socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/yenta_socket.c~pcmcia-yenta-add-missing-__devexit-marking drivers/pcmcia/yenta_socket.c
--- a/drivers/pcmcia/yenta_socket.c~pcmcia-yenta-add-missing-__devexit-marking
+++ a/drivers/pcmcia/yenta_socket.c
@@ -717,7 +717,7 @@ static void yenta_free_resources(struct 
 /*
  * Close it down - release our resources and go home..
  */
-static void yenta_close(struct pci_dev *dev)
+static void __devexit yenta_close(struct pci_dev *dev)
 {
 	struct yenta_socket *sock = pci_get_drvdata(dev);
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch
rtc-bfin-do-not-share-rtc-irq.patch
gpio-gpio-support-for-adp5520-adp5501-mfd-pmics.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch

