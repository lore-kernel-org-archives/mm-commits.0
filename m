From: akpm@linux-foundation.org
Subject: + aoe-only-install-new-aoe-device-once.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:03:54 -0800
Message-ID: <200712220603.lBM63scU020125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbXLVGD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:03:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, greg@kroah.com


The patch titled
     aoe: only install new AoE device once
has been added to the -mm tree.  Its filename is
     aoe-only-install-new-aoe-device-once.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

aoe-bring-driver-version-number-to-47.patch
aoe-handle-multiple-network-paths-to-aoe-device.patch
aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch
aoe-clean-up-udev-configuration-example.patch
aoe-eliminate-goto-and-improve-readability.patch
aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch
aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch
aoe-only-install-new-aoe-device-once.patch
aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch
aoe-the-aoeminor-doesnt-need-a-long-format.patch
aoe-make-error-messages-more-specific.patch
aoe-update-copyright-date.patch
aoe-statically-initialise-devlist_lock.patch
