From: akpm@linux-foundation.org
Subject: - viocons-bkl-locking.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:13 -0700
Message-ID: <200805010928.m419SD0e030562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757341AbYEAJ2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, paulus@samba.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     viocons: BKL locking
has been removed from the -mm tree.  Its filename was
     viocons-bkl-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viocons: BKL locking
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

For some weird reason I can't ascertain (translation "I think its
broken") the viocons driver calls directly into the n_tty ldisc code even
if another ldisc is in use. It'll probably break if you do that but I'm
just fixing the locking and adding a comment that its horked.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/viocons.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/char/viocons.c~viocons-bkl-locking drivers/char/viocons.c
--- a/drivers/char/viocons.c~viocons-bkl-locking
+++ a/drivers/char/viocons.c
@@ -704,8 +704,11 @@ static int viotty_ioctl(struct tty_struc
 	case KDSKBLED:
 		return 0;
 	}
