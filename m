From: akpm@linux-foundation.org
Subject: [merged] aio-remove-dead-code-from-aioh.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:51 -0700
Message-ID: <20130508183451.E3E7D31C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57588 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab3EHSex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:53 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so208162yho.3
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zab@redhat.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, koverstreet@google.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: remove dead code from aio.h
has been removed from the -mm tree.  Its filename was
     aio-remove-dead-code-from-aioh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zach Brown <zab@redhat.com>
Subject: aio: remove dead code from aio.h

Signed-off-by: Zach Brown <zab@redhat.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aio.h |   24 ------------------------
 1 file changed, 24 deletions(-)

diff -puN include/linux/aio.h~aio-remove-dead-code-from-aioh include/linux/aio.h
--- a/include/linux/aio.h~aio-remove-dead-code-from-aioh
+++ a/include/linux/aio.h
@@ -9,44 +9,22 @@
 
 #include <linux/atomic.h>
 
-#define AIO_MAXSEGS		4
-#define AIO_KIOGRP_NR_ATOMIC	8
-
 struct kioctx;
 
-/* Notes on cancelling a kiocb:
- *	If a kiocb is cancelled, aio_complete may return 0 to indicate 
- *	that cancel has not yet disposed of the kiocb.  All cancel 
- *	operations *must* call aio_put_req to dispose of the kiocb 
- *	to guard against races with the completion code.
- */
-#define KIOCB_C_CANCELLED	0x01
-#define KIOCB_C_COMPLETE	0x02
-
 #define KIOCB_SYNC_KEY		(~0U)
 
 /* ki_flags bits */
-/*
- * This may be used for cancel/retry serialization in the future, but
- * for now it's unused and we probably don't want modules to even
- * think they can use it.
- */
-/* #define KIF_LOCKED		0 */
 #define KIF_KICKED		1
 #define KIF_CANCELLED		2
 
-#define kiocbTryLock(iocb)	test_and_set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbTryKick(iocb)	test_and_set_bit(KIF_KICKED, &(iocb)->ki_flags)
 
-#define kiocbSetLocked(iocb)	set_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbSetKicked(iocb)	set_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbSetCancelled(iocb)	set_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
-#define kiocbClearLocked(iocb)	clear_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbClearKicked(iocb)	clear_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbClearCancelled(iocb)	clear_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
-#define kiocbIsLocked(iocb)	test_bit(KIF_LOCKED, &(iocb)->ki_flags)
 #define kiocbIsKicked(iocb)	test_bit(KIF_KICKED, &(iocb)->ki_flags)
 #define kiocbIsCancelled(iocb)	test_bit(KIF_CANCELLED, &(iocb)->ki_flags)
 
@@ -207,8 +185,6 @@ struct kioctx {
 };
 
 /* prototypes */
-extern unsigned aio_max_size;
