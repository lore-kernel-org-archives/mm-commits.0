From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-give-shared-kioctx-fields-their-own-cachelines.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:28:35 -0700
Message-ID: <20130321222835.9B7F831C299@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60078 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3CUW2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:28:37 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so22517qcs.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:28:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: give shared kioctx fields their own cachelines
has been removed from the -mm tree.  Its filename was
     aio-give-shared-kioctx-fields-their-own-cachelines.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: give shared kioctx fields their own cachelines

[akpm@linux-foundation.org: make reqs_active __cacheline_aligned_in_smp]
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN fs/aio.c~aio-give-shared-kioctx-fields-their-own-cachelines fs/aio.c
--- a/fs/aio.c~aio-give-shared-kioctx-fields-their-own-cachelines
+++ a/fs/aio.c
@@ -67,13 +67,6 @@ struct kioctx {
 	unsigned long		user_id;
 	struct hlist_node	list;
 
-	wait_queue_head_t	wait;
-
-	spinlock_t		ctx_lock;
-
-	atomic_t		reqs_active;
-	struct list_head	active_reqs;	/* used for cancellation */
-
 	unsigned		nr;
 
 	/* sys_io_setup currently limits this to an unsigned int */
@@ -85,19 +78,29 @@ struct kioctx {
 	struct page		**ring_pages;
 	long			nr_pages;
 
+	struct rcu_head		rcu_head;
+	struct work_struct	rcu_work;
+
+	struct {
+		atomic_t	reqs_active;
+	} ____cacheline_aligned_in_smp;
+
+	struct {
+		spinlock_t	ctx_lock;
+		struct list_head active_reqs;	/* used for cancellation */
+	} ____cacheline_aligned_in_smp;
+
 	struct {
 		struct mutex	ring_lock;
-	} ____cacheline_aligned;
+		wait_queue_head_t wait;
+	} ____cacheline_aligned_in_smp;
 
 	struct {
 		unsigned	tail;
 		spinlock_t	completion_lock;
-	} ____cacheline_aligned;
+	} ____cacheline_aligned_in_smp;
 
 	struct page		*internal_pages[AIO_RING_PAGES];
-
-	struct rcu_head		rcu_head;
-	struct work_struct	rcu_work;
 };
 
 /*------ sysctl variables----*/
_

Patches currently in -mm which might be from koverstreet@google.com are

aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

