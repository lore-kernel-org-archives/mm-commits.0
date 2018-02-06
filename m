From: akpm@linux-foundation.org
Subject: [patch 102/114] pipe: reject F_SETPIPE_SZ with size over
 UINT_MAX
Date: Tue, 06 Feb 2018 15:42:00 -0800
Message-ID: <20180206234200.xXwC8ypiG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbeBFXmD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:42:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiggers@google.com, joe.lawrence@redhat.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, mpatocka@redhat.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, w@1wt.eu

From: Eric Biggers <ebiggers@google.com>
Subject: pipe: reject F_SETPIPE_SZ with size over UINT_MAX

A pipe's size is represented as an 'unsigned int'.  As expected, writing a
value greater than UINT_MAX to /proc/sys/fs/pipe-max-size fails with
EINVAL.  However, the F_SETPIPE_SZ fcntl silently truncates such values to
32 bits, rather than failing with EINVAL as expected.  (It *does* fail
with EINVAL for values above (1 << 31) but <= UINT_MAX.)

Fix this by moving the check against UINT_MAX into round_pipe_size() which
is called in both cases.

Link: http://lkml.kernel.org/r/20180111052902.14409-6-ebiggers3@gmail.com
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

 fs/pipe.c                 |    5 ++++-
 include/linux/pipe_fs_i.h |    2 +-
 kernel/sysctl.c           |    3 ---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/pipe.c~pipe-reject-f_setpipe_sz-with-size-over-uint_max fs/pipe.c
--- a/fs/pipe.c~pipe-reject-f_setpipe_sz-with-size-over-uint_max
+++ a/fs/pipe.c
@@ -1020,10 +1020,13 @@ const struct file_operations pipefifo_fo
  * Currently we rely on the pipe array holding a power-of-2 number
  * of pages. Returns 0 on error.
  */
-unsigned int round_pipe_size(unsigned int size)
+unsigned int round_pipe_size(unsigned long size)
 {
 	unsigned long nr_pages;
 
+	if (size > UINT_MAX)
+		return 0;
+
 	/* Minimum pipe size, as required by POSIX */
 	if (size < PAGE_SIZE)
 		size = PAGE_SIZE;
diff -puN include/linux/pipe_fs_i.h~pipe-reject-f_setpipe_sz-with-size-over-uint_max include/linux/pipe_fs_i.h
--- a/include/linux/pipe_fs_i.h~pipe-reject-f_setpipe_sz-with-size-over-uint_max
+++ a/include/linux/pipe_fs_i.h
@@ -190,6 +190,6 @@ long pipe_fcntl(struct file *, unsigned
 struct pipe_inode_info *get_pipe_info(struct file *file);
 
 int create_pipe_files(struct file **, int);
-unsigned int round_pipe_size(unsigned int size);
+unsigned int round_pipe_size(unsigned long size);
 
 #endif
diff -puN kernel/sysctl.c~pipe-reject-f_setpipe_sz-with-size-over-uint_max kernel/sysctl.c
--- a/kernel/sysctl.c~pipe-reject-f_setpipe_sz-with-size-over-uint_max
+++ a/kernel/sysctl.c
@@ -2623,9 +2623,6 @@ static int do_proc_dopipe_max_size_conv(
 	if (write) {
 		unsigned int val;
 
-		if (*lvalp > UINT_MAX)
-			return -EINVAL;
