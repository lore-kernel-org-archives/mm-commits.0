From: akpm@linux-foundation.org
Subject: + vt-declare-pio_cmap-gio_cmap-as-compatbile-ioctls.patch added to -mm tree
Date: Sun, 15 Feb 2009 13:42:19 -0800
Message-ID: <200902152142.n1FLgJi9023833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844AbZBOVmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 15 Feb 2009 16:42:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: notting@redhat.com, alan@lxorguk.ukuu.org.uk, jkosina@suse.cz, stable@kernel.org


The patch titled
     vt: Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
has been added to the -mm tree.  Its filename is
     vt-declare-pio_cmap-gio_cmap-as-compatbile-ioctls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
From: Bill Nottingham <notting@redhat.com>

Otherwise, these don't work when called from 32-bit userspace on 64-bit
kernels.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/compat_ioctl.c~vt-declare-pio_cmap-gio_cmap-as-compatbile-ioctls fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~vt-declare-pio_cmap-gio_cmap-as-compatbile-ioctls
+++ a/fs/compat_ioctl.c
@@ -1865,6 +1865,8 @@ ULONG_IOCTL(SET_BITMAP_FILE)
 /* Big K */
 COMPATIBLE_IOCTL(PIO_FONT)
 COMPATIBLE_IOCTL(GIO_FONT)
+COMPATIBLE_IOCTL(PIO_CMAP)
+COMPATIBLE_IOCTL(GIO_CMAP)
 ULONG_IOCTL(KDSIGACCEPT)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
_

Patches currently in -mm which might be from notting@redhat.com are

vt-declare-pio_cmap-gio_cmap-as-compatbile-ioctls.patch

