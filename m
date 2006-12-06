From: akpm@osdl.org
Subject: - mtrr-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:23:53 -0800
Message-ID: <200612062223.kB6MNr6H018566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937729AbWLFWYE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:24:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan_952@hotmail.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     mtrr: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     mtrr-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mtrr: replace kmalloc+memset with kzalloc
From: "Burman Yan" <yan_952@hotmail.com>

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/mtrr/if.c   |    3 +--
 arch/i386/kernel/cpu/mtrr/main.c |    6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/if.c~mtrr-replace-kmallocmemset-with-kzalloc arch/i386/kernel/cpu/mtrr/if.c
--- a/arch/i386/kernel/cpu/mtrr/if.c~mtrr-replace-kmallocmemset-with-kzalloc
+++ a/arch/i386/kernel/cpu/mtrr/if.c
@@ -44,10 +44,9 @@ mtrr_file_add(unsigned long base, unsign
 
 	max = num_var_ranges;
 	if (fcount == NULL) {
-		fcount = kmalloc(max * sizeof *fcount, GFP_KERNEL);
+		fcount = kzalloc(max * sizeof *fcount, GFP_KERNEL);
 		if (!fcount)
 			return -ENOMEM;
-		memset(fcount, 0, max * sizeof *fcount);
 		FILE_FCOUNT(file) = fcount;
 	}
 	if (!page) {
diff -puN arch/i386/kernel/cpu/mtrr/main.c~mtrr-replace-kmallocmemset-with-kzalloc arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~mtrr-replace-kmallocmemset-with-kzalloc
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -596,10 +596,8 @@ static int mtrr_save(struct sys_device *
 	int i;
 	int size = num_var_ranges * sizeof(struct mtrr_value);
 
-	mtrr_state = kmalloc(size,GFP_ATOMIC);
-	if (mtrr_state)
-		memset(mtrr_state,0,size);
-	else
+	mtrr_state = kzalloc(size,GFP_ATOMIC);
+	if (!mtrr_state)
 		return -ENOMEM;
 
 	for (i = 0; i < num_var_ranges; i++) {
_

Patches currently in -mm which might be from yan_952@hotmail.com are

origin.patch
acpi-replace-kmallocmemset-with-kzalloc.patch
git-mtd.patch
serial-replace-kmallocmemset-with-kzalloc.patch
usb-auerswald-replace-kmallocmemset-with-kzalloc.patch
kernel-core-replace-kmallocmemset-with-kzalloc.patch
isdn-replace-kmallocmemset-with-kzalloc.patch

