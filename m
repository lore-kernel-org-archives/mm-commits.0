From: akpm@linux-foundation.org
Subject: + vitio-add-missing-include-linux-delayh.patch added to -mm tree
Date: Wed, 06 Feb 2008 00:57:42 -0800
Message-ID: <200802060857.m168vNeT002250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758872AbYBFI5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 03:57:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johfel@users.sourceforge.net, rusty@rustcorp.com.au


The patch titled
     virtio: add missing #include <linux/delay.h>
has been added to the -mm tree.  Its filename is
     vitio-add-missing-include-linux-delayh.patch

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
vitio-add-missing-include-linux-delayh.patch
