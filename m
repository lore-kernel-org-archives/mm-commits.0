From: akpm@linux-foundation.org
Subject: - vitio-add-missing-include-linux-delayh.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:31:00 -0800
Message-ID: <200802070030.m170Uf3T007413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761530AbYBGAnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johfel@users.sourceforge.net, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     virtio: add missing #include <linux/delay.h>
has been removed from the -mm tree.  Its filename was
     vitio-add-missing-include-linux-delayh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: virtio: add missing #include <linux/delay.h>
From: Johann Felix Soden <johfel@users.sourceforge.net>

Include linux/delay.h to fix compiler error:

drivers/virtio/virtio_balloon.c: In function 'fill_balloon':
drivers/virtio/virtio_balloon.c:98: error: implicit declaration of function 'msleep'

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/virtio/virtio_balloon.c~vitio-add-missing-include-linux-delayh drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~vitio-add-missing-include-linux-delayh
+++ a/drivers/virtio/virtio_balloon.c
@@ -23,6 +23,7 @@
 #include <linux/swap.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/delay.h>
 
 struct virtio_balloon
 {
_

Patches currently in -mm which might be from johfel@users.sourceforge.net are

origin.patch
