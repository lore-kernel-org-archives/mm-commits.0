From: akpm@linux-foundation.org
Subject: - i386-efi-fix-proc-iomem-type-for-kexec-tools.patch removed from -mm tree
Date: Wed, 23 May 2007 14:45:00 -0700
Message-ID: <200705232145.l4NLj0NH001475@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755291AbXEWVqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 17:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     i386-efi: fix /proc/iomem type for kexec-tools
has been removed from the -mm tree.  Its filename was
     i386-efi-fix-proc-iomem-type-for-kexec-tools.patch

This patch was dropped because Eric had issues

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
@@ -636,7 +636,12 @@ efi_initialize_iomem_resources(struct re
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
