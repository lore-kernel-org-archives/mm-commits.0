From: akpm@linux-foundation.org
Subject: + fallocate-create-fan_modify-and-in_modify-events.patch added to -mm tree
Date: Mon, 20 Oct 2014 13:41:20 -0700
Message-ID: <54457370.QDfpdoAYt8Tubq3M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaJTUlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 16:41:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, david@fromorbit.com, eparis@parisplace.org, jack@suse.cz, john@johnmccutchan.com, mtk.manpages@gmail.com, rlove@rlove.org, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fallocate: create FAN_MODIFY and IN_MODIFY events
has been added to the -mm tree.  Its filename is
     fallocate-create-fan_modify-and-in_modify-events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fallocate-create-fan_modify-and-in_modify-events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fallocate-create-fan_modify-and-in_modify-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: fallocate: create FAN_MODIFY and IN_MODIFY events

The fanotify and the inotify API can be used to monitor changes of the
file system.  System call fallocate() modifies files.  Hence it should
trigger the corresponding fanotify (FAN_MODIFY) and inotify (IN_MODIFY)
events.  The most interesting case is FALLOC_FL_COLLAPSE_RANGE because
this value allows to create arbitrary file content from random data.

This patch adds the missing call to fsnotify_modify().

The FAN_MODIFY and IN_MODIFY event will be created when fallocate()
succeeds.  It will even be created if the file length remains unchanged,
e.g.  when calling fanotify with flag FALLOC_FL_KEEP_SIZE.

This logic was primarily chosen to keep the coding simple.

It resembles the logic of the write() system call.

When we call write() we always create a FAN_MODIFY event, even in the case
of overwriting with identical data.

Events FAN_MODIFY and IN_MODIFY do not provide any guarantee that data was
actually changed.

Furthermore even if if the filesize remains unchanged, fallocate() may
influence whether a subsequent write() will succeed and hence the
fallocate() call may be considered a modification.

The fallocate(2) man page teaches: After a successful call, subsequent
writes into the range specified by offset and len are guaranteed not to
fail because of lack of disk space.

So calling fallocate(fd, FALLOC_FL_KEEP_SIZE, offset, len) may result in
offset and len.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN fs/open.c~fallocate-create-fan_modify-and-in_modify-events fs/open.c
--- a/fs/open.c~fallocate-create-fan_modify-and-in_modify-events
+++ a/fs/open.c
@@ -295,6 +295,17 @@ int do_fallocate(struct file *file, int
 
 	sb_start_write(inode->i_sb);
 	ret = file->f_op->fallocate(file, mode, offset, len);
+
+	/*
+	 * Create inotify and fanotify events.
+	 *
+	 * To keep the logic simple always create events if fallocate succeeds.
+	 * This implies that events are even created if the file size remains
+	 * unchanged, e.g. when using flag FALLOC_FL_KEEP_SIZE.
+	 */
+	if (ret == 0)
+		fsnotify_modify(file);
+
 	sb_end_write(inode->i_sb);
 	return ret;
 }
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

fallocate-create-fan_modify-and-in_modify-events.patch

