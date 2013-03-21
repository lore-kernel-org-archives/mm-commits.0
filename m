From: akpm@linux-foundation.org
Subject: [to-be-updated] aio-move-private-stuff-out-of-aioh.patch removed from -mm tree
Date: Thu, 21 Mar 2013 15:27:47 -0700
Message-ID: <20130321222747.A2FD15A42C2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52879 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab3CUW1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 18:27:49 -0400
Received: by mail-gg0-f202.google.com with SMTP id l4so309774ggi.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 15:27:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, asamymuthupa@micron.com, axboe@kernel.dk, balbi@ti.com, bcrl@kvack.org, gregkh@linuxfoundation.org, jlbec@evilplan.org, jmoyer@redhat.com, mfasheh@suse.com, rusty@rustcorp.com.au, sbradshaw@micron.com, smani@micron.com, tytso@mit.edu, viro@zeniv.linux.org.uk, zab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: move private stuff out of aio.h
has been removed from the -mm tree.  Its filename was
     aio-move-private-stuff-out-of-aioh.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: aio: move private stuff out of aio.h

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
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/inode.c |    1 
 fs/aio.c                   |   61 +++++++++++++++++++++++++++++++++++
 include/linux/aio.h        |   61 -----------------------------------
 3 files changed, 62 insertions(+), 61 deletions(-)

diff -puN drivers/usb/gadget/inode.c~aio-move-private-stuff-out-of-aioh drivers/usb/gadget/inode.c
--- a/drivers/usb/gadget/inode.c~aio-move-private-stuff-out-of-aioh
+++ a/drivers/usb/gadget/inode.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/mmu_context.h>
+#include <linux/aio.h>
 
 #include <linux/device.h>
 #include <linux/moduleparam.h>
diff -puN fs/aio.c~aio-move-private-stuff-out-of-aioh fs/aio.c
--- a/fs/aio.c~aio-move-private-stuff-out-of-aioh
+++ a/fs/aio.c
@@ -45,6 +45,67 @@
 #define dprintk(x...)	do { ; } while (0)
 #endif
 
+#define AIO_RING_MAGIC			0xa10a10a1
+#define AIO_RING_COMPAT_FEATURES	1
+#define AIO_RING_INCOMPAT_FEATURES	0
+struct aio_ring {
+	unsigned	id;	/* kernel internal index number */
+	unsigned	nr;	/* number of io_events */
+	unsigned	head;
+	unsigned	tail;
+
+	unsigned	magic;
+	unsigned	compat_features;
+	unsigned	incompat_features;
+	unsigned	header_length;	/* size of aio_ring */
+
+
+	struct io_event		io_events[0];
+}; /* 128 bytes + ring size */
+
+#define AIO_RING_PAGES	8
+struct aio_ring_info {
+	unsigned long		mmap_base;
+	unsigned long		mmap_size;
+
+	struct page		**ring_pages;
+	spinlock_t		ring_lock;
+	long			nr_pages;
+
+	unsigned		nr, tail;
+
+	struct page		*internal_pages[AIO_RING_PAGES];
+};
+
+static inline unsigned aio_ring_avail(struct aio_ring_info *info,
+					struct aio_ring *ring)
+{
+	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
+}
+
+struct kioctx {
+	atomic_t		users;
+	int			dead;
+
+	/* This needs improving */
+	unsigned long		user_id;
+	struct hlist_node	list;
+
+	wait_queue_head_t	wait;
+
+	spinlock_t		ctx_lock;
+
+	int			reqs_active;
+	struct list_head	active_reqs;	/* used for cancellation */
+
+	/* sys_io_setup currently limits this to an unsigned int */
+	unsigned		max_reqs;
+
+	struct aio_ring_info	ring_info;
+
+	struct rcu_head		rcu_head;
+};
+
 /*------ sysctl variables----*/
 static DEFINE_SPINLOCK(aio_nr_lock);
 unsigned long aio_nr;		/* current system wide number of aio requests */
diff -puN include/linux/aio.h~aio-move-private-stuff-out-of-aioh include/linux/aio.h
--- a/include/linux/aio.h~aio-move-private-stuff-out-of-aioh
+++ a/include/linux/aio.h
@@ -103,67 +103,6 @@ static inline void init_sync_kiocb(struc
 		};
 }
 
-#define AIO_RING_MAGIC			0xa10a10a1
-#define AIO_RING_COMPAT_FEATURES	1
-#define AIO_RING_INCOMPAT_FEATURES	0
-struct aio_ring {
-	unsigned	id;	/* kernel internal index number */
-	unsigned	nr;	/* number of io_events */
-	unsigned	head;
-	unsigned	tail;
-
-	unsigned	magic;
-	unsigned	compat_features;
-	unsigned	incompat_features;
-	unsigned	header_length;	/* size of aio_ring */
-
-
-	struct io_event		io_events[0];
-}; /* 128 bytes + ring size */
-
-#define AIO_RING_PAGES	8
-struct aio_ring_info {
-	unsigned long		mmap_base;
-	unsigned long		mmap_size;
-
-	struct page		**ring_pages;
-	spinlock_t		ring_lock;
-	long			nr_pages;
-
-	unsigned		nr, tail;
-
-	struct page		*internal_pages[AIO_RING_PAGES];
-};
-
-static inline unsigned aio_ring_avail(struct aio_ring_info *info,
-					struct aio_ring *ring)
-{
-	return (ring->head + info->nr - 1 - ring->tail) % info->nr;
-}
-
-struct kioctx {
-	atomic_t		users;
-	int			dead;
-
-	/* This needs improving */
-	unsigned long		user_id;
-	struct hlist_node	list;
-
-	wait_queue_head_t	wait;
-
-	spinlock_t		ctx_lock;
-
-	int			reqs_active;
-	struct list_head	active_reqs;	/* used for cancellation */
-
-	/* sys_io_setup currently limits this to an unsigned int */
-	unsigned		max_reqs;
-
-	struct aio_ring_info	ring_info;
-
-	struct rcu_head		rcu_head;
-};
-
 /* prototypes */
 #ifdef CONFIG_AIO
 extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
_

Patches currently in -mm which might be from koverstreet@google.com are

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
block-aio-batch-completion-for-bios-kiocbs.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-aio_read_events_ring-types.patch
aio-document-clarify-aio_read_events-and-shadow_tail.patch
aio-correct-calculation-of-available-events.patch
aio-v2-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
aio-fix-ringbuffer-calculation-so-we-dont-wrap.patch

