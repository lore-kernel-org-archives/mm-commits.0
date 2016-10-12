From: akpm@linux-foundation.org
Subject: [merged] autofs-fix-pr_debug-message.patch removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:59 -0700
Message-ID: <57fe8dcf.boDO3U2nzae1hhIY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33289 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756023AbcJLTYg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix pr_debug() message
has been removed from the -mm tree.  Its filename was
     autofs-fix-pr_debug-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: fix pr_debug() message

This isn't a return value, so change the message to indicate the status is
the result of may_umount().

(or locate pr_debug() after put_user() with the same message)

Link: http://lkml.kernel.org/r/20160812024836.12352.74628.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/root.c~autofs-fix-pr_debug-message fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-fix-pr_debug-message
+++ a/fs/autofs4/root.c
@@ -840,7 +840,7 @@ static inline int autofs4_ask_umount(str
 	if (may_umount(mnt))
 		status = 1;
 
-	pr_debug("returning %d\n", status);
+	pr_debug("may umount %d\n", status);
 
 	status = put_user(status, p);
 
_

Patches currently in -mm which might be from kusumi.tomohiro@gmail.com are


