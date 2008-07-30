From: akpm@linux-foundation.org
Subject: - uninline-__remove_assoc_queue.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:30 -0700
Message-ID: <200807301915.m6UJFUER011029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbYG3TQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.petazzoni@free-electrons.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     fs/buffer.c: uninline __remove_assoc_queue()
has been removed from the -mm tree.  Its filename was
     uninline-__remove_assoc_queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/buffer.c: uninline __remove_assoc_queue()
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Uninline the __remove_assoc_queue() function in fs/buffer.c, called at too
many places and too long to really be inlined.  Size results:

   text	   data	    bss	    dec	    hex	filename
1134606	 118840	 212992	1466438	 166046	vmlinux.old
1134303	 118840	 212992	1466135	 165f17	vmlinux
   -303       0       0    -303    -12F +/-

This patch is part of the Linux Tiny project and has been originally
written by Matt Mackall <mpm@selenic.com>.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/buffer.c~uninline-__remove_assoc_queue fs/buffer.c
--- a/fs/buffer.c~uninline-__remove_assoc_queue
+++ a/fs/buffer.c
@@ -580,7 +580,7 @@ EXPORT_SYMBOL(mark_buffer_async_write);
 /*
  * The buffer's backing address_space's private_lock must be held
  */
-static inline void __remove_assoc_queue(struct buffer_head *bh)
+static void __remove_assoc_queue(struct buffer_head *bh)
 {
 	list_del_init(&bh->b_assoc_buffers);
 	WARN_ON(!bh->b_assoc_map);
_

Patches currently in -mm which might be from thomas.petazzoni@free-electrons.com are

origin.patch
configure-out-igmp-support.patch
configure-out-ethtool-support.patch
configure-out-file-locking-features.patch
configure-out-aio-support.patch

