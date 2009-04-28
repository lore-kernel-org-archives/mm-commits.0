From: akpm@linux-foundation.org
Subject: + mutex-add-atomic_dec_and_mutex_lock.patch added to -mm tree
Date: Tue, 28 Apr 2009 13:27:52 -0700
Message-ID: <200904282027.n3SKRq4I020938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbZD1Ud1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 16:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, a.p.zijlstra@chello.nl, hch@lst.de, mingo@elte.hu, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     mutex: add atomic_dec_and_mutex_lock
has been added to the -mm tree.  Its filename is
     mutex-add-atomic_dec_and_mutex_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mutex: add atomic_dec_and_mutex_lock
From: Eric Paris <eparis@redhat.com>

Much like the atomic_dec_and_lock() function in which we take and hold a
spin_lock if we drop the atomic to 0 this function takes and holds the
mutex if we dec the atomic to 0.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN include/linux/mutex.h~mutex-add-atomic_dec_and_mutex_lock include/linux/mutex.h
--- a/include/linux/mutex.h~mutex-add-atomic_dec_and_mutex_lock
+++ a/include/linux/mutex.h
@@ -151,4 +151,27 @@ extern int __must_check mutex_lock_killa
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
 
+/**
+ * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
+ * @cnt: the atomic which we are to dec
+ * @lock: the mutex to return holding if we dec to 0
+ *
+ * return true and hold lock if we dec to 0, return false otherwise
+ */
+static inline int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock)
+{
+	/* dec if we can't possibly hit 0 */
+	if (atomic_add_unless(cnt, -1, 1))
+		return 0;
+	/* we might hit 0, so take the lock */
+	mutex_lock(lock);
+	if (!atomic_dec_and_test(cnt)) {
+		/* when we actually did the dec, we didn't hit 0 */
+		mutex_unlock(lock);
+		return 0;
+	}
+	/* we hit 0, and we hold the lock */
+	return 1;
+}
+
 #endif
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
mutex-add-atomic_dec_and_mutex_lock.patch
fsnotify-unified-filesystem-notification-backend.patch
fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes.patch
fsnotify-parent-event-notification.patch
dnotify-reimplement-dnotify-using-fsnotify.patch
fsnotify-generic-notification-queue-and-waitq.patch
fsnotify-include-pathnames-with-entries-when-possible.patch
fsnotify-add-correlations-between-events.patch
fsnotify-allow-groups-to-add-private-data-to-events.patch
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch

