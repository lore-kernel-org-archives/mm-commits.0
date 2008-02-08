From: akpm@linux-foundation.org
Subject: - rocket-dont-let-random-users-reset-the-controller.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:42 -0800
Message-ID: <200802082012.m18KCNUq010197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbYBHUry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:47:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     rocket: don't let random users reset the controller
has been removed from the -mm tree.  Its filename was
     rocket-dont-let-random-users-reset-the-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rocket: don't let random users reset the controller
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/char/rocket.c~rocket-dont-let-random-users-reset-the-controller drivers/char/rocket.c
--- a/drivers/char/rocket.c~rocket-dont-let-random-users-reset-the-controller
+++ a/drivers/char/rocket.c
@@ -1399,6 +1399,9 @@ static int reset_rm2(struct r_port *info
 {
 	int reset;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (copy_from_user(&reset, arg, sizeof (int)))
 		return -EFAULT;
 	if (reset)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
