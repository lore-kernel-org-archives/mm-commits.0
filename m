From: akpm@linux-foundation.org
Subject: [merged] time-dont-inline-export_symbol-functions.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:55 -0800
Message-ID: <20130222203855.B27FC31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38142 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:57 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so103846vbb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, mcharleb@qualcomm.com, paul.gortmaker@windriver.com, pyu@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: time: don't inline EXPORT_SYMBOL functions
has been removed from the -mm tree.  Its filename was
     time-dont-inline-export_symbol-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: time: don't inline EXPORT_SYMBOL functions

How is the compiler even handling exported functions that are marked
inline?  Anyway, these shouldn't be inline because of that, so remove that
marking.

Based on a larger patch by Mark Charlebois to get LLVM to build the
kernel.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Charlebois <mcharleb@qualcomm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: hank <pyu@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/time.c~time-dont-inline-export_symbol-functions kernel/time.c
--- a/kernel/time.c~time-dont-inline-export_symbol-functions
+++ a/kernel/time.c
@@ -240,7 +240,7 @@ EXPORT_SYMBOL(current_fs_time);
  * Avoid unnecessary multiplications/divisions in the
  * two most common HZ cases:
  */
-inline unsigned int jiffies_to_msecs(const unsigned long j)
+unsigned int jiffies_to_msecs(const unsigned long j)
 {
 #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
 	return (MSEC_PER_SEC / HZ) * j;
@@ -256,7 +256,7 @@ inline unsigned int jiffies_to_msecs(con
 }
 EXPORT_SYMBOL(jiffies_to_msecs);
 
-inline unsigned int jiffies_to_usecs(const unsigned long j)
+unsigned int jiffies_to_usecs(const unsigned long j)
 {
 #if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
 	return (USEC_PER_SEC / HZ) * j;
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

origin.patch
linux-next.patch
swap-add-per-partition-lock-for-swapfile.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
uio-convert-to-idr_alloc.patch
mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch

