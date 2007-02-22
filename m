From: akpm@linux-foundation.org
Subject: + tty-clarify-documentation-of-write.patch added to -mm tree
Date: Wed, 21 Feb 2007 17:11:07 -0800
Message-ID: <200702220111.l1M1B79n032498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60844 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbXBVBLS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 20:11:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     tty: Clarify documentation of ->write()
has been added to the -mm tree.  Its filename is
     tty-clarify-documentation-of-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 insertions(+), 1 deletion(-)

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

git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
add-id_to_dma_mode-function-for-printing-dma-modes.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
adjust-legacy-ide-resource-setting-v2.patch
resend-iphase-64bit-cleanup.patch
serial-serial_txx9-driver-update.patch
serial-serial_txx9-driver-update-fix.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
