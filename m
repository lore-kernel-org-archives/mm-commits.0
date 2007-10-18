From: akpm@linux-foundation.org
Subject: - n_hdlcc-fix-check-after-use.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:17 -0700
Message-ID: <200710180659.l9I6xHh6030970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757006AbXJRG7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     n_hdlc.c: fix check-after-use
has been removed from the -mm tree.  Its filename was
     n_hdlcc-fix-check-after-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: n_hdlc.c: fix check-after-use
From: Adrian Bunk <bunk@kernel.org>

The Coverity checker spotted that we'd have already oops'ed if "tty"
was NULL.

Since "tty" can't be NULL when we reach this line of code this patch
removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/n_hdlc.c~n_hdlcc-fix-check-after-use drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~n_hdlcc-fix-check-after-use
+++ a/drivers/char/n_hdlc.c
@@ -229,7 +229,7 @@ static void n_hdlc_release(struct n_hdlc
 	wake_up_interruptible (&tty->read_wait);
 	wake_up_interruptible (&tty->write_wait);
 
-	if (tty != NULL && tty->disc_data == n_hdlc)
+	if (tty->disc_data == n_hdlc)
 		tty->disc_data = NULL;	/* Break the tty->n_hdlc link */
 
 	/* Release transmit and receive buffers */
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
