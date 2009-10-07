From: akpm@linux-foundation.org
Subject: [alternative-merged] input-serio_libps2-depends-on-serio_i8042.patch removed from -mm tree
Date: Wed, 07 Oct 2009 15:10:43 -0700
Message-ID: <200910072210.n97MAhhj023539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbZJGWL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2009 18:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: serio_libps2 depends on serio_i8042
has been removed from the -mm tree.  Its filename was
     input-serio_libps2-depends-on-serio_i8042.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: serio_libps2 depends on serio_i8042
From: Randy Dunlap <randy.dunlap@oracle.com>

SERIO_LIBPS2 code uses SERIO_I8042 code, so the former needs to depend on
the latter.

(.text+0x1f33ca): undefined reference to `i8042_check_port_owner'
(.text+0x1f33de): undefined reference to `i8042_unlock_chip'
(.text+0x1f3435): undefined reference to `i8042_check_port_owner'
(.text+0x1f3449): undefined reference to `i8042_lock_chip

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/serio/Kconfig~input-serio_libps2-depends-on-serio_i8042 drivers/input/serio/Kconfig
--- a/drivers/input/serio/Kconfig~input-serio_libps2-depends-on-serio_i8042
+++ a/drivers/input/serio/Kconfig
@@ -168,6 +168,7 @@ config SERIO_MACEPS2
 
 config SERIO_LIBPS2
 	tristate "PS/2 driver library" if EMBEDDED
+	depends on SERIO_I8042
 	help
 	  Say Y here if you are using a driver for device connected
 	  to a PS/2 port, such as PS/2 mouse or standard AT keyboard.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
input-serio_libps2-depends-on-serio_i8042.patch
scsi-fix-func-names-in-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch

