From: akpm@linux-foundation.org
Subject: + fs-optimize-inotify-fsnotify-code-for-unwatched-files.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 14:09:36 -0700
Message-ID: <55a57a90.3azagjlOXDSPZsZE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbbGNVJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 17:09:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, ak@linux.intel.com, eparis@redhat.com, jack@suse.com, john@johnmccutchan.com, rlove@rlove.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/notify: optimize inotify/fsnotify code for unwatched files
has been added to the -mm tree.  Its filename is
     fs-optimize-inotify-fsnotify-code-for-unwatched-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-optimize-inotify-fsnotify-code-for-unwatched-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-optimize-inotify-fsnotify-code-for-unwatched-files.patch

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
Subject: fs/notify: optimize inotify/fsnotify code for unwatched files

I have a _tiny_ microbenchmark that sits in a loop and writes single bytes
to a file.  Writing one byte to a tmpfs file is around 2x slower than
reading one byte from a file, which is a _bit_ more than I expecte.  This
is a dumb benchmark, but I think it's hard to deny that write() is a hot
path and we should avoid unnecessary overhead there.

I did a 'perf record' of 30-second samples of read and write.  The top
item in a diffprofile is srcu_read_lock() from fsnotify().  There are
active inotify fd's from systemd, but nothing is actually listening to the
file or its part of the filesystem.

I *think* we can avoid taking the srcu_read_lock() for the common case
where there are no actual marks on the file.  This means that there will
both be nothing to notify for *and* implies that there is no need for
clearing the ignore mask.

This patch gave a 13.1% speedup in writes/second on my test, which is an
improvement from the 10.8% that I saw with the last version.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/notify/fsnotify.c~fs-optimize-inotify-fsnotify-code-for-unwatched-files fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fs-optimize-inotify-fsnotify-code-for-unwatched-files
+++ a/fs/notify/fsnotify.c
@@ -205,6 +205,16 @@ int fsnotify(struct inode *to_tell, __u3
 		mnt = NULL;
 
 	/*
+	 * Optimization: srcu_read_lock() has a memory barrier which can
+	 * be expensive.  It protects walking the *_fsnotify_marks lists.
+	 * However, if we do not walk the lists, we do not have to do
+	 * SRCU because we have no references to any objects and do not
+	 * need SRCU to keep them "alive".
+	 */
+	if (hlist_empty(&to_tell->i_fsnotify_marks) &&
+	    (!mnt || hlist_empty(&mnt->mnt_fsnotify_marks)))
+		return 0;
+	/*
 	 * if this is a modify event we may need to clear the ignored masks
 	 * otherwise return if neither the inode nor the vfsmount care about
 	 * this type of event.
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

fs-optimize-inotify-fsnotify-code-for-unwatched-files.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

