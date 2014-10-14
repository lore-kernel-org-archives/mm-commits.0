From: akpm@linux-foundation.org
Subject: + file-remove-get_unused_fd-macro.patch added to -mm tree
Date: Tue, 14 Oct 2014 13:28:02 -0700
Message-ID: <543d8752.B1BVDaR2uEMZi9u4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbaJNU2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 16:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ydroneaud@opteya.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/file.h: remove get_unused_fd() macro
has been added to the -mm tree.  Its filename is
     file-remove-get_unused_fd-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/file-remove-get_unused_fd-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/file-remove-get_unused_fd-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yann Droneaud <ydroneaud@opteya.com>
Subject: include/linux/file.h: remove get_unused_fd() macro

Macro get_unused_fd() is used to allocate a file descriptor with default
flags.  Those default flags (0) don't enable close-on-exec.

This can be seen as an unsafe default: in most case close-on-exec should
be enabled to not leak file descriptor across exec().

It would be better to have a "safer" default set of flags, eg.  O_CLOEXEC
must be used to enable close-on-exec.

Instead this patch removes get_unused_fd() so that out of tree modules
won't be affect by a runtime behavor change which might introduce other
kind of bugs: it's better to catch the change at build time, making it
easier to fix.

Removing the macro will also promote use of get_unused_fd_flags() (or
anon_inode_getfd()) with flags provided by userspace.  Or, if flags cannot
be given by userspace, with flags set to O_CLOEXEC by default.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/file.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/file.h~file-remove-get_unused_fd-macro include/linux/file.h
--- a/include/linux/file.h~file-remove-get_unused_fd-macro
+++ a/include/linux/file.h
@@ -66,7 +66,6 @@ extern void set_close_on_exec(unsigned i
 extern bool get_close_on_exec(unsigned int fd);
 extern void put_filp(struct file *);
 extern int get_unused_fd_flags(unsigned flags);
-#define get_unused_fd() get_unused_fd_flags(0)
 extern void put_unused_fd(unsigned int fd);
 
 extern void fd_install(unsigned int fd, struct file *file);
_

Patches currently in -mm which might be from ydroneaud@opteya.com are

origin.patch
ia64-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
ppc-cell-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
binfmt_misc-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
file-trivial-replace-get_unused_fd-by-get_unused_fd_flags0.patch
file-remove-get_unused_fd-macro.patch

