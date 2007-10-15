From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch added to -mm tree
Date: Sun, 14 Oct 2007 18:01:28 -0700
Message-ID: <200710150101.l9F11S1k010592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578AbXJOBBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 14 Oct 2007 21:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, haveblue@us.ibm.com


The patch titled
     r/o bind mounts: Dont touch the vfsmount after path_put()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: Dont touch the vfsmount after path_put()
From: Jan Blunck <jblunck@suse.de>

mnt_drop_write() is called after releasing the reference to the path with
path_put().

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/unix/af_unix.c~r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix net/unix/af_unix.c
--- a/net/unix/af_unix.c~r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix
+++ a/net/unix/af_unix.c
@@ -752,8 +752,8 @@ static struct sock *unix_find_other(stru
 		if (u->sk_type == type)
 			touch_atime(nd.mnt, nd.dentry);
 
-		path_release(&nd);
 		mnt_drop_write(nd.mnt);
+		path_release(&nd);
 
 		err=-EPROTOTYPE;
 		if (u->sk_type != type) {
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
