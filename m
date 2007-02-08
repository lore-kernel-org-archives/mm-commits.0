From: akpm@linux-foundation.org
Subject: - math-emu-setcc-avoid-gcc-extension.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:52:55 -0800
Message-ID: <200702082152.l18LqtZT027671@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41479 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423465AbXBHVxJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@suse.de, hch@infradead.org, segher@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     math-emu/setcc: avoid gcc extension
has been removed from the -mm tree.  Its filename was
     math-emu-setcc-avoid-gcc-extension.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: math-emu/setcc: avoid gcc extension
From: Randy Dunlap <randy.dunlap@oracle.com>

setcc() in math-emu is written as a gcc extension statement expression
macro that returns a value.  However, it's not used that way and it's not
needed like that, so just make it a do-while non-extension macro so that we
don't use an extension when it's not needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/math-emu/status_w.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/i386/math-emu/status_w.h~math-emu-setcc-avoid-gcc-extension arch/i386/math-emu/status_w.h
--- a/arch/i386/math-emu/status_w.h~math-emu-setcc-avoid-gcc-extension
+++ a/arch/i386/math-emu/status_w.h
@@ -48,9 +48,11 @@
 
 #define status_word() \
   ((partial_status & ~SW_Top & 0xffff) | ((top << SW_Top_Shift) & SW_Top))
-#define setcc(cc) ({ \
-  partial_status &= ~(SW_C0|SW_C1|SW_C2|SW_C3); \
-  partial_status |= (cc) & (SW_C0|SW_C1|SW_C2|SW_C3); })
+static inline void setcc(int cc)
+{
+	partial_status &= ~(SW_C0|SW_C1|SW_C2|SW_C3);
+	partial_status |= (cc) & (SW_C0|SW_C1|SW_C2|SW_C3);
+}
 
 #ifdef PECULIAR_486
    /* Default, this conveys no information, but an 80486 does it. */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
update-readmedrm-bugzilla-7933.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
mtd-add-missing-kernel-doc-item.patch
git-ocfs2.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-misc.patch
ueagle-atmc-needs-schedh.patch
typeof-__page_to_pfn-with-sparsemem=y.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
com20020-build-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
