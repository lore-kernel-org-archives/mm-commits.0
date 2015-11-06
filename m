From: akpm@linux-foundation.org
Subject: [merged]
 inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:05:37 -0800
Message-ID: <563d0811.yQYlfYHDXZ/wlnnc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032264AbbKFUFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, eparis@parisplace.org, john@johnmccutchan.com, jwboyer@fedoraproject.org, rlove@rlove.org, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify: actually check for invalid bits in sys_inotify_add_watch()
has been removed from the -mm tree.  Its filename was
     inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: inotify: actually check for invalid bits in sys_inotify_add_watch()

The comment here says that it is checking for invalid bits.  But, the mask
is *actually* checking to ensure that _any_ valid bit is set, which is
quite different.

Without this check, an unexpected bit could get set on an inotify object. 
Since these bits are also interpreted by the fsnotify/dnotify code, there
is the potential for an object to be mishandled inside the kernel.  For
instance, can we be sure that setting the dnotify flag FS_DN_RENAME on an
inotify watch is harmless?

Add the actual check which was intended.  Retain the existing inotify bits
are being added to the watch.  Plus, this is existing behavior which would
be nice to preserve.

I did a quick sniff test that inotify functions and that my
'inotify-tools' package passes 'make check'.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch
+++ a/fs/notify/inotify/inotify_user.c
@@ -706,7 +706,19 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	int ret;
 	unsigned flags = 0;
 
-	/* don't allow invalid bits: we don't want flags set */
+	/*
+	 * We share a lot of code with fs/dnotify.  We also share
+	 * the bit layout between inotify's IN_* and the fsnotify
+	 * FS_*.  This check ensures that only the inotify IN_*
+	 * bits get passed in and set in watches/events.
+	 */
+	if (unlikely(mask & ~ALL_INOTIFY_BITS))
+		return -EINVAL;
+	/*
+	 * Require at least one valid bit set in the mask.
+	 * Without _something_ set, we would have no events to
+	 * watch for.
+	 */
 	if (unlikely(!(mask & ALL_INOTIFY_BITS)))
 		return -EINVAL;
 
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-hugetlb-use-memory-policy-when-available.patch
mm-hugetlbfs-optimize-when-numa=n.patch

