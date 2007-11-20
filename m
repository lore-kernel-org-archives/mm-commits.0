From: akpm@linux-foundation.org
Subject: + tty-let-architectures-override-the-user-kernel-macros.patch added to -mm tree
Date: Mon, 19 Nov 2007 23:02:11 -0800
Message-ID: <200711200702.lAK72BFj019151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756480AbXKTHCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 02:02:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hskinnemoen@atmel.com, paulus@samba.org, schwidefsky@de.ibm.com


The patch titled
     tty: let architectures override the user/kernel macros.
has been added to the -mm tree.  Its filename is
     tty-let-architectures-override-the-user-kernel-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: let architectures override the user/kernel macros.
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Give architectures that support the new termios2 the possibilty to overide the
user_termios_to_kernel_termios and kernel_termios_to_user_termios macros.  As
soon as all architectures that use the generic variant have been converted the
ifdefs can go away again.  Architectures in question are avr32, frv, powerpc
and s390.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/termios.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/asm-generic/termios.h~tty-let-architectures-override-the-user-kernel-macros include/asm-generic/termios.h
--- a/include/asm-generic/termios.h~tty-let-architectures-override-the-user-kernel-macros
+++ a/include/asm-generic/termios.h
@@ -61,8 +61,14 @@ static inline int kernel_termios_to_user
 	return 0;
 }
 
+#ifndef user_termios_to_kernel_termios
 #define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
+#endif
+
+#ifndef kernel_termios_to_user_termios
 #define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#endif
+
 #define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
 #define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

git-s390.patch
taskstats-scaled-time-cleanup.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
tty-add-the-new-termios2-ioctls-to-the-compatible.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
