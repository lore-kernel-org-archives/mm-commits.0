From: akpm@linux-foundation.org
Subject: +
 fsnotify-do-not-share-events-between-notification-groups-fix.patch added to -mm tree
Date: Mon, 13 Jan 2014 13:42:52 -0800
Message-ID: <52d45ddc.6fyDQCxfMyR5dXRl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaAMVmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 16:42:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de, eparis@parisplace.org, hughd@google.com

Subject: + fsnotify-do-not-share-events-between-notification-groups-fix.patch added to -mm tree
To: hughd@google.com,eparis@parisplace.org,hch@lst.de,jack@suse.cz,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 13:42:52 -0800


The patch titled
     Subject: fanotify: fix corruption preventing startup
has been added to the -mm tree.  Its filename is
     fsnotify-do-not-share-events-between-notification-groups-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-do-not-share-events-between-notification-groups-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-do-not-share-events-between-notification-groups-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: fanotify: fix corruption preventing startup

Two of my machines couldn't boot mmotm with fanotify enabled:
0x40000020 was being or'ed into a group's notification_waitq next
pointer, with sad results.  It comes from an over-simplification in
fanotify_merge(): test_event isn't NULL when the loop finds no merge.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/notify/fanotify/fanotify.c~fsnotify-do-not-share-events-between-notification-groups-fix fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fsnotify-do-not-share-events-between-notification-groups-fix
+++ a/fs/notify/fanotify/fanotify.c
@@ -37,16 +37,19 @@ static bool should_merge(struct fsnotify
 static struct fsnotify_event *fanotify_merge(struct list_head *list,
 					     struct fsnotify_event *event)
 {
-	struct fsnotify_event *test_event = NULL;
+	struct fsnotify_event *test_event;
+	bool do_merge = false;
 
 	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
 
 	list_for_each_entry_reverse(test_event, list, list) {
-		if (should_merge(test_event, event))
+		if (should_merge(test_event, event)) {
+			do_merge = true;
 			break;
+		}
 	}
 
-	if (!test_event)
+	if (!do_merge)
 		return NULL;
 
 	test_event->mask |= event->mask;
_

Patches currently in -mm which might be from hughd@google.com are

mm-remove-bug_on-from-mlock_vma_page.patch
fsnotify-do-not-share-events-between-notification-groups-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_referenced-fix.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-documentation-remove-hopelessly-out-of-date-locking-doc.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

