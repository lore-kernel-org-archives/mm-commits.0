From: akpm@linux-foundation.org
Subject: + drivers-tty-vt-vt_ioctlc-fix-kdfontop-32bit-compatibility-layer.patch added to -mm tree
Date: Mon, 30 Jan 2012 13:08:11 -0800
Message-ID: <20120130210811.C036FA00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:60125 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2A3VIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 16:08:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, arnd@arndb.de, art@ified.ca, gregkh@suse.de, jolsa@redhat.com, jslaby@suse.cz, stable@vger.kernel.org


The patch titled
     Subject: drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer
has been added to the -mm tree.  Its filename is
     drivers-tty-vt-vt_ioctlc-fix-kdfontop-32bit-compatibility-layer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer

KDFONTOP(GET) currently fails with EIO when being run in a 32bit userland
with a 64bit kernel if the font width is not 8.

This is because the compatibility layer introduced by e9216651 ("tty:
handle VT specific compat ioctls in vt driver") forces the addition of the
KD_FONT_FLAG_OLD flag, which makes con_font_get return EIO in such case. 

This flag should *not* be set for KDFONTOP, since it's actually the whole
point of this flag (see comment in con_font_set for instance).

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Arnd Bergmann <arnd@arndb.de>
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
Subject: Subject: drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

drivers-tty-vt-vt_ioctlc-fix-kdfontop-32bit-compatibility-layer.patch

