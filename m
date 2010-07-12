From: akpm@linux-foundation.org
Subject: + 9p-strlen-doesnt-count-the-terminator.patch added to -mm tree
Date: Mon, 12 Jul 2010 13:05:10 -0700
Message-ID: <201007122005.o6CK5AY3026467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880Ab0GLUFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 16:05:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov


The patch titled
     9p: strlen() doesn't count the terminator
has been added to the -mm tree.  Its filename is
     9p-strlen-doesnt-count-the-terminator.patch

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
Subject: 9p: strlen() doesn't count the terminator
From: Dan Carpenter <error27@gmail.com>

This is an off by one bug because strlen() doesn't count the NULL
terminator.  We strcpy() addr into a fixed length array of size
UNIX_PATH_MAX later on.

The addr variable is the name of the device being mounted.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/trans_fd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/9p/trans_fd.c~9p-strlen-doesnt-count-the-terminator net/9p/trans_fd.c
--- a/net/9p/trans_fd.c~9p-strlen-doesnt-count-the-terminator
+++ a/net/9p/trans_fd.c
@@ -948,7 +948,7 @@ p9_fd_create_unix(struct p9_client *clie
 
 	csocket = NULL;
 
-	if (strlen(addr) > UNIX_PATH_MAX) {
+	if (strlen(addr) >= UNIX_PATH_MAX) {
 		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
 			addr);
 		return -ENAMETOOLONG;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
mtd-sst25l-check-for-null-consistently.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
9p-strlen-doesnt-count-the-terminator.patch
autofs4-remove-unneeded-null-check-in-try_to_fill_dentry.patch

