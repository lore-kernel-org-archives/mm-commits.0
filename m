From: akpm@linux-foundation.org
Subject: + i386-efi-fix-proc-iomem-type-for-kexec-tools.patch added to -mm tree
Date: Wed, 25 Apr 2007 18:38:11 -0700
Message-ID: <200704260138.l3Q1cBFi018112@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173AbXDZBjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas@m3y3r.de, ak@suse.de, ebiederm@xmission.com


The patch titled
     i386-efi: fix /proc/iomem type for kexec-tools
has been added to the -mm tree.  Its filename is
     i386-efi-fix-proc-iomem-type-for-kexec-tools.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386-efi: fix /proc/iomem type for kexec-tools
From: Thomas Meyer <thomas@m3y3r.de>

The kexec-tools check for "System RAM".

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/efi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/efi.c~i386-efi-fix-proc-iomem-type-for-kexec-tools arch/i386/kernel/efi.c
--- a/arch/i386/kernel/efi.c~i386-efi-fix-proc-iomem-type-for-kexec-tools
+++ a/arch/i386/kernel/efi.c
@@ -638,7 +638,12 @@ efi_initialize_iomem_resources(struct re
 			res->name = "Runtime Service Data";
 			break;
 		case EFI_CONVENTIONAL_MEMORY:
-			res->name = "Conventional Memory";
+			if (md->attribute & EFI_MEMORY_WP) {
+				res->name = "System ROM";
+				res->flags |= IORESOURCE_READONLY;
+			} else {
+				res->name = "System RAM";
+			}
 			break;
 		case EFI_UNUSABLE_MEMORY:
 			res->name = "Unusable Memory";
_

Patches currently in -mm which might be from thomas@m3y3r.de are

i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
