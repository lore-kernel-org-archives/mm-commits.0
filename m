From: akpm@linux-foundation.org
Subject: + fs-fix-comment-of-generic_file_llseek.patch added to -mm tree
Date: Thu, 25 Apr 2013 14:16:23 -0700
Message-ID: <20130425211623.6D55031C19E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:37800 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab3DYVQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Apr 2013 17:16:24 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so124549ggc.0
        for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2013 14:16:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom.leiming@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/read_write.c: fix generic_file_llseek() comment
has been added to the -mm tree.  Its filename is
     fs-fix-comment-of-generic_file_llseek.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Lei <tom.leiming@gmail.com>
Subject: fs/read_write.c: fix generic_file_llseek() comment

Commit ef3d0fd2 (:vfs: do (nearly) lockless generic_file_llseek:) has
removed i_mutex from generic_file_llseek, so update the comment
accordingly.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/read_write.c~fs-fix-comment-of-generic_file_llseek fs/read_write.c
--- a/fs/read_write.c~fs-fix-comment-of-generic_file_llseek
+++ a/fs/read_write.c
@@ -128,7 +128,7 @@ EXPORT_SYMBOL(generic_file_llseek_size);
  *
  * This is a generic implemenation of ->llseek useable for all normal local
  * filesystems.  It just updates the file offset to the value specified by
- * @offset and @whence under i_mutex.
+ * @offset and @whence.
  */
 loff_t generic_file_llseek(struct file *file, loff_t offset, int whence)
 {
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

linux-next.patch
fs-fix-comment-of-generic_file_llseek.patch

