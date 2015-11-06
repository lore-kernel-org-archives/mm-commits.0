From: akpm@linux-foundation.org
Subject: [folded-merged]
 inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2.patch
 removed from -mm tree
Date: Thu, 05 Nov 2015 18:21:19 -0800
Message-ID: <563c0e9f.h5e1ELCRvF6nRoua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:21:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, eparis@parisplace.org, john@johnmccutchan.com, rlove@rlove.org, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2
has been removed from the -mm tree.  Its filename was
     inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2.patch

This patch was dropped because it was folded into inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch

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

inotify-hide-internal-kernel-bits-from-fdinfo.patch
inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch
mm-hugetlb-use-memory-policy-when-available.patch
mm-hugetlb-use-memory-policy-when-available-fix.patch
mm-hugetlbfs-optimize-when-numa=n.patch

