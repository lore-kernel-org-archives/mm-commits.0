From: akpm@linux-foundation.org
Subject: + fs-notify-markc-trivial-cleanup.patch added to -mm tree
Date: Mon, 21 Apr 2014 12:58:08 -0700
Message-ID: <53557850.NT4GvihN/F+cZN/Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaDUT6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 15:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, david.a.cohen@linux.intel.com

Subject: + fs-notify-markc-trivial-cleanup.patch added to -mm tree
To: david.a.cohen@linux.intel.com,jack@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 12:58:08 -0700


The patch titled
     Subject: fs/notify/mark.c: trivial cleanup
has been added to the -mm tree.  Its filename is
     fs-notify-markc-trivial-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-notify-markc-trivial-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-notify-markc-trivial-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-notify-markc-trivial-cleanup.patch
linux-next.patch

