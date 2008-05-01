From: akpm@linux-foundation.org
Subject: - 68360serial-note-that-there-isnt-any-info-mcr-locking.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:20 -0700
Message-ID: <200805010928.m419SKYK030572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752AbYEAJ2l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     68360serial: Note that there isn't any info->mcr locking
has been removed from the -mm tree.  Its filename was
     68360serial-note-that-there-isnt-any-info-mcr-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 68360serial: Note that there isn't any info->mcr locking
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Noticed while auditing the code for the BKL elimination project

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/68360serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/68360serial.c~68360serial-note-that-there-isnt-any-info-mcr-locking drivers/serial/68360serial.c
--- a/drivers/serial/68360serial.c~68360serial-note-that-there-isnt-any-info-mcr-locking
+++ a/drivers/serial/68360serial.c
@@ -1282,7 +1282,7 @@ static int rs_360_tiocmset(struct tty_st
 
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
