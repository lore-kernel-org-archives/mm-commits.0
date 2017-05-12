From: akpm@linux-foundation.org
Subject: + procfs-fdinfo-extend-information-about-epoll-target-files.patch added to -mm tree
Date: Fri, 12 May 2017 15:01:51 -0700
Message-ID: <591630cf.zrjTvnGw5oVqlOMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36738 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756601AbdELWBw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:01:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, avagin@virtuozzo.com, gorcunov@openvz.org, jbaron@akamai.com, luto@amacapital.net, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: fdinfo: extend information about epoll target files
has been added to the -mm tree.  Its filename is
     procfs-fdinfo-extend-information-about-epoll-target-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-fdinfo-extend-information-about-epoll-target-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-fdinfo-extend-information-about-epoll-target-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: procfs: fdinfo: extend information about epoll target files

Since it is possbile to have same number in tfd field (say file added,
closed, then nother file dup'ed to same number and added back) it is
imposible to distinguish such target files solely by their numbers.

Strictly speaking regular applications don't need to recognize these
targets at all but for checkpoint/restore sake we need to collect targets
to be able to push them back on restore stage in a proper order.

Thus lets add file position, inode and device number where this target
lays.  This three fields can be used as a primary key for sorting, and
together with kcmp help CRIU can find out an exact file target (from the
whole set of processes being checkpointed).

Link: http://lkml.kernel.org/r/20170424154423.436491881@gmail.com
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Andrei Vagin <avagin@virtuozzo.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    6 +++++-
 fs/eventpoll.c                     |    8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/proc.txt~procfs-fdinfo-extend-information-about-epoll-target-files Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-fdinfo-extend-information-about-epoll-target-files
+++ a/Documentation/filesystems/proc.txt
@@ -1786,12 +1786,16 @@ pair provide additional information part
 	pos:	0
 	flags:	02
 	mnt_id:	9
-	tfd:        5 events:       1d data: ffffffffffffffff
+	tfd:        5 events:       1d data: ffffffffffffffff pos:0 ino:61af sdev:7
 
 	where 'tfd' is a target file descriptor number in decimal form,
 	'events' is events mask being watched and the 'data' is data
 	associated with a target [see epoll(7) for more details].
 
+	The 'pos' is current offset of the target file in decimal form
+	[see lseek(2)], 'ino' and 'sdev' are inode and device numbers
+	where target file resides, all in hex format.
+
 	Fsnotify files
 	~~~~~~~~~~~~~~
 	For inotify files the format is the following
diff -puN fs/eventpoll.c~procfs-fdinfo-extend-information-about-epoll-target-files fs/eventpoll.c
--- a/fs/eventpoll.c~procfs-fdinfo-extend-information-about-epoll-target-files
+++ a/fs/eventpoll.c
@@ -960,10 +960,14 @@ static void ep_show_fdinfo(struct seq_fi
 	mutex_lock(&ep->mtx);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
+		struct inode *inode = file_inode(epi->ffd.file);
 
-		seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+		seq_printf(m, "tfd: %8d events: %8x data: %16llx "
+			   " pos:%lli ino:%lx sdev:%x\n",
 			   epi->ffd.fd, epi->event.events,
-			   (long long)epi->event.data);
+			   (long long)epi->event.data,
+			   (long long)epi->ffd.file->f_pos,
+			   inode->i_ino, inode->i_sb->s_dev);
 		if (seq_has_overflowed(m))
 			break;
 	}
_

Patches currently in -mm which might be from gorcunov@gmail.com are

procfs-fdinfo-extend-information-about-epoll-target-files.patch
kcmp-add-kcmp_epoll_tfd-mode-to-compare-epoll-target-files.patch

