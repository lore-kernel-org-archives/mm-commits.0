From: akpm@linux-foundation.org
Subject: - arch-x86_64-kernel-aperturec-lower-printk-severity.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:55 -0700
Message-ID: <200707192010.l6JKAtG0020716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46114 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757280AbXGSUPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: da-x@monatomic.org, mm-commits@vger.kernel.org


The patch titled
     arch/x86_64/kernel/aperture.c: lower printk severity
has been removed from the -mm tree.  Its filename was
     arch-x86_64-kernel-aperturec-lower-printk-severity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/x86_64/kernel/aperture.c: lower printk severity
From: Dan Aloni <da-x@monatomic.org>

Users that use kernel log filtering (e.g.  via syslogd or a proprietry method)
wouldn't like to see warning prints that are not really warnings.

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/aperture.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/aperture.c~arch-x86_64-kernel-aperturec-lower-printk-severity arch/x86_64/kernel/aperture.c
--- a/arch/x86_64/kernel/aperture.c~arch-x86_64-kernel-aperturec-lower-printk-severity
+++ a/arch/x86_64/kernel/aperture.c
@@ -214,7 +214,7 @@ void __init iommu_hole_init(void) 
 	if (iommu_aperture_disabled || !fix_aperture || !early_pci_allowed())
 		return;
 
-	printk("Checking aperture...\n"); 
+	printk(KERN_INFO  "Checking aperture...\n");
 
 	fix = 0;
 	for (num = 24; num < 32; num++) {		
_

Patches currently in -mm which might be from da-x@monatomic.org are

origin.patch
drivers-acpi-pci_linkc-lower-printk-severity.patch
