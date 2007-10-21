From: akpm@linux-foundation.org
Subject: - remove-asm-bitopsh-includes-reiser4.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:57 -0700
Message-ID: <200710212347.l9LNlv1j000685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55062 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbXJUXzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH 1/2] remove asm/bitops.h includes
has been removed from the -mm tree.  Its filename was
     remove-asm-bitopsh-includes-reiser4.patch

This patch was dropped because it was folded into reiser4.patch

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

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
reiser4.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
