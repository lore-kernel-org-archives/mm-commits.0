From: akpm@osdl.org
Subject: - more-list-debugging-context.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:00 -0800
Message-ID: <200612072304.kB7N40xS030004@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51989 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163742AbWLGXEN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     More list debugging context
has been removed from the -mm tree.  Its filename was
     more-list-debugging-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: More list debugging context
From: Dave Jones <davej@redhat.com>

Print the other (hopefully) known good pointer when list_head debugging
too, which may yield additional clues.

Also fix for 80-columns to win akpm brownie points.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/list_debug.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN lib/list_debug.c~more-list-debugging-context lib/list_debug.c
--- a/lib/list_debug.c~more-list-debugging-context
+++ a/lib/list_debug.c
@@ -21,13 +21,15 @@ void __list_add(struct list_head *new,
 			      struct list_head *next)
 {
 	if (unlikely(next->prev != prev)) {
-		printk(KERN_ERR "list_add corruption. next->prev should be %p, but was %p\n",
-			prev, next->prev);
+		printk(KERN_ERR "list_add corruption. next->prev should be "
+			"prev (%p), but was %p. (next=%p).\n",
+			prev, next->prev, next);
 		BUG();
 	}
 	if (unlikely(prev->next != next)) {
-		printk(KERN_ERR "list_add corruption. prev->next should be %p, but was %p\n",
-			next, prev->next);
+		printk(KERN_ERR "list_add corruption. prev->next should be "
+			"next (%p), but was %p. (prev=%p).\n",
+			next, prev->next, prev);
 		BUG();
 	}
 	next->prev = new;
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
git-agpgart.patch
git-cpufreq.patch
remove-hotplug-cpu-crap-from-cpufreq.patch

