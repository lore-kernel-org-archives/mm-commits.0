From: akpm@linux-foundation.org
Subject: [patch 041/102] autofs: fix pr_debug() message
Date: Tue, 11 Oct 2016 13:52:59 -0700
Message-ID: <57fd512b.KEL/DdtwDUwN673s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753334AbcJKUxG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@gmail.com, ikent@redhat.com

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
