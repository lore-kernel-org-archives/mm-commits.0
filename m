From: akpm@linux-foundation.org
Subject: + compat32-ignore-the-loop_clr_fd-ioctl.patch added to -mm tree
Date: Fri, 06 Jul 2007 15:44:48 -0700
Message-ID: <200707062244.l66MimBV024834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48917 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbXGFWqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 18:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, arnd@arndb.de


The patch titled
     compat32: ignore the LOOP_CLR_FD ioctl
has been added to the -mm tree.  Its filename is
     compat32-ignore-the-loop_clr_fd-ioctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: compat32: ignore the LOOP_CLR_FD ioctl
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

compat32: Ignore the LOOP_CLR_FD ioctl for the loop block device, to kill an
annoying kernel message when e.g. busybox umount is used.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN fs/compat_ioctl.c~compat32-ignore-the-loop_clr_fd-ioctl fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat32-ignore-the-loop_clr_fd-ioctl
+++ a/fs/compat_ioctl.c
@@ -63,6 +63,7 @@
 #include <linux/wireless.h>
 #include <linux/atalk.h>
 #include <linux/blktrace_api.h>
+#include <linux/loop.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci.h>
@@ -3489,6 +3490,9 @@ HANDLE_IOCTL(LPSETTIMEOUT, lp_timeout_tr
 
 IGNORE_IOCTL(VFAT_IOCTL_READDIR_BOTH32)
 IGNORE_IOCTL(VFAT_IOCTL_READDIR_SHORT32)
+
+/* loop */
+IGNORE_IOCTL(LOOP_CLR_FD)
 };
 
 #define IOCTL_HASHSIZE 256
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
git-netdev-all.patch
update-documentation-block-barriertxt.patch
compat32-ignore-the-loop_clr_fd-ioctl.patch
