From: akpm@linux-foundation.org
Subject: - aoe-only-install-new-aoe-device-once.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:05 -0800
Message-ID: <200802082015.m18KFkM2010644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbYBHUtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:49:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     aoe: only install new AoE device once
has been removed from the -mm tree.  Its filename was
     aoe-only-install-new-aoe-device-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: only install new AoE device once
From: "Ed L. Cashin" <ecashin@coraid.com>

An aoe driver user who had about 70 AoE targets found that he was hitting a
BUG in sysfs_create_file because the aoe driver was trying to tell the kernel
about an AoE device more than once.  Each AoE device was reachable by several
local network interfaces, and multiple ATA device indentify responses were
returning from that single device.

This patch eliminates a race condition so that aoe always informs the block
layer of a new AoE device once in the presence of multiple incoming ATA device
identify responses.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoecmd.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/aoe/aoecmd.c~aoe-only-install-new-aoe-device-once drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-only-install-new-aoe-device-once
+++ a/drivers/block/aoe/aoecmd.c
@@ -698,6 +698,8 @@ ataid_complete(struct aoedev *d, struct 
 			d->fw_ver, (long long)ssize);
 	d->ssize = ssize;
 	d->geo.start = 0;
+	if (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
+		return;
 	if (d->gd != NULL) {
 		d->gd->capacity = ssize;
 		d->flags |= DEVFL_NEWSIZE;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
