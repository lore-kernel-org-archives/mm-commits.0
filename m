From: akpm@linux-foundation.org
Subject: [merged] dm_ioctl-use-nonseekable_open.patch removed from -mm tree
Date: Tue, 11 May 2010 12:16:59 -0400
Message-ID: <201005111918.o4BJIRIh018207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757575Ab0EKTSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@relay.de.ibm.com, agk@redhat.com, arnd@arndb.de, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dm_ioctl: use nonseekable_open
has been removed from the -mm tree.  Its filename was
     dm_ioctl-use-nonseekable_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm_ioctl: use nonseekable_open
From: Arnd Bergmann <arnd@relay.de.ibm.com>

The dm control device does not implement read/write, so it has no use for
seeking.  Using no_llseek prevents falling back to default_llseek, which
requires the BKL.

[fweisbec@gmail.com: drop useless llseek = no_llseek]
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/md/dm-ioctl.c~dm_ioctl-use-nonseekable_open drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~dm_ioctl-use-nonseekable_open
+++ a/drivers/md/dm-ioctl.c
@@ -1593,6 +1593,7 @@ static long dm_compat_ctl_ioctl(struct f
 #endif
 
 static const struct file_operations _ctl_fops = {
+	.open = nonseekable_open,
 	.unlocked_ioctl	 = dm_ctl_ioctl,
 	.compat_ioctl = dm_compat_ctl_ioctl,
 	.owner	 = THIS_MODULE,
_

Patches currently in -mm which might be from arnd@relay.de.ibm.com are

linux-next.patch

