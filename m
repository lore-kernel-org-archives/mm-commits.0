From: akpm@linux-foundation.org
Subject: + remove-asm-bitopsh-includes-reiser4.patch added to -mm tree
Date: Thu, 13 Sep 2007 16:40:02 -0700
Message-ID: <200709132340.l8DNe2u9011518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56761 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbXIMXkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 19:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, bunk@kernel.org


The patch titled
     Subject: [PATCH 1/2] remove asm/bitops.h includes
has been added to the -mm tree.  Its filename is
     remove-asm-bitopsh-includes-reiser4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Subject: [PATCH 1/2] remove asm/bitops.h includes
From: Jiri Slaby <jirislaby@gmail.com>

remove asm/bitops.h includes

including asm/bitops directly may cause compile errors. don't include it
and include linux/bitops instead. next patch will deny including asm header
directly.

Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 3c05eef3d0a98065323d7d6d9a78e0985eba4b10
tree cb9691832992f570b0363dd568f6fa3d2c81e3f5
parent 132bb039c741d00f066e7501e3613d2d20bf0595
author Jiri Slaby <jirislaby@gmail.com> Tue, 04 Sep 2007 21:01:35 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 04 Sep 2007 21:01:35 +0200

index 7ad84ea..32afaa3 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/jnode.h               |    2 +-
 fs/reiser4/plugin/space/bitmap.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/jnode.h~remove-asm-bitopsh-includes-reiser4 fs/reiser4/jnode.h
--- a/fs/reiser4/jnode.h~remove-asm-bitopsh-includes-reiser4
+++ a/fs/reiser4/jnode.h
@@ -21,7 +21,7 @@
 #include <linux/mm.h>
 #include <linux/spinlock.h>
 #include <asm/atomic.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 #include <linux/list.h>
 #include <linux/rcupdate.h>
 
diff -puN fs/reiser4/plugin/space/bitmap.c~remove-asm-bitopsh-includes-reiser4 fs/reiser4/plugin/space/bitmap.c
--- a/fs/reiser4/plugin/space/bitmap.c~remove-asm-bitopsh-includes-reiser4
+++ a/fs/reiser4/plugin/space/bitmap.c
@@ -171,7 +171,7 @@ static int find_next_zero_bit_in_word(ul
 	return i;
 }
 
-#include <asm/bitops.h>
+#include <linux/bitops.h>
 
 #if BITS_PER_LONG == 64
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
git-net.patch
git-wireless.patch
net-add-ath5k-wireless-driver-fix.patch
ath5k-panic-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
mxser-remove-commented-crap.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
