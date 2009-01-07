From: akpm@linux-foundation.org
Subject: - xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:03:02 -0800
Message-ID: <200901072303.n07N33jF022449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763356AbZAGXDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, alex.zeffertt@eu.citrix.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     xen/xenfs: fix xenbus message reads
has been removed from the -mm tree.  Its filename was
     xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads.patch

This patch was dropped because it was folded into xen-add-xenfs-to-allow-usermode-xen-interaction.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xen/xenfs: fix xenbus message reads
From: Jeremy Fitzhardinge <jeremy@goop.org>

Compute the remaining data size properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alex Zeffertt <alex.zeffertt@eu.citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/xenfs/xenbus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/xen/xenfs/xenbus.c~xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads drivers/xen/xenfs/xenbus.c
--- a/drivers/xen/xenfs/xenbus.c~xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads
+++ a/drivers/xen/xenfs/xenbus.c
@@ -132,7 +132,7 @@ static ssize_t xenbus_file_read(struct f
 	rb = list_entry(u->read_buffers.next, struct read_buffer, list);
 	i = 0;
 	while (i < len) {
-		unsigned sz = min((unsigned)len - i, rb->cons - rb->len);
+		unsigned sz = min((unsigned)len - i, rb->len - rb->cons);
 
 		ret = copy_to_user(ubuf + i, &rb->msg[rb->cons], sz);
 
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
xen-add-xenfs-to-allow-usermode-xen-interaction.patch
xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads.patch

