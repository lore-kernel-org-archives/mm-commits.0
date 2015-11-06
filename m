From: akpm@linux-foundation.org
Subject: [merged] inotify-hide-internal-kernel-bits-from-fdinfo.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:05:34 -0800
Message-ID: <563d080e.+z5uoyYy9ydzfJQp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032264AbbKFUFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, avagin@gmail.com, avagin@openvz.org, eparis@redhat.com, gorcunov@openvz.org, john@johnmccutchan.com, rlove@rlove.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify: hide internal kernel bits from fdinfo
has been removed from the -mm tree.  Its filename was
     inotify-hide-internal-kernel-bits-from-fdinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: inotify: hide internal kernel bits from fdinfo

There was a report that my patch:

	inotify: actually check for invalid bits in sys_inotify_add_watch()

broke CRIU.

The reason is that CRIU looks up raw flags in /proc/$pid/fdinfo/* to
figure out how to rebuild inotify watches and then passes those flags
directly back in to the inotify API.  One of those flags
(FS_EVENT_ON_CHILD) is set in mark->mask, but is not part of the inotify
API.  It is used inside the kernel to _implement_ inotify but it is not
and has never been part of the API.

My patch above ensured that we only allow bits which are part of the API
(IN_ALL_EVENTS).  This broke CRIU.

FS_EVENT_ON_CHILD is really internal to the kernel.  It is set _anyway_ on
all inotify marks.  So, CRIU was really just trying to set a bit that was
already set.

This patch hides that bit from fdinfo.  CRIU will not see the bit, not try
to set it, and should work as before.  We should not have been exposing
this bit in the first place, so this is a good patch independent of the
CRIU problem.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reported-by: Andrey Wagin <avagin@gmail.com>
Acked-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Eric Paris <eparis@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/notify/fdinfo.c~inotify-hide-internal-kernel-bits-from-fdinfo fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~inotify-hide-internal-kernel-bits-from-fdinfo
+++ a/fs/notify/fdinfo.c
@@ -83,9 +83,16 @@ static void inotify_fdinfo(struct seq_fi
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(mark->inode);
 	if (inode) {
+		/*
+		 * IN_ALL_EVENTS represents all of the mask bits
+		 * that we expose to userspace.  There is at
+		 * least one bit (FS_EVENT_ON_CHILD) which is
+		 * used only internally to the kernel.
+		 */
+		u32 mask = mark->mask & IN_ALL_EVENTS;
 		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:%x ",
 			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
-			   mark->mask, mark->ignored_mask);
+			   mask, mark->ignored_mask);
 		show_mark_fhandle(m, inode);
 		seq_putc(m, '\n');
 		iput(inode);
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-hugetlb-use-memory-policy-when-available.patch
mm-hugetlbfs-optimize-when-numa=n.patch

