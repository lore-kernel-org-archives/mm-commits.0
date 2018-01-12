From: akpm@linux-foundation.org
Subject: +
 pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter.patch added to
 -mm tree
Date: Thu, 11 Jan 2018 16:16:12 -0800
Message-ID: <5a57fe4c.Y4rJb/wmRzHT+hfS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbeALAQO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jan 2018 19:16:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, joe.lawrence@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe, sysctl: drop 'min' parameter from pipe-max-size converter
has been added to the -mm tree.  Its filename is
     pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: pipe, sysctl: drop 'min' parameter from pipe-max-size converter

Patch series "pipe: buffer limits fixes and cleanups", v2.

This series simplifies the sysctl handler for pipe-max-size and fixes
another set of bugs related to the pipe buffer limits:

- The root user wasn't allowed to exceed the limits when creating new
  pipes.

- There was an off-by-one error when checking the limits, so a limit of
  N was actually treated as N - 1.

- F_SETPIPE_SZ accepted values over UINT_MAX.

- Reading the pipe buffer limits could be racy.


This patch (of 7):

Before validating the given value against pipe_min_size,
do_proc_dopipe_max_size_conv() calls round_pipe_size(), which rounds the
value up to pipe_min_size.  Therefore, the second check against
pipe_min_size is redundant.  Remove it.

Link: http://lkml.kernel.org/r/20180111052902.14409-2-ebiggers3@gmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c                 |   10 +++-------
 include/linux/pipe_fs_i.h |    2 +-
 kernel/sysctl.c           |   15 +--------------
 3 files changed, 5 insertions(+), 22 deletions(-)

diff -puN fs/pipe.c~pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter fs/pipe.c
--- a/fs/pipe.c~pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter
+++ a/fs/pipe.c
@@ -35,11 +35,6 @@
  */
 unsigned int pipe_max_size = 1048576;
 
-/*
- * Minimum pipe size, as required by POSIX
- */
-unsigned int pipe_min_size = PAGE_SIZE;
-
 /* Maximum allocatable pages per user. Hard limit is unset by default, soft
  * matches default values.
  */
@@ -1024,8 +1019,9 @@ unsigned int round_pipe_size(unsigned in
 {
 	unsigned long nr_pages;
 
-	if (size < pipe_min_size)
-		size = pipe_min_size;
+	/* Minimum pipe size, as required by POSIX */
+	if (size < PAGE_SIZE)
+		size = PAGE_SIZE;
 
 	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (nr_pages == 0)
diff -puN include/linux/pipe_fs_i.h~pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter include/linux/pipe_fs_i.h
--- a/include/linux/pipe_fs_i.h~pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter
+++ a/include/linux/pipe_fs_i.h
@@ -167,7 +167,7 @@ void pipe_lock(struct pipe_inode_info *)
 void pipe_unlock(struct pipe_inode_info *);
 void pipe_double_lock(struct pipe_inode_info *, struct pipe_inode_info *);
 
-extern unsigned int pipe_max_size, pipe_min_size;
+extern unsigned int pipe_max_size;
 extern unsigned long pipe_user_pages_hard;
 extern unsigned long pipe_user_pages_soft;
 int pipe_proc_fn(struct ctl_table *, int, void __user *, size_t *, loff_t *);
diff -puN kernel/sysctl.c~pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter kernel/sysctl.c
--- a/kernel/sysctl.c~pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter
+++ a/kernel/sysctl.c
@@ -1813,7 +1813,6 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(pipe_max_size),
 		.mode		= 0644,
 		.proc_handler	= &pipe_proc_fn,
-		.extra1		= &pipe_min_size,
 	},
 	{
 		.procname	= "pipe-user-pages-hard",
@@ -2615,16 +2614,10 @@ int proc_douintvec_minmax(struct ctl_tab
 				 do_proc_douintvec_minmax_conv, &param);
 }
 
-struct do_proc_dopipe_max_size_conv_param {
-	unsigned int *min;
-};
-
 static int do_proc_dopipe_max_size_conv(unsigned long *lvalp,
 					unsigned int *valp,
 					int write, void *data)
 {
-	struct do_proc_dopipe_max_size_conv_param *param = data;
-
 	if (write) {
 		unsigned int val;
 
@@ -2635,9 +2628,6 @@ static int do_proc_dopipe_max_size_conv(
 		if (val == 0)
 			return -EINVAL;
 
-		if (param->min && *param->min > val)
-			return -ERANGE;
-
 		*valp = val;
 	} else {
 		unsigned int val = *valp;
@@ -2650,11 +2640,8 @@ static int do_proc_dopipe_max_size_conv(
 int proc_dopipe_max_size(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct do_proc_dopipe_max_size_conv_param param = {
-		.min = (unsigned int *) table->extra1,
-	};
 	return do_proc_douintvec(table, write, buffer, lenp, ppos,
-				 do_proc_dopipe_max_size_conv, &param);
+				 do_proc_dopipe_max_size_conv, NULL);
 }
 
 static void validate_coredump_safety(void)
_

Patches currently in -mm which might be from ebiggers@google.com are

userfaultfd-convert-to-use-anon_inode_getfd.patch
pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter.patch
pipe-sysctl-remove-pipe_proc_fn.patch
pipe-actually-allow-root-to-exceed-the-pipe-buffer-limits.patch
pipe-fix-off-by-one-error-when-checking-buffer-limits.patch
pipe-reject-f_setpipe_sz-with-size-over-uint_max.patch
pipe-simplify-round_pipe_size.patch
pipe-read-buffer-limits-atomically.patch

