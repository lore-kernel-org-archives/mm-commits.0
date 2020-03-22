From: Andrew Morton <akpm@linux-foundation.org>
Subject: + libfs-fix-infoleak-in-simple_attr_read.patch added to
 -mm tree
Date: Sat, 21 Mar 2020 21:39:43 -0700
Message-ID: <20200322043943.GCnF6HIYE%akpm@linux-foundation.org>
References: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgCVEtO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Mar 2020 00:49:14 -0400
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ebiggers@google.com, glider@google.com, gregkh@linuxfoundation.org, keescook@chromium.org, mm-commits@vger.kernel.org, rafael@kernel.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: libfs: fix infoleak in simple_attr_read()
has been added to the -mm tree.  Its filename is
     libfs-fix-infoleak-in-simple_attr_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/libfs-fix-infoleak-in-simple_attr_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/libfs-fix-infoleak-in-simple_attr_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: libfs: fix infoleak in simple_attr_read()

Reading from a debugfs file at a nonzero position, without first reading
at position 0, leaks uninitialized memory to userspace.

It's a bit tricky to do this, since lseek() and pread() aren't allowed on
these files, and write() doesn't update the position on them.  But writing
to them with splice() *does* update the position:

	#define _GNU_SOURCE 1
	#include <fcntl.h>
	#include <stdio.h>
	#include <unistd.h>
	int main()
	{
		int pipes[2], fd, n, i;
		char buf[32];

		pipe(pipes);
		write(pipes[1], "0", 1);
		fd = open("/sys/kernel/debug/fault_around_bytes", O_RDWR);
		splice(pipes[0], NULL, fd, NULL, 1, 0);
		n = read(fd, buf, sizeof(buf));
		for (i = 0; i < n; i++)
			printf("%02x", buf[i]);
		printf("
");
	}

Output:
	5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a30

Fix the infoleak by making simple_attr_read() always fill
simple_attr::get_buf if it hasn't been filled yet.

Link: http://lkml.kernel.org/r/20200308023849.988264-1-ebiggers@kernel.org
Fixes: acaefc25d21f ("[PATCH] libfs: add simple attribute files")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reported-by: syzbot+fcab69d1ada3e8d6f06b@syzkaller.appspotmail.com
Reported-by: Alexander Potapenko <glider@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/libfs.c~libfs-fix-infoleak-in-simple_attr_read
+++ a/fs/libfs.c
@@ -891,7 +891,7 @@ int simple_attr_open(struct inode *inode
 {
 	struct simple_attr *attr;
 
-	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
 	if (!attr)
 		return -ENOMEM;
 
@@ -931,9 +931,11 @@ ssize_t simple_attr_read(struct file *fi
 	if (ret)
 		return ret;
 
-	if (*ppos) {		/* continued read */
+	if (*ppos && attr->get_buf[0]) {
+		/* continued read */
 		size = strlen(attr->get_buf);
-	} else {		/* first read */
+	} else {
+		/* first read */
 		u64 val;
 		ret = attr->get(attr->data, &val);
 		if (ret)
_

Patches currently in -mm which might be from ebiggers@google.com are

libfs-fix-infoleak-in-simple_attr_read.patch
kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
docs-admin-guide-document-the-kernelmodprobe-sysctl.patch
selftests-kmod-fix-handling-test-numbers-above-9.patch
selftests-kmod-test-disabling-module-autoloading.patch
