From: akpm@linux-foundation.org
Subject: + uninline-__remove_assoc_queue.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:05:18 -0700
Message-ID: <200807300005.m6U05Ig8029182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbYG3AFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.petazzoni@free-electrons.com, mpm@selenic.com


The patch titled
     fs/buffer.c: uninline __remove_assoc_queue()
has been added to the -mm tree.  Its filename is
     uninline-__remove_assoc_queue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uninline-__remove_assoc_queue.patch
configure-out-igmp-support.patch
configure-out-ethtool-support.patch
configure-out-file-locking-features.patch
configure-out-aio-support.patch

