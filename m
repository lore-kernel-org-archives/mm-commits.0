From: akpm@osdl.org
Subject: + i386-fix-memory-hotplug-related-modpost-generated-warning.patch added to -mm tree
Date: Tue, 19 Dec 2006 12:14:13 -0800
Message-ID: <200612192014.kBJKEDg4009125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944AbWLSUO1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:14:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com


The patch titled
     i386: Fix memory hotplug related MODPOST generated warning
has been added to the -mm tree.  Its filename is
     i386-fix-memory-hotplug-related-modpost-generated-warning.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
clockevents-i386-drivers.patch

