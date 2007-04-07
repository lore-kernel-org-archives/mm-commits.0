From: akpm@linux-foundation.org
Subject: + locks-trivial-removal-of-unnecessary-parentheses.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:40:43 -0700
Message-ID: <200704070540.l375ehPH028383@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45294 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXDGFk7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, eshel@almaden.ibm.com, jack@ucw.cz, trond.myklebust@fys.uio.no


The patch titled
     locks: trivial removal of unnecessary parentheses
has been added to the -mm tree.  Its filename is
     locks-trivial-removal-of-unnecessary-parentheses.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
remove-nfs4_acl_add_ace.patch
locks-trivial-removal-of-unnecessary-parentheses.patch
locks-create-posix-to-flock-helper-functions.patch
locks-make-lock-release-private-data-before-returning-in-getlk-case.patch
locks-give-posix_test_lock-same-interface-as-lock.patch
locks-factor-out-generic-filesystem-switch-from-test_lock.patch
locks-factor-out-generic-filesystem-switch-from-setlock-code.patch
locks-allow-vfsposix_lock_file-to-return-conflicting-lock.patch
locks-add-fl_notify-arguments-for-asynchronous-lock-return.patch
locks-add-lock-cancel-command.patch
nfsd4-convert-nfsv4-to-new-lock-interface.patch
lockd-save-lock-state-on-deferral.patch
lockd-handle-fl_notify-callbacks.patch
lockd-pass-cookie-in-nlmsvc_testlock.patch
lockd-handle-test_lock-deferrals.patch
lockd-always-preallocate-block-in-nlmsvc_lock.patch
lockd-add-code-to-handle-deferred-lock-requests.patch
gfs2-nfs-lock-support-for-gfs2.patch
