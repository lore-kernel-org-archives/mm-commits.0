From: akpm@linux-foundation.org
Subject: - is_power_of_2-kernel-kfifoc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:21 -0700
Message-ID: <200707162058.l6GKwLQu002340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47144 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbXGPVLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vignesh.babu@wipro.com, stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     is_power_of_2: kernel/kfifo.c
has been removed from the -mm tree.  Its filename was
     is_power_of_2-kernel-kfifoc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: is_power_of_2: kernel/kfifo.c
From: vignesh babu <vignesh.babu@wipro.com>

Replace (n & (n-1)) with is_power_of_2()

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Acked-by: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/kfifo.c~is_power_of_2-kernel-kfifoc kernel/kfifo.c
--- a/kernel/kfifo.c~is_power_of_2-kernel-kfifoc
+++ a/kernel/kfifo.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/kfifo.h>
+#include <linux/log2.h>
 
 /**
  * kfifo_init - allocates a new FIFO using a preallocated buffer
@@ -41,7 +42,7 @@ struct kfifo *kfifo_init(unsigned char *
 	struct kfifo *fifo;
 
 	/* size must be a power of 2 */
-	BUG_ON(size & (size - 1));
+	BUG_ON(!is_power_of_2(size));
 
 	fifo = kmalloc(sizeof(struct kfifo), gfp_mask);
 	if (!fifo)
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

origin.patch
git-ubi.patch
git-xfs.patch
is_power_of_2-ext4-superc.patch
