From: akpm@linux-foundation.org
Subject: + is_power_of_2-kernel-kfifoc.patch added to -mm tree
Date: Tue, 26 Jun 2007 14:08:41 -0700
Message-ID: <200706262108.l5QL8fFN002129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756772AbXFZVIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 17:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vignesh.babu@wipro.com, stelian@popies.net


The patch titled
     is_power_of_2: kernel/kfifo.c
has been added to the -mm tree.  Its filename is
     is_power_of_2-kernel-kfifoc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: is_power_of_2: kernel/kfifo.c
From: vignesh babu <vignesh.babu@wipro.com>

Replace (n & (n-1)) with is_power_of_2()

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Acked-by: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

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

git-ubi.patch
use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch
use-is_power_of_2-in-myri10ge-myri10gec.patch
is_power_of_2-ext3-superc.patch
is_power_of_2-jbd.patch
is_power_of_2-kernel-kfifoc.patch
is_power_of_2-ext4-superc.patch
