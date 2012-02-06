From: akpm@linux-foundation.org
Subject: [merged] drivers-tty-vt-vt_ioctlc-fix-kdfontop-32bit-compatibility-layer.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:29 -0800
Message-ID: <20120206203129.809F0A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33821 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2BFUba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, arnd@arndb.de, art@ified.ca, gregkh@suse.de, jolsa@redhat.com, jslaby@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer
has been removed from the -mm tree.  Its filename was
     drivers-tty-vt-vt_ioctlc-fix-kdfontop-32bit-compatibility-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer

KDFONTOP(GET) currently fails with EIO when being run in a 32bit userland
with a 64bit kernel if the font width is not 8.

This is because of the setting of the KD_FONT_FLAG_OLD flag, which makes
con_font_get return EIO in such case.  

This flag should *not* be set for KDFONTOP, since it's actually the whole
point of this flag (see comment in con_font_set for instance).

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arthur Taylor <art@ified.ca>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/vt_ioctl.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/tty/vt/vt_ioctl.c~drivers-tty-vt-vt_ioctlc-fix-kdfontop-32bit-compatibility-layer drivers/tty/vt/vt_ioctl.c
--- a/drivers/tty/vt/vt_ioctl.c~drivers-tty-vt-vt_ioctlc-fix-kdfontop-32bit-compatibility-layer
+++ a/drivers/tty/vt/vt_ioctl.c
@@ -1463,7 +1463,6 @@ compat_kdfontop_ioctl(struct compat_cons
 	if (!perm && op->op != KD_FONT_OP_GET)
 		return -EPERM;
 	op->data = compat_ptr(((struct compat_console_font_op *)op)->data);
-	op->flags |= KD_FONT_FLAG_OLD;
 	i = con_font_op(vc, op);
 	if (i)
 		return i;
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch
linux-next.patch

