From: akpm@linux-foundation.org
Subject: [merged] vt-declare-pio_cmap-gio_cmap-as-compatbile-ioctls.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:17 -0800
Message-ID: <200902191917.n1JJHHA7016363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192AbZBSTRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: notting@redhat.com, alan@lxorguk.ukuu.org.uk, jkosina@suse.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vt: Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
has been removed from the -mm tree.  Its filename was
     vt-declare-pio_cmap-gio_cmap-as-compatbile-ioctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1938,6 +1938,8 @@ ULONG_IOCTL(SET_BITMAP_FILE)
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

origin.patch

