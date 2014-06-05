From: akpm@linux-foundation.org
Subject: [merged] fs-notify-markc-trivial-cleanup.patch removed from -mm
 tree
Date: Thu, 05 Jun 2014 12:42:11 -0700
Message-ID: <5390c813.Xq16pcf+B1wB22uX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaFETmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, david.a.cohen@linux.intel.com

Subject: [merged] fs-notify-markc-trivial-cleanup.patch removed from -mm tree
To: david.a.cohen@linux.intel.com,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:11 -0700


The patch titled
     Subject: fs/notify/mark.c: trivial cleanup
has been removed from the -mm tree.  Its filename was
     fs-notify-markc-trivial-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Cohen <david.a.cohen@linux.intel.com>
Subject: fs/notify/mark.c: trivial cleanup

Do not initialize private_destroy_list twice.  list_replace_init() already
takes care of initializing private_destroy_list.  We don't need to
initialize it with LIST_HEAD() beforehand.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/notify/mark.c~fs-notify-markc-trivial-cleanup fs/notify/mark.c
--- a/fs/notify/mark.c~fs-notify-markc-trivial-cleanup
+++ a/fs/notify/mark.c
@@ -340,7 +340,7 @@ void fsnotify_init_mark(struct fsnotify_
 static int fsnotify_mark_destroy(void *ignored)
 {
 	struct fsnotify_mark *mark, *next;
-	LIST_HEAD(private_destroy_list);
+	struct list_head private_destroy_list;
 
 	for (;;) {
 		spin_lock(&destroy_lock);
_

Patches currently in -mm which might be from david.a.cohen@linux.intel.com are

origin.patch
linux-next.patch

