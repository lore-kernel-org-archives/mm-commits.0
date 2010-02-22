From: akpm@linux-foundation.org
Subject: + vfs-clarify-that-nonseekable_open-will-never-fail.patch added to -mm tree
Date: Mon, 22 Feb 2010 12:55:45 -0800
Message-ID: <201002222055.o1MKtjtY022536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab0BVU4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 15:56:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, arnd@arndb.de, dtor@mail.ru, jkacur@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: clarify that nonseekable_open() will never fail
has been added to the -mm tree.  Its filename is
     vfs-clarify-that-nonseekable_open-will-never-fail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: clarify that nonseekable_open() will never fail
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: John Kacur <jkacur@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/open.c~vfs-clarify-that-nonseekable_open-will-never-fail fs/open.c
--- a/fs/open.c~vfs-clarify-that-nonseekable_open-will-never-fail
+++ a/fs/open.c
@@ -1201,7 +1201,9 @@ EXPORT_SYMBOL(generic_file_open);
 
 /*
  * This is used by subsystems that don't want seekable
- * file descriptors
+ * file descriptors. The function is not supposed to ever fail, the only
+ * reason it returns an 'int' and not 'void' is so that it can be plugged
+ * directly into file_operations structure.
  */
 int nonseekable_open(struct inode *inode, struct file *filp)
 {
_

Patches currently in -mm which might be from dmitry.torokhov@gmail.com are

linux-next.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
vfs-clarify-that-nonseekable_open-will-never-fail.patch

