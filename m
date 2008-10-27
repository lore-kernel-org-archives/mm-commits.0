From: akpm@linux-foundation.org
Subject: + kill-suid-bit-only-for-regular-files.patch added to -mm tree
Date: Sun, 26 Oct 2008 21:48:01 -0700
Message-ID: <200810270448.m9R4m13T020731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbYJ0EsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 00:48:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, viro@zeniv.linux.org.uk


The patch titled
     kill suid bit only for regular files
has been added to the -mm tree.  Its filename is
     kill-suid-bit-only-for-regular-files.patch

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
Subject: kill suid bit only for regular files
From: Dmitri Monakhov <dmonakhov@openvz.org>

We don't have to do it because it is useless for non regular files.
In fact block device may trigger this path without dentry->d_inode->i_mutex.

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~kill-suid-bit-only-for-regular-files mm/filemap.c
--- a/mm/filemap.c~kill-suid-bit-only-for-regular-files
+++ a/mm/filemap.c
@@ -1765,7 +1765,7 @@ int should_remove_suid(struct dentry *de
 	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
 		kill |= ATTR_KILL_SGID;
 
-	if (unlikely(kill && !capable(CAP_FSETID)))
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
 		return kill;
 
 	return 0;
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

kill-suid-bit-only-for-regular-files.patch

