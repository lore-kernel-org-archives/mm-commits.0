From: akpm@linux-foundation.org
Subject: [folded] ldisc-n_tty-add-new-method-n_tty_inherit_ops-update.patch removed from -mm tree
Date: Wed, 10 Mar 2010 15:05:56 -0800
Message-ID: <201003102305.o2AN5uLp009263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932854Ab0CJXGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 18:06:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, lasaine@lvk.cs.msu.su, mm-commits@vger.kernel.org


The patch titled
     ldisc-n_tty-add-new-method-n_tty_inherit_ops-update
has been removed from the -mm tree.  Its filename was
     ldisc-n_tty-add-new-method-n_tty_inherit_ops-update.patch

This patch was dropped because it was folded into ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ldisc-n_tty-add-new-method-n_tty_inherit_ops-update
From: Rodolfo Giometti <giometti@linux.it>

This new method can be used to init a new struct tty_ldisc_ops as the
default tty_ldisc_N_TTY struct.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/char/n_tty.c~ldisc-n_tty-add-new-method-n_tty_inherit_ops-update drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~ldisc-n_tty-add-new-method-n_tty_inherit_ops-update
+++ a/drivers/char/n_tty.c
@@ -2093,6 +2093,14 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.write_wakeup    = n_tty_write_wakeup
 };
 
+/**
+ *	n_tty_inherit_ops	-	inherit N_TTY methods
+ *	@ops: struct tty_ldisc_ops where to save N_TTY methods
+ *
+ *	Used by a generic struct tty_ldisc_ops to easily inherit N_TTY
+ *	methods.
+ */
+
 void n_tty_inherit_ops(struct tty_ldisc_ops *ops)
 {
 	*ops = tty_ldisc_N_TTY;
_

Patches currently in -mm which might be from giometti@linux.it are

pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch
ldisc-n_tty-add-new-method-n_tty_inherit_ops-update.patch
pps-serial-clients-support.patch
pps-serial-clients-support-warning-fixes.patch
serial-8250-enable-pps-support.patch
serial-amba-pl010-enable-pps-support.patch

