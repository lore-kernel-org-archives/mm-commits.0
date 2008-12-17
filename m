From: akpm@linux-foundation.org
Subject: + xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads.patch added to -mm tree
Date: Wed, 17 Dec 2008 13:49:09 -0800
Message-ID: <200812172149.mBHLn9pY015608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYLQVty (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 16:49:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, alex.zeffertt@eu.citrix.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu


The patch titled
     xen/xenfs: fix xenbus message reads
has been added to the -mm tree.  Its filename is
     xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads.patch

