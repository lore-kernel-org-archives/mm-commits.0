From: akpm@linux-foundation.org
Subject: + block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix.patch added to -mm tree
Date: Mon, 07 Jan 2013 15:11:52 -0800
Message-ID: <20130107231152.82CA5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:51004 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3AGXLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 18:11:53 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so1838336ghb.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 15:11:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com


The patch titled
     Subject: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix
has been added to the -mm tree.  Its filename is
     block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix

Fix broken build when CONFIG_BLOCK=n by pulling common stuff out into a
new header.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aio.h            |    2 +-
 include/linux/batch_complete.h |   23 +++++++++++++++++++++++
 include/linux/bio.h            |   10 +---------
 3 files changed, 25 insertions(+), 10 deletions(-)

diff -puN include/linux/aio.h~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix include/linux/aio.h
--- a/include/linux/aio.h~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix
+++ a/include/linux/aio.h
@@ -7,7 +7,7 @@
 #include <linux/uio.h>
 #include <linux/rcupdate.h>
 #include <linux/atomic.h>
-#include <linux/rbtree.h>
+#include <linux/batch_complete.h>
 
 struct kioctx;
 struct kiocb;
diff -puN /dev/null include/linux/batch_complete.h
--- /dev/null
+++ a/include/linux/batch_complete.h
@@ -0,0 +1,23 @@
+#ifndef _LINUX_BATCH_COMPLETE_H
+#define _LINUX_BATCH_COMPLETE_H
+
+#include <linux/rbtree.h>
+
+/*
+ * Common stuff to the aio and block code for batch completion. Everything
+ * important is elsewhere:
+ */
+
+struct bio;
+
+struct bio_list {
+	struct bio *head;
+	struct bio *tail;
+};
+
+struct batch_complete {
+	struct bio_list		bio;
+	struct rb_root		kiocb;
+};
+
+#endif
diff -puN include/linux/bio.h~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix include/linux/bio.h
--- a/include/linux/bio.h~block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix
+++ a/include/linux/bio.h
@@ -24,6 +24,7 @@
 #include <linux/mempool.h>
 #include <linux/ioprio.h>
 #include <linux/bug.h>
+#include <linux/batch_complete.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -438,10 +439,6 @@ static inline bool bio_mergeable(struct 
  * member of the bio.  The bio_list also caches the last list member to allow
  * fast access to the tail.
  */
-struct bio_list {
-	struct bio *head;
-	struct bio *tail;
-};
 
 static inline int bio_list_empty(const struct bio_list *bl)
 {
@@ -545,11 +542,6 @@ static inline struct bio *bio_list_get(s
 	return bio;
 }
 
-struct batch_complete {
-	struct bio_list		bio;
-	struct rb_root		kiocb;
-};
-
 void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch);
 
 static inline void batch_complete_init(struct batch_complete *batch)
_

Patches currently in -mm which might be from koverstreet@google.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-kiocb_cancel.patch
aio-kiocb_cancel-fix.patch
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
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-fix-fix.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-smoosh-struct-kiocb.patch
aio-smoosh-struct-kiocb-fix.patch

