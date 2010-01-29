From: akpm@linux-foundation.org
Subject: [merged] kernel-kfifoc-fix-integer-as-null-pointer-sparse-warning.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:17:28 -0800
Message-ID: <201001292017.o0TKHSPh003314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868Ab0A2USO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:18:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tfransosi@gmail.com, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     kernel/kfifo.c: fix "integer as NULL pointer" sparse warning
has been removed from the -mm tree.  Its filename was
     kernel-kfifoc-fix-integer-as-null-pointer-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

