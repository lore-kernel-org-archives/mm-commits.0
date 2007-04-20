From: akpm@linux-foundation.org
Subject: - locks-trivial-removal-of-unnecessary-parentheses.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:13 -0700
Message-ID: <200704200638.l3K6cDbJ008738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422973AbXDTGif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, eshel@almaden.ibm.com, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: trivial removal of unnecessary parentheses
has been removed from the -mm tree.  Its filename was
     locks-trivial-removal-of-unnecessary-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: locks: trivial removal of unnecessary parentheses
From: J. Bruce Fields <bfields@citi.umich.edu> - unquoted

If a filesystem defines a ->lock() method, that method is called when an
application uses fcntl(), but it isn't called from the code path used by the
lock managers (lockd (for nfsv2/v3) and nfsd itself (for v4)).  The following
patches remedy that.  (This hasn't been a problem until recently because the
filesystems that define ->lock (nfs, cifs, etc.) aren't filesystems that nfsd
exports.  The arrival of cluster filesystems changes that.)


This patch:

Remove some unnecessary parentheses.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/locks.c~locks-trivial-removal-of-unnecessary-parentheses fs/locks.c
--- a/fs/locks.c~locks-trivial-removal-of-unnecessary-parentheses
+++ a/fs/locks.c
@@ -1738,7 +1738,7 @@ again:
 	else {
 		for (;;) {
 			error = posix_lock_file(filp, file_lock);
-			if ((error != -EAGAIN) || (cmd == F_SETLK))
+			if (error != -EAGAIN || cmd == F_SETLK)
 				break;
 			error = wait_event_interruptible(file_lock->fl_wait,
 					!file_lock->fl_next);
@@ -1881,7 +1881,7 @@ again:
 	else {
 		for (;;) {
 			error = posix_lock_file(filp, file_lock);
-			if ((error != -EAGAIN) || (cmd == F_SETLK64))
+			if (error != -EAGAIN || cmd == F_SETLK64)
 				break;
 			error = wait_event_interruptible(file_lock->fl_wait,
 					!file_lock->fl_next);
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

auth_gss-unregister-gss_domain-when-unloading-module.patch
git-nfs-server-cluster-locking-api.patch
remove-nfs4_acl_add_ace.patch
