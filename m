From: akpm@linux-foundation.org
Subject: + 3c59x-handle-pci_name-being-const.patch added to -mm tree
Date: Wed, 02 Jul 2008 16:19:32 -0700
Message-ID: <200807022319.m62NJe80008918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbYGBXTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 19:19:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gregkh@suse.de, klassert@mathematik.tu-chemnitz.de


The patch titled
     3c59x: handle pci_name() being const
has been added to the -mm tree.  Its filename is
     3c59x-handle-pci_name-being-const.patch

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
Subject: 3c59x: handle pci_name() being const
From: Greg Kroah-Hartman <gregkh@suse.de>

This changes vortex_prob1() to handle pci_name() now returning a constant
string.

Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/3c59x.c~3c59x-handle-pci_name-being-const drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3c59x-handle-pci_name-being-const
+++ a/drivers/net/3c59x.c
@@ -1010,7 +1010,7 @@ static int __devinit vortex_probe1(struc
 	static int printed_version;
 	int retval, print_info;
 	struct vortex_chip_info * const vci = &vortex_info_tbl[chip_idx];
-	char *print_name = "3c59x";
+	const char *print_name = "3c59x";
 	struct pci_dev *pdev = NULL;
 	struct eisa_device *edev = NULL;
 	DECLARE_MAC_BUF(mac);
_

Patches currently in -mm which might be from gregkh@suse.de are

sisusbvga-fix-oops-on-disconnect.patch
linux-next.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
usb-fix-possible-memory-leak-in-pxa27x_udc.patch
hugetlb-new-sysfs-interface.patch
checkpatch-usb_free_urb-can-take-null.patch
firmware-use-memory_read_from_buffer.patch
edac-core-fix-to-use-dynamic-kobject.patch
mtd-handle-pci_name-being-const.patch
pci-handle-pci_name-being-const.patch
3c59x-handle-pci_name-being-const.patch
usb-handle-pci_name-being-const.patch

