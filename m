From: akpm@linux-foundation.org
Subject: - hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:25 -0700
Message-ID: <200808042007.m74K7PIk027782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762011AbYHDUIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:08:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     hysdn: remove the packed attribute from PofTimStamp_tag
has been removed from the -mm tree.  Its filename was
     hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hysdn: remove the packed attribute from PofTimStamp_tag
From: David Howells <dhowells@redhat.com>

Remove the packed attribute from PofTimStamp_tag in the hysdn driver as the
thing being packed is just an array of chars and so is unpackable.

This deals with a compiler warning:

In file included from drivers/isdn/hysdn/hysdn_boot.c:19:
drivers/isdn/hysdn/hysdn_pof.h:63: warning: 'packed' attribute ignored for field of type 'unsigned char[40]'

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hysdn/hysdn_pof.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hysdn/hysdn_pof.h~hysdn-remove-the-packed-attribute-from-poftimstamp_tag drivers/isdn/hysdn/hysdn_pof.h
--- a/drivers/isdn/hysdn/hysdn_pof.h~hysdn-remove-the-packed-attribute-from-poftimstamp_tag
+++ a/drivers/isdn/hysdn/hysdn_pof.h
@@ -60,7 +60,7 @@ typedef struct PofRecHdr_tag {	/* Pof re
 
 typedef struct PofTimeStamp_tag {
 /*00 */ unsigned long UnixTime __attribute__((packed));
-	/*04 */ unsigned char DateTimeText[0x28] __attribute__((packed));
+	/*04 */ unsigned char DateTimeText[0x28];
 	/* =40 */
 /*2C */
 } tPofTimeStamp;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
mutex-subsystem-synchro-test-module.patch

