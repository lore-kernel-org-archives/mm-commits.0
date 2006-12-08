From: akpm@osdl.org
Subject: - tty-switch-to-ktermios-sclp-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:54:56 -0800
Message-ID: <200612080854.kB88suS1014083@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37561 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425243AbWLHIza (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:55:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mp3@de.ibm.com, alan@redhat.com, cornelia.huck@de.ibm.com, oberpar@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tty-switch-to-ktermios sclp fix
has been removed from the -mm tree.  Its filename was
     tty-switch-to-ktermios-sclp-fix.patch

This patch was dropped because it was folded into tty-switch-to-ktermios.patch

------------------------------------------------------
Subject: tty-switch-to-ktermios sclp fix
From: Martin Peschke <mp3@de.ibm.com>

Extern declaration of tty_std_termios in sclp_tty was a hack
which is obsolete.

  CC      drivers/s390/char/sclp_tty.o
drivers/s390/char/sclp_tty.c:63: error: conflicting types for 'tty_std_termios'
include/linux/tty.h:261: error: previous declaration of 'tty_std_termios' was here
drivers/s390/char/sclp_tty.c: In function 'sclp_tty_init':
drivers/s390/char/sclp_tty.c:790: error: incompatible types in assignment
make[2]: *** [drivers/s390/char/sclp_tty.o] Error 1
make[1]: *** [drivers/s390/char] Error 2
make: *** [drivers/s390] Error 2
Kernel compilation...FAILED

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Acked-by: Peter Oberparleiter <oberpar@de.ibm.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/s390/char/sclp_tty.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/s390/char/sclp_tty.c~tty-switch-to-ktermios-sclp-fix drivers/s390/char/sclp_tty.c
--- a/drivers/s390/char/sclp_tty.c~tty-switch-to-ktermios-sclp-fix
+++ a/drivers/s390/char/sclp_tty.c
@@ -60,8 +60,6 @@ static unsigned short int sclp_tty_chars
 
 struct tty_driver *sclp_tty_driver;
 
-extern struct termios  tty_std_termios;
-
 static struct sclp_ioctls sclp_ioctls;
 static struct sclp_ioctls sclp_ioctls_init =
 {
_

Patches currently in -mm which might be from mp3@de.ibm.com are

tty-switch-to-ktermios.patch
tty-switch-to-ktermios-sclp-fix.patch
tty-switch-to-ktermios-3270-fix.patch

