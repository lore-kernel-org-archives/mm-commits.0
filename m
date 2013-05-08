From: akpm@linux-foundation.org
Subject: [merged] aio-give-shared-kioctx-fields-their-own-cachelines.patch removed from -mm tree
Date: Wed, 08 May 2013 11:35:46 -0700
Message-ID: <20130508183546.E1AA031C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38141 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab3EHSfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:35:48 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so207817vbe.1
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:35:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: give shared kioctx fields their own cachelines
has been removed from the -mm tree.  Its filename was
     aio-give-shared-kioctx-fields-their-own-cachelines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
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
 	/*
 	 * This is what userspace passed to io_setup(), it's not used for
 	 * anything but counting against the global max_reqs quota.
@@ -92,19 +85,29 @@ struct kioctx {
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

origin.patch
linux-next.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

