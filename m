From: akpm@linux-foundation.org
Subject: [merged] mm-remove-old-aio-use_mm-comment.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:48 -0700
Message-ID: <20130508183448.B5C0131C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:60225 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab3EHSeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:50 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so207964qen.0
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zab@redhat.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, koverstreet@google.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove old aio use_mm() comment
has been removed from the -mm tree.  Its filename was
     mm-remove-old-aio-use_mm-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zach Brown <zab@redhat.com>
Subject: mm: remove old aio use_mm() comment

Bunch of performance improvements and cleanups Zach Brown and I have been
working on.  The code should be pretty solid at this point, though it
could of course use more review and testing.

The results in my testing are pretty impressive, particularly when an
ioctx is being shared between multiple threads.  In my crappy synthetic
benchmark, with 4 threads submitting and one thread reaping completions, I
saw overhead in the aio code go from ~50% (mostly ioctx lock contention)
to low single digits.  Performance with ioctx per thread improved too, but
I'd have to rerun those benchmarks.

The reason I've been focused on performance when the ioctx is shared is
that for a fair number of real world completions, userspace needs the
completions aggregated somehow - in practice people just end up
implementing this aggregation in userspace today, but if it's done right
we can do it much more efficiently in the kernel.

Performance wise, the end result of this patch series is that submitting a
kiocb writes to _no_ shared cachelines - the penalty for sharing an ioctx
is gone there.  There's still going to be some cacheline contention when
we deliver the completions to the aio ringbuffer (at least if you have
interrupts being delivered on multiple cores, which for high end stuff you
do) but I have a couple more patches not in this series that implement
coalescing for that (by taking advantage of interrupt coalescing).  With
that, there's basically no bottlenecks or performance issues to speak of
in the aio code.



This patch:

use_mm() is used in more places than just aio.  There's no need to mention
callers when describing the function.

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

 mm/mmu_context.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/mmu_context.c~mm-remove-old-aio-use_mm-comment mm/mmu_context.c
--- a/mm/mmu_context.c~mm-remove-old-aio-use_mm-comment
+++ a/mm/mmu_context.c
@@ -14,9 +14,6 @@
  * use_mm
  *	Makes the calling kernel thread take on the specified
  *	mm context.
- *	Called by the retry thread execute retries within the
- *	iocb issuer's mm context, so that copy_from/to_user
- *	operations work seamlessly for aio.
  *	(Note: this routine is intended to be called only
  *	from a kernel thread context)
  */
_

Patches currently in -mm which might be from zab@redhat.com are

origin.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

