From: akpm@linux-foundation.org
Subject: +
 inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2.patch
 added to -mm tree
Date: Thu, 10 Sep 2015 14:53:55 -0700
Message-ID: <55f1fbf3.ErL49srrcXp01yF0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbbIJVx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 17:53:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, eparis@parisplace.org, john@johnmccutchan.com, rlove@rlove.org, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2
has been added to the -mm tree.  Its filename is
     inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2 fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2
+++ a/fs/notify/inotify/inotify_user.c
@@ -706,10 +706,19 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	int ret;
 	unsigned flags = 0;
 
-	/* don't allow invalid bits: we don't want flags set */
+	/*
+	 * We share a lot of code with fs/dnotify.  We also share
+	 * the bit layout between inotify's IN_* and the fsnotify
+	 * FS_*.  This check ensures that only the inotify IN_*
+	 * bits get passed in and set in watches/events.
+	 */
 	if (unlikely(mask & ~ALL_INOTIFY_BITS))
 		return -EINVAL;
-	/* require at least one valid bit set in the mask */
+	/*
+	 * Require at least one valid bit set in the mask.
+	 * Without _something_ set, we would have no events to
+	 * watch for.
+	 */
 	if (unlikely(!(mask & ALL_INOTIFY_BITS)))
 		return -EINVAL;
 
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch
inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2.patch

