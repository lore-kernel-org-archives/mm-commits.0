From: akpm@linux-foundation.org
Subject: + fanotify-check-file-flags-passed-in-fanotify_init.patch added
 to -mm tree
Date: Wed, 14 May 2014 16:59:01 -0700
Message-ID: <53740345.XMxBS54RkpnJB93+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaENX7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 19:59:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, jack@suse.cz, Valdis.Kletnieks@vt.edu, xypron.glpk@gmx.de

Subject: + fanotify-check-file-flags-passed-in-fanotify_init.patch added to -mm tree
To: xypron.glpk@gmx.de,Valdis.Kletnieks@vt.edu,jack@suse.cz,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 16:59:01 -0700


The patch titled
     Subject: fanotify: check file flags passed in fanotify_init
has been added to the -mm tree.  Its filename is
     fanotify-check-file-flags-passed-in-fanotify_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-check-file-flags-passed-in-fanotify_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-check-file-flags-passed-in-fanotify_init.patch

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
Subject: fanotify: check file flags passed in fanotify_init

Without this patch fanotify_init does not validate the value passed in
event_f_flags.

When a fanotify event is read from the fanotify file descriptor a new file
descriptor is created where file.f_flags = event_f_flags.

Internal and external open flags are stored together in field f_flags of
struct file.  Hence, an application might create file descriptors with
internal flags like FMODE_EXEC, FMODE_NOCMTIME set.

Jan Kara and Eric Paris both aggreed that this is a bug and the value of
event_f_flags should be checked:
https://lkml.org/lkml/2014/4/29/522
https://lkml.org/lkml/2014/4/29/539

This updated patch version considers the comments by Michael Kerrisk in
https://lkml.org/lkml/2014/5/4/10

With the patch the value of event_f_flags is checked.
When specifying an invalid value error EINVAL is returned.

Internal flags are disallowed.

File creation flags are disallowed:
O_CREAT, O_DIRECTORY, O_EXCL, O_NOCTTY, O_NOFOLLOW, O_TRUNC, and O_TTY_INIT.

Flags which do not make sense with fanotify are disallowed:
__O_TMPFILE, O_PATH, FASYNC, and O_DIRECT.

This leaves us with the following allowed values:

O_RDONLY, O_WRONLY, O_RDWR are basic functionality. The are stored in the
bits given by O_ACCMODE.

O_APPEND is working as expected. The value might be useful in a logging
application which appends the current status each time the log is opened.

O_LARGEFILE is needed for files exceeding 4GB on 32bit systems.

O_NONBLOCK may be useful when monitoring slow devices like tapes.

O_NDELAY is equal to O_NONBLOCK except for platform parisc.
To avoid code breaking on parisc either both flags should be
allowed or none. The patch allows both.

__O_SYNC and O_DSYNC may be used to avoid data loss on power disruption.

O_NOATIME may be useful to reduce disk activity.

O_CLOEXEC may be useful, if separate processes shall be used to scan files.

Once this patch is accepted, the fanotify_init.2 manpage has to be updated.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-check-file-flags-passed-in-fanotify_init fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-check-file-flags-passed-in-fanotify_init
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -25,6 +25,19 @@
 #define FANOTIFY_DEFAULT_MAX_MARKS	8192
 #define FANOTIFY_DEFAULT_MAX_LISTENERS	128
 
+/*
+ * All flags that may be specified in parameter event_f_flags of fanotify_init.
+ *
+ * Internal and external open flags are stored together in field f_flags of
+ * struct file. Only external open flags shall be allowed in event_f_flags.
+ * Internal flags like FMODE_NONOTIFY, FMODE_EXEC, FMODE_NOCMTIME shall be
+ * excluded.
+ */
+#define	FANOTIFY_INIT_ALL_EVENT_F_BITS				( \
+		O_ACCMODE	| O_APPEND	| O_NONBLOCK	| \
+		__O_SYNC	| O_DSYNC	| O_CLOEXEC     | \
+		O_LARGEFILE	| O_NOATIME	)
+
 extern const struct fsnotify_ops fanotify_fsnotify_ops;
 
 static struct kmem_cache *fanotify_mark_cache __read_mostly;
@@ -669,6 +682,18 @@ SYSCALL_DEFINE2(fanotify_init, unsigned
 	if (flags & ~FAN_ALL_INIT_FLAGS)
 		return -EINVAL;
 
+	if (event_f_flags & ~FANOTIFY_INIT_ALL_EVENT_F_BITS)
+		return -EINVAL;
+
+	switch (event_f_flags & O_ACCMODE) {
+	case O_RDONLY:
+	case O_RDWR:
+	case O_WRONLY:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	user = get_current_user();
 	if (atomic_read(&user->fanotify_listeners) > FANOTIFY_DEFAULT_MAX_LISTENERS) {
 		free_uid(user);
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch
fanotify-create-fan_access-event-for-readdir.patch
fs-notify-fanotify-fanotify_userc-fix-fan_mark_flush-flag-checking.patch
fanotify-check-file-flags-passed-in-fanotify_init.patch

