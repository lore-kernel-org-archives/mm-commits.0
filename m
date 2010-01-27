From: akpm@linux-foundation.org
Subject: + kernel-kfifoc-fix-integer-as-null-pointer-sparse-warning.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:13:30 -0800
Message-ID: <201001272313.o0RNDUhc005852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924Ab0A0XNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:13:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tfransosi@gmail.com, stefani@seibold.net


The patch titled
     kernel/kfifo.c: fix "integer as NULL pointer" sparse warning
has been added to the -mm tree.  Its filename is
     kernel-kfifoc-fix-integer-as-null-pointer-sparse-warning.patch

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
Subject: kernel/kfifo.c: fix "integer as NULL pointer" sparse warning
From: Thiago Farina <tfransosi@gmail.com>

kernel/kfifo.c:83:35: warning: Using plain integer as NULL pointer

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kfifo.c~kernel-kfifoc-fix-integer-as-null-pointer-sparse-warning kernel/kfifo.c
--- a/kernel/kfifo.c~kernel-kfifoc-fix-integer-as-null-pointer-sparse-warning
+++ a/kernel/kfifo.c
@@ -80,7 +80,7 @@ int kfifo_alloc(struct kfifo *fifo, unsi
 
 	buffer = kmalloc(size, gfp_mask);
 	if (!buffer) {
-		_kfifo_init(fifo, 0, 0);
+		_kfifo_init(fifo, NULL, 0);
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from tfransosi@gmail.com are

linux-next.patch
mm-memcontrolc-fix-integer-as-null-pointer-sparse-warning.patch
kernel-exitc-fix-shadows-sparse-warning.patch
console-vgaconc-mark-file-local-symbol-static.patch
kernel-kfifoc-fix-integer-as-null-pointer-sparse-warning.patch

