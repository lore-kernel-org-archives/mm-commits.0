From: akpm@linux-foundation.org
Subject: [merged] drivers-char-amiserialc-remove-unused-variable-icount.patch removed from -mm tree
Date: Fri, 12 Nov 2010 10:32:17 -0800
Message-ID: <201011121834.oACIYuRL024910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756789Ab0KLSfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 13:35:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/amiserial.c: remove unused variable icount
has been removed from the -mm tree.  Its filename was
     drivers-char-amiserialc-remove-unused-variable-icount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/amiserial.c: remove unused variable icount
From: Geert Uytterhoeven <geert@linux-m68k.org>

drivers/char/amiserial.c: In function `rs_ioctl':
drivers/char/amiserial.c:1302: warning: unused variable `icount'

commit 0587102cf9f427c185bfdeb2cef41e13ee0264b1 ("tty: icount changeover
for other main devices") removed the users, but not the actual variable.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/amiserial.c~drivers-char-amiserialc-remove-unused-variable-icount drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~drivers-char-amiserialc-remove-unused-variable-icount
+++ a/drivers/char/amiserial.c
@@ -1299,7 +1299,6 @@ static int rs_ioctl(struct tty_struct *t
 {
 	struct async_struct * info = tty->driver_data;
 	struct async_icount cprev, cnow;	/* kernel counter temps */
-	struct serial_icounter_struct icount;
 	void __user *argp = (void __user *)arg;
 	unsigned long flags;
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
drivers-macintosh-adb-iopc-flags-should-be-unsigned-long.patch
kernel-range-fix-clean_sort_range-for-the-case-of-full-array.patch
linux-next.patch

