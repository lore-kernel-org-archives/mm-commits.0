From: akpm@linux-foundation.org
Subject: + vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check.patch
 added to -mm tree
Date: Tue, 06 Jan 2015 16:29:21 -0800
Message-ID: <54ac7de1.yd9G2MbE2sKqJDI2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbbAGA3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 19:29:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drysdale@google.com, arnd@arndb.de, davem@davemloft.net, eparis@redhat.com, jack@suse.cz, sfr@canb.auug.org.au, viro@zeniv.linux.org.uk, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: renumber FMODE_NONOTIFY and add to uniqueness check
has been added to the -mm tree.  Its filename is
     vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Drysdale <drysdale@google.com>
Subject: vfs: renumber FMODE_NONOTIFY and add to uniqueness check

Fix clashing values for O_PATH and FMODE_NONOTIFY on sparc.  The clashing
O_PATH value was added in 5229645bdc35f1cc43eb ("vfs: add nonconflicting
values for O_PATH") but this can't be changed as it is user-visible.

FMODE_NONOTIFY is only used internally in the kernel, but it is in the
same numbering space as the other O_* flags, as indicated by the comment
at the top of include/uapi/asm-generic/fcntl.h (and its use in
fs/notify/fanotify/fanotify_user.c).  So renumber it to avoid the clash.

All of this has happened before (12ed2e36c98aec6c4155, "fanotify:
FMODE_NONOTIFY and __O_SYNC in sparc conflict"), and all of this will
happen again -- so update the uniqueness check in fcntl_init() to include
__FMODE_NONOTIFY.

Signed-off-by: David Drysdale <drysdale@google.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c                       |    5 +++--
 include/linux/fs.h               |    2 +-
 include/uapi/asm-generic/fcntl.h |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/fcntl.c~vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check fs/fcntl.c
--- a/fs/fcntl.c~vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check
+++ a/fs/fcntl.c
@@ -740,14 +740,15 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(20 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
-		__FMODE_EXEC	| O_PATH	| __O_TMPFILE
+		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
+		__FMODE_NONOTIFY
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff -puN include/linux/fs.h~vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check include/linux/fs.h
--- a/include/linux/fs.h~vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check
+++ a/include/linux/fs.h
@@ -135,7 +135,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define FMODE_CAN_WRITE         ((__force fmode_t)0x40000)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
-#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
+#define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
diff -puN include/uapi/asm-generic/fcntl.h~vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check include/uapi/asm-generic/fcntl.h
--- a/include/uapi/asm-generic/fcntl.h~vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check
+++ a/include/uapi/asm-generic/fcntl.h
@@ -5,7 +5,7 @@
 
 /*
  * FMODE_EXEC is 0x20
- * FMODE_NONOTIFY is 0x1000000
+ * FMODE_NONOTIFY is 0x4000000
  * These cannot be used by userspace O_* until internal and external open
  * flags are split.
  * -Eric Paris
_

Patches currently in -mm which might be from drysdale@google.com are

vfs-renumber-fmode_nonotify-and-add-to-uniqueness-check.patch
linux-next.patch

