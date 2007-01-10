From: akpm@osdl.org
Subject: - i386-fix-memory-hotplug-related-modpost-generated-warning.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:26 -0800
Message-ID: <200701102303.l0AN3Qh1010822@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965249AbXAJXDb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     i386: Fix memory hotplug related MODPOST generated warning
has been removed from the -mm tree.  Its filename was
     i386-fix-memory-hotplug-related-modpost-generated-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: Fix memory hotplug related MODPOST generated warning
From: Vivek Goyal <vgoyal@in.ibm.com>

o Fix modpost generated warning.

WARNING: vmlinux - Section mismatch: reference to .init.text: from .text
between 'add_one_highpage_hotplug' (at offset 0xc0113d3f) and 'online_page'

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/mm/init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/mm/init.c~i386-fix-memory-hotplug-related-modpost-generated-warning arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~i386-fix-memory-hotplug-related-modpost-generated-warning
+++ a/arch/i386/mm/init.c
@@ -285,7 +285,7 @@ void __init add_one_highpage_init(struct
 		SetPageReserved(page);
 }
 
-static int add_one_highpage_hotplug(struct page *page, unsigned long pfn)
+static int __meminit add_one_highpage_hotplug(struct page *page, unsigned long pfn)
 {
 	free_new_highpage(page);
 	totalram_pages++;
@@ -302,7 +302,7 @@ static int add_one_highpage_hotplug(stru
  * has been added dynamically that would be
  * onlined here is in HIGHMEM
  */
-void online_page(struct page *page)
+void __meminit online_page(struct page *page)
 {
 	ClearPageReserved(page);
 	add_one_highpage_hotplug(page, page_to_pfn(page));
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
pci-quirks-modpost-warning-fix.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
clockevents-i386-drivers.patch
