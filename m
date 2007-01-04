From: akpm@osdl.org
Subject: - i386-move-startup_32-in-texthead-section-specify-section-flags-while-creating-new-sections.patch removed from -mm tree
Date: Thu, 04 Jan 2007 14:18:07 -0800
Message-ID: <200701042218.l04MI8dR000611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:58922 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965103AbXADWS3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:18:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     i386: specify section flags while creating new sections
has been removed from the -mm tree.  Its filename was
     i386-move-startup_32-in-texthead-section-specify-section-flags-while-creating-new-sections.patch

This patch was dropped because it was folded into i386-move-startup_32-in-texthead-section.patch

------------------------------------------------------
Subject: i386: specify section flags while creating new sections
From: Vivek Goyal <vgoyal@in.ibm.com>

o Older binutils (older than 2.6.15) require explicit flags to be set
  for section. (if a section has been defined using "section" directive).
  Otherwise a section which should have been allocatable and executable
  (AX) will not have properties as per intention.

o I had put a patch in -mm which will break the things if used with
  older binutils. Hence this is the fix on top of that patch.

http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc2/2.6.20-rc2-mm1/broken-out/i386-move-startup_32-in-texthead-section.patch

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/head.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/head.S~i386-move-startup_32-in-texthead-section-specify-section-flags-while-creating-new-sections arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~i386-move-startup_32-in-texthead-section-specify-section-flags-while-creating-new-sections
+++ a/arch/i386/kernel/head.S
@@ -53,7 +53,7 @@
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
-.section .text.head
+.section .text.head,"ax",@progbits
 ENTRY(startup_32)
 
 #ifdef CONFIG_PARAVIRT
@@ -155,9 +155,9 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
  */
 
 #ifdef CONFIG_HOTPLUG_CPU
-.section .text
+.section .text,"ax",@progbits
 #else
-.section .init.text
+.section .init.text,"ax",@progbits
 #endif
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

origin.patch
i386-restore-config_physical_start-option.patch
i386-fix-modpost-warning-in-smp-trampoline-code.patch
i386-fix-another-modpost-warning.patch
i386-modpost-smpboot-code-warning-fix.patch
i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
i386-move-startup_32-in-texthead-section-specify-section-flags-while-creating-new-sections.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
clockevents-i386-drivers.patch
