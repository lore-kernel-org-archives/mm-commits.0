From: akpm@linux-foundation.org
Subject: - vt-fix-warnings-in-selectionh.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:35 -0700
Message-ID: <200710162043.l9GKhZ46016062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935236AbXJPVHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vt: Fix warnings in selection.h
has been removed from the -mm tree.  Its filename was
     vt-fix-warnings-in-selectionh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vt: Fix warnings in selection.h
From: Ralf Baechle <ralf@linux-mips.org>

<linux/selection.h> assumes that struct tty_struct has previously been
included.  If not, this pile of warnings will result:

  CC [M]  drivers/video/console/newport_con.o
In file included from drivers/video/console/newport_con.c:18:
include/linux/selection.h:16: warning: 'struct tty_struct' declared inside param
eter list
include/linux/selection.h:16: warning: its scope is only this definition or decl
aration, which is probably not what you want
include/linux/selection.h:17: warning: 'struct tty_struct' declared inside param
eter list
include/linux/selection.h:20: warning: 'struct tty_struct' declared inside param
eter list

Fixed by adding a forward declaration of struct tty_struct.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/selection.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/selection.h~vt-fix-warnings-in-selectionh include/linux/selection.h
--- a/include/linux/selection.h~vt-fix-warnings-in-selectionh
+++ a/include/linux/selection.h
@@ -13,6 +13,7 @@
 struct tty_struct;
 
 extern struct vc_data *sel_cons;
+struct tty_struct;
 
 extern void clear_selection(void);
 extern int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *tty);
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
completely-remove-deprecated-irq-flags-sa_.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
replace-__attribute_pure__-with-__pure.patch
