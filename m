From: akpm@linux-foundation.org
Subject: - tty-clarify-documentation-of-write.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:41 -0700
Message-ID: <200705090244.l492ifEV008615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194AbXEICow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty: Clarify documentation of ->write()
has been removed from the -mm tree.  Its filename was
     tty-clarify-documentation-of-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: Clarify documentation of ->write()
From: Alan <alan@lxorguk.ukuu.org.uk>

The tty driver write method is different to the usual fops device write
methods as the buffer is already in kernel space. Clarify the docs since
someone writing a driver made that mistake.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/tty.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/tty.txt~tty-clarify-documentation-of-write Documentation/tty.txt
--- a/Documentation/tty.txt~tty-clarify-documentation-of-write
+++ a/Documentation/tty.txt
@@ -108,7 +108,9 @@ hardware driver through the function poi
 structure:
 
 write()			Write a block of characters to the tty device.
-			Returns the number of characters accepted.
+			Returns the number of characters accepted. The
+			character buffer passed to this method is already
+			in kernel space.
 
 put_char()		Queues a character for writing to the tty device.
 			If there is no room in the queue, the character is
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-pata_qdic-probe-code.patch
pata_scc-fix-compilation.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
upper-32-bits.patch
tty_set_ldisc-receive_room-fix.patch
tty-add-compat_ioctl.patch
tty-add-compat_ioctl-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
