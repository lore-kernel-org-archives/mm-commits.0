From: akpm@linux-foundation.org
Subject: + nlm-initialize-completion-variable-in-lockd_up.patch added to -mm tree
Date: Tue, 08 Jan 2008 15:58:37 -0800
Message-ID: <200801082358.m08NwbDE006518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbYAIAAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 19:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@fieldses.org, cel@citi.umich.edu, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     NLM: Initialize completion variable in lockd_up
has been added to the -mm tree.  Its filename is
     nlm-initialize-completion-variable-in-lockd_up.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NLM: Initialize completion variable in lockd_up
From: Jeff Layton <jlayton@redhat.com>

lockd_start_done is a global var that can be reused if lockd is restarted, but
it's never reinitialized.  On all but the first use, wait_for_completion isn't
actually waiting on it since it has already completed once.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <cel@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/lockd/svc.c~nlm-initialize-completion-variable-in-lockd_up fs/lockd/svc.c
--- a/fs/lockd/svc.c~nlm-initialize-completion-variable-in-lockd_up
+++ a/fs/lockd/svc.c
@@ -287,6 +287,7 @@ lockd_up(int proto) /* Maybe add a 'fami
 	/*
 	 * Create the kernel thread and wait for it to start.
 	 */
+	init_completion(&lockd_start_done);
 	error = svc_create_thread(lockd, serv);
 	if (error) {
 		printk(KERN_WARNING
_

Patches currently in -mm which might be from jlayton@redhat.com are

git-cifs.patch
sunrpc-spin-svc_rqst-initialization-to-its-own-function.patch
sunrpc-export-svc_sock_update_bufs.patch
nlm-initialize-completion-variable-in-lockd_up.patch
nlm-have-lockd-call-try_to_freeze.patch
nlm-convert-lockd-to-use-kthreads.patch
nlm-add-reference-counting-to-lockd.patch
git-unionfs.patch
smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
deprecate-smbfs-in-favour-of-cifs.patch
