From: akpm@linux-foundation.org
Subject: - lockd-dont-return-eagain-for-a-permanent-error.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:25 -0700
Message-ID: <200807252303.m6PN3PO0003953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbYGYXFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, matthew@wil.cx, teigland@redhat.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     lockd: dont return EAGAIN for a permanent error
has been removed from the -mm tree.  Its filename was
     lockd-dont-return-eagain-for-a-permanent-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockd: dont return EAGAIN for a permanent error
From: Miklos Szeredi <mszeredi@suse.cz>

Fix nlm_fopen() to return NLM_FAILED (or NLM_LCK_DENIED_NOLOCKS) instead
of NLM_LCK_DENIED.  The latter means the lock request failed because of a
conflicting lock (i.e.  a temporary error), which is wrong in this case.

Also fix the client to return ENOLCK instead of EAGAIN if a blocking lock
request returns with NLM_LOCK_DENIED.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: David Teigland <teigland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/clntproc.c |   10 +++++++++-
 fs/nfsd/lockd.c     |   13 +++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff -puN fs/lockd/clntproc.c~lockd-dont-return-eagain-for-a-permanent-error fs/lockd/clntproc.c
--- a/fs/lockd/clntproc.c~lockd-dont-return-eagain-for-a-permanent-error
+++ a/fs/lockd/clntproc.c
@@ -582,7 +582,15 @@ again:
 	}
 	if (status < 0)
 		goto out_unlock;
-	status = nlm_stat_to_errno(resp->status);
+	/*
+	 * EAGAIN doesn't make sense for sleeping locks, and in some
+	 * cases NLM_LCK_DENIED is returned for a permanent error.  So
+	 * turn it into an ENOLCK.
+	 */
+	if (resp->status == nlm_lck_denied && (fl_flags & FL_SLEEP))
+		status = -ENOLCK;
+	else
+		status = nlm_stat_to_errno(resp->status);
 out_unblock:
 	nlmclnt_finish_block(block);
 out:
diff -puN fs/nfsd/lockd.c~lockd-dont-return-eagain-for-a-permanent-error fs/nfsd/lockd.c
--- a/fs/nfsd/lockd.c~lockd-dont-return-eagain-for-a-permanent-error
+++ a/fs/nfsd/lockd.c
@@ -19,6 +19,13 @@
 
 #define NFSDDBG_FACILITY		NFSDDBG_LOCKD
 
+#ifdef CONFIG_LOCKD_V4
+#define nlm_stale_fh	nlm4_stale_fh
+#define nlm_failed	nlm4_failed
+#else
+#define nlm_stale_fh	nlm_lck_denied_nolocks
+#define nlm_failed	nlm_lck_denied_nolocks
+#endif
 /*
  * Note: we hold the dentry use count while the file is open.
  */
@@ -47,12 +54,10 @@ nlm_fopen(struct svc_rqst *rqstp, struct
 		return 0;
 	case nfserr_dropit:
 		return nlm_drop_reply;
-#ifdef CONFIG_LOCKD_V4
 	case nfserr_stale:
-		return nlm4_stale_fh;
-#endif
+		return nlm_stale_fh;
 	default:
-		return nlm_lck_denied;
+		return nlm_failed;
 	}
 }
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
git-unprivileged-mounts.patch

