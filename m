From: akpm@linux-foundation.org
Subject: + aio-remove-dead-code-from-aioh.patch added to -mm tree
Date: Thu, 21 Mar 2013 15:37:27 -0700
Message-ID: <20130321223727.F400A31C158@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:37035 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3CUWha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:37:30 -0400
Received: by mail-vc0-f201.google.com with SMTP id hf12so311108vcb.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:37:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zab@redhat.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, koverstreet@google.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: aio: remove dead code from aio.h
has been added to the -mm tree.  Its filename is
     aio-remove-dead-code-from-aioh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
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
-
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
 extern int aio_put_req(struct kiocb *iocb);
_

Patches currently in -mm which might be from zab@redhat.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-add-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

