From: akpm@linux-foundation.org
Subject: - linux-serialh-touchup-for-userspace.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:59 -0800
Message-ID: <200812070005.mB705xoS021720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611AbYLGAGI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:06:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     linux/serial.h: touchup for userspace
has been removed from the -mm tree.  Its filename was
     linux-serialh-touchup-for-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux/serial.h: touchup for userspace
From: Mike Frysinger <vapier@gentoo.org>

Commit c26c56c0f40e200e61d1390629c806f6adaffbcc ("tty: Cris has a nice
RS485 ioctl so we should steal it") added a struct to the linux/serial.h
header for userspace that uses __u32, so we should make sure we pull in
linux/types.h all the time.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/serial.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/serial.h~linux-serialh-touchup-for-userspace include/linux/serial.h
--- a/include/linux/serial.h~linux-serialh-touchup-for-userspace
+++ a/include/linux/serial.h
@@ -10,8 +10,9 @@
 #ifndef _LINUX_SERIAL_H
 #define _LINUX_SERIAL_H
 
-#ifdef __KERNEL__
 #include <linux/types.h>
+
+#ifdef __KERNEL__
 #include <asm/page.h>
 
 /*
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
linux-timexh-cleanup-for-userspace.patch
mtd-physmap-make-physmap-compat-explicit.patch
autodetect_raid-add-missing-__init-marking.patch

