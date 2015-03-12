From: akpm@linux-foundation.org
Subject: + proc-show-locks-in-proc-pid-fdinfo-x-v2.patch added to -mm tree
Date: Thu, 12 Mar 2015 12:23:39 -0700
Message-ID: <5501e7bb.mNd29c9+wAgbibEq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbbCLTXk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 15:23:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, bfields@fieldses.org, corbet@lwn.net, gorcunov@openvz.org, jlayton@poochiereds.net, joe@perches.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-show-locks-in-proc-pid-fdinfo-x-v2
has been added to the -mm tree.  Its filename is
     proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: proc-show-locks-in-proc-pid-fdinfo-x-v2

use seq_has_overflowed() properly

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/proc/fd.c~proc-show-locks-in-proc-pid-fdinfo-x-v2 fs/proc/fd.c
--- a/fs/proc/fd.c~proc-show-locks-in-proc-pid-fdinfo-x-v2
+++ a/fs/proc/fd.c
@@ -57,17 +57,15 @@ static int seq_show(struct seq_file *m,
 		   real_mount(file->f_path.mnt)->mnt_id);
 
 	show_fd_locks(m, file, files);
-	ret = seq_has_overflowed(m);
-	if (ret)
+	if (seq_has_overflowed(m))
 		goto out;
 
 	if (file->f_op->show_fdinfo)
 		file->f_op->show_fdinfo(m, file);
-	ret = seq_has_overflowed(m);
 
 out:
 	fput(file);
-	return ret;
+	return 0;
 }
 
 static int seq_fdinfo_open(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from avagin@openvz.org are

proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

