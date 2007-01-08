From: akpm@osdl.org
Subject: + math-emu-setcc-avoid-gcc-extension.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:47:39 -0800
Message-ID: <200701082347.l08Nldxf023080@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55330 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbXAHXsU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:48:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ak@suse.de, hch@infradead.org, segher@kernel.crashing.org


The patch titled
     math-emu/setcc: avoid gcc extension
has been added to the -mm tree.  Its filename is
     math-emu-setcc-avoid-gcc-extension.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/math-emu/status_w.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

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

git-alsa.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-rc-fixes.patch
megaraid-fix-kernel-doc.patch
math-emu-setcc-avoid-gcc-extension.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-showblockedtasks-is-sysrq-w.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch
