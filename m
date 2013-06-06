From: akpm@linux-foundation.org
Subject: [to-be-updated] vmpressure-in-kernel-notifications.patch removed
 from -mm tree
Date: Thu, 06 Jun 2013 12:35:27 -0700
Message-ID: <51b0e47f.SkBD6UEEcuUSZf+q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3FFTf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, glommer@parallels.com

Subject: [to-be-updated] vmpressure-in-kernel-notifications.patch removed from -mm tree
To: glommer@parallels.com,dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:27 -0700


The patch titled
     Subject: vmpressure: in-kernel notifications
has been removed from the -mm tree.  Its filename was
     vmpressure-in-kernel-notifications.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: vmpressure: in-kernel notifications

During the past weeks, it became clear to us that the shrinker interface
we have right now works very well for some particular types of users, but
not that well for others.  The later are usually people interested in
one-shot notifications, that were forced to adapt themselves to the
count+scan behavior of shrinkers.  To do so, they had no choice than to
greatly abuse the shrinker interface producing little monsters all over.

During LSF/MM, one of the proposals that popped out during our session was
to reuse Anton Voronstsov's vmpressure for this.  They are designed for
userspace consumption, but also provide a well-stablished, cgroup-aware
entry point for notifications.

This patch extends that to also support in-kernel users.  Events that
should be generated for in-kernel consumption will be marked as such, and
for those, we will call a registered function instead of triggering an
eventfd notification.

Please note that due to my lack of understanding of each shrinker user, I
will stay away from converting the actual users, you are all welcome to do
so.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmpressure.h |    6 ++++
 mm/vmpressure.c            |   52 ++++++++++++++++++++++++++++++++---
 2 files changed, 55 insertions(+), 3 deletions(-)

diff -puN include/linux/vmpressure.h~vmpressure-in-kernel-notifications include/linux/vmpressure.h
--- a/include/linux/vmpressure.h~vmpressure-in-kernel-notifications
+++ a/include/linux/vmpressure.h
@@ -19,6 +19,9 @@ struct vmpressure {
 	/* Have to grab the lock on events traversal or modifications. */
 	struct mutex events_lock;
 
+	/* False if only kernel users want to be notified, true otherwise. */
+	bool notify_userspace;
+
 	struct work_struct work;
 };
 
@@ -36,6 +39,9 @@ extern struct vmpressure *css_to_vmpress
 extern int vmpressure_register_event(struct cgroup *cg, struct cftype *cft,
 				     struct eventfd_ctx *eventfd,
 				     const char *args);
+
+extern int vmpressure_register_kernel_event(struct cgroup *cg,
+					    void (*fn)(void));
 extern void vmpressure_unregister_event(struct cgroup *cg, struct cftype *cft,
 					struct eventfd_ctx *eventfd);
 #else
diff -puN mm/vmpressure.c~vmpressure-in-kernel-notifications mm/vmpressure.c
--- a/mm/vmpressure.c~vmpressure-in-kernel-notifications
+++ a/mm/vmpressure.c
@@ -135,8 +135,12 @@ static enum vmpressure_levels vmpressure
 }
 
 struct vmpressure_event {
-	struct eventfd_ctx *efd;
+	union {
+		struct eventfd_ctx *efd;
+		void (*fn)(void);
+	};
 	enum vmpressure_levels level;
+	bool kernel_event;
 	struct list_head node;
 };
 
@@ -152,12 +156,15 @@ static bool vmpressure_event(struct vmpr
 	mutex_lock(&vmpr->events_lock);
 
 	list_for_each_entry(ev, &vmpr->events, node) {
-		if (level >= ev->level) {
+		if (ev->kernel_event) {
+			ev->fn();
+		} else if (vmpr->notify_userspace && level >= ev->level) {
 			eventfd_signal(ev->efd, 1);
 			signalled = true;
 		}
 	}
 
+	vmpr->notify_userspace = false;
 	mutex_unlock(&vmpr->events_lock);
 
 	return signalled;
@@ -227,7 +234,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 	 * we account it too.
 	 */
 	if (!(gfp & (__GFP_HIGHMEM | __GFP_MOVABLE | __GFP_IO | __GFP_FS)))
-		return;
+		goto schedule;
 
 	/*
 	 * If we got here with no pages scanned, then that is an indicator
@@ -244,8 +251,15 @@ void vmpressure(gfp_t gfp, struct mem_cg
 	vmpr->scanned += scanned;
 	vmpr->reclaimed += reclaimed;
 	scanned = vmpr->scanned;
+	/*
+	 * If we didn't reach this point, only kernel events will be triggered.
+	 * It is the job of the worker thread to clean this up once the
+	 * notifications are all delivered.
+	 */
+	vmpr->notify_userspace = true;
 	mutex_unlock(&vmpr->sr_lock);
 
+schedule:
 	if (scanned < vmpressure_win || work_pending(&vmpr->work))
 		return;
 	schedule_work(&vmpr->work);
@@ -327,6 +341,38 @@ int vmpressure_register_event(struct cgr
 	return 0;
 }
 
+/**
+ * vmpressure_register_kernel_event() - Register kernel-side notification
+ * @cg:		cgroup that is interested in vmpressure notifications
+ * @fn:		function to be called when pressure happens
+ *
+ * This function register in-kernel users interested in receiving notifications
+ * about pressure conditions. Pressure notifications will be triggered at the
+ * same time as userspace notifications (with no particular ordering relative
+ * to it).
+ *
+ * Pressure notifications are a alternative method to shrinkers and will serve
+ * well users that are interested in a one-shot notification, with a
+ * well-defined cgroup aware interface.
+ */
+int vmpressure_register_kernel_event(struct cgroup *cg, void (*fn)(void))
+{
+	struct vmpressure *vmpr = cg_to_vmpressure(cg);
+	struct vmpressure_event *ev;
+
+	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
+	if (!ev)
+		return -ENOMEM;
+
+	ev->kernel_event = true;
+	ev->fn = fn;
+
+	mutex_lock(&vmpr->events_lock);
+	list_add(&ev->node, &vmpr->events);
+	mutex_unlock(&vmpr->events_lock);
+	return 0;
+}
+
 /**
  * vmpressure_unregister_event() - Unbind eventfd from vmpressure
  * @cg:		cgroup handle
_

Patches currently in -mm which might be from glommer@parallels.com are

memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator.patch
clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking-call-mmu-notifiers-when-write-protecting-ptes.patch
pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch
mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch

