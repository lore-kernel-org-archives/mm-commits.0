From: akpm@linux-foundation.org
Subject: + nfs-infinite-loop-in-fcntlf_setlkw.patch added to -mm tree
Date: Thu, 10 Apr 2008 13:13:01 -0700
Message-ID: <200804102013.m3AKD2gd015435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759170AbYDJUNh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:13:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miklos@szeredi.hu, bfields@fieldses.org, cel@citi.umich.edu, mszeredi@suse.cz, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     nfs: infinite loop in fcntl(F_SETLKW)
has been added to the -mm tree.  Its filename is
     nfs-infinite-loop-in-fcntlf_setlkw.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: infinite loop in fcntl(F_SETLKW)
From: Miklos Szeredi <miklos@szeredi.hu>

Another infinite loop, this one involving both client and server.

Basically what happens is that on the server nlm_fopen() calls nfsd_open()
which returns -EACCES, to which nlm_fopen() returns NLM_LCK_DENIED.

On the client this will turn into a -EAGAIN (nlm_stat_to_errno()), which in
will cause fcntl_setlk() to retry forever.

I _think_ the solution is to turn NLM_LCK_DENIED into ENOLCK for blocking
locks, as NLM_LCK_BLOCKED is for the contended case.  For testing the lock
leave NLM_LCK_DENIED as EAGAIN.  That still could be misleading, but at least
there's no infinite loop in that case.

I've minimally tested this patch to verify that it cures the lockup,
and that simple blocking locks keep working.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: Chuck Lever <cel@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/clntproc.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/lockd/clntproc.c~nfs-infinite-loop-in-fcntlf_setlkw fs/lockd/clntproc.c
--- a/fs/lockd/clntproc.c~nfs-infinite-loop-in-fcntlf_setlkw
+++ a/fs/lockd/clntproc.c
@@ -536,6 +536,9 @@ again:
 		up_read(&host->h_rwsem);
 	}
 	status = nlm_stat_to_errno(resp->status);
+	/* Don't return EAGAIN, as that would make fcntl_setlk() loop */
+	if (status == -EAGAIN)
+		status = -ENOLCK;
 out_unblock:
 	nlmclnt_finish_block(block);
 	/* Cancel the blocked request if it is still pending */
_

Patches currently in -mm which might be from miklos@szeredi.hu are

generic_file_splice_read-fix-lockups.patch
git-nfsd.patch
nfs-infinite-loop-in-fcntlf_setlkw.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-bdi-move-statistics-to-debugfs.patch
add-macros-similar-to-min-max-min_t-max_t.patch
fuse-use-clamp-rather-than-nested-min-max.patch
notify_change-callers-must-hold-i_mutex.patch

