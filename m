From: akpm@linux-foundation.org
Subject: [merged] fs-ceph-replace-pr_warning-by-pr_warn.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:28:02 -0700
Message-ID: <53960ac2.SJywNnlFhN5EGQFn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaFIT2C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:28:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sage@inktank.com, fabf@skynet.be

Subject: [merged] fs-ceph-replace-pr_warning-by-pr_warn.patch removed from -mm tree
To: fabf@skynet.be,sage@inktank.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:28:02 -0700


The patch titled
     Subject: fs/ceph: replace pr_warning by pr_warn
has been removed from the -mm tree.  Its filename was
     fs-ceph-replace-pr_warning-by-pr_warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ceph: replace pr_warning by pr_warn

Update the last pr_warning callsites in fs branch

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Sage Weil <sage@inktank.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/addr.c       |    2 +-
 fs/ceph/inode.c      |    2 +-
 fs/ceph/mds_client.c |    6 +++---
 fs/ceph/mdsmap.c     |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ceph/addr.c~fs-ceph-replace-pr_warning-by-pr_warn fs/ceph/addr.c
--- a/fs/ceph/addr.c~fs-ceph-replace-pr_warning-by-pr_warn
+++ a/fs/ceph/addr.c
@@ -694,7 +694,7 @@ static int ceph_writepages_start(struct
 	     (wbc->sync_mode == WB_SYNC_ALL ? "ALL" : "HOLD"));
 
 	if (fsc->mount_state == CEPH_MOUNT_SHUTDOWN) {
-		pr_warning("writepage_start %p on forced umount\n", inode);
+		pr_warn("writepage_start %p on forced umount\n", inode);
 		return -EIO; /* we're in a forced umount, don't write! */
 	}
 	if (fsc->mount_options->wsize && fsc->mount_options->wsize < wsize)
diff -puN fs/ceph/inode.c~fs-ceph-replace-pr_warning-by-pr_warn fs/ceph/inode.c
--- a/fs/ceph/inode.c~fs-ceph-replace-pr_warning-by-pr_warn
+++ a/fs/ceph/inode.c
@@ -821,7 +821,7 @@ no_change:
 			spin_unlock(&ci->i_ceph_lock);
 		}
 	} else if (cap_fmode >= 0) {
-		pr_warning("mds issued no caps on %llx.%llx\n",
+		pr_warn("mds issued no caps on %llx.%llx\n",
 			   ceph_vinop(inode));
 		__ceph_get_fmode(ci, cap_fmode);
 	}
diff -puN fs/ceph/mds_client.c~fs-ceph-replace-pr_warning-by-pr_warn fs/ceph/mds_client.c
--- a/fs/ceph/mds_client.c~fs-ceph-replace-pr_warning-by-pr_warn
+++ a/fs/ceph/mds_client.c
@@ -2218,13 +2218,13 @@ static void handle_reply(struct ceph_mds
 	/* dup? */
 	if ((req->r_got_unsafe && !head->safe) ||
 	    (req->r_got_safe && head->safe)) {
-		pr_warning("got a dup %s reply on %llu from mds%d\n",
+		pr_warn("got a dup %s reply on %llu from mds%d\n",
 			   head->safe ? "safe" : "unsafe", tid, mds);
 		mutex_unlock(&mdsc->mutex);
 		goto out;
 	}
 	if (req->r_got_safe && !head->safe) {
-		pr_warning("got unsafe after safe on %llu from mds%d\n",
+		pr_warn("got unsafe after safe on %llu from mds%d\n",
 			   tid, mds);
 		mutex_unlock(&mdsc->mutex);
 		goto out;
@@ -3525,7 +3525,7 @@ static void peer_reset(struct ceph_conne
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 
-	pr_warning("mds%d closed our session\n", s->s_mds);
+	pr_warn("mds%d closed our session\n", s->s_mds);
 	send_mds_reconnect(mdsc, s);
 }
 
diff -puN fs/ceph/mdsmap.c~fs-ceph-replace-pr_warning-by-pr_warn fs/ceph/mdsmap.c
--- a/fs/ceph/mdsmap.c~fs-ceph-replace-pr_warning-by-pr_warn
+++ a/fs/ceph/mdsmap.c
@@ -62,7 +62,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(v
 
 	ceph_decode_16_safe(p, end, version, bad);
 	if (version > 3) {
-		pr_warning("got mdsmap version %d > 3, failing", version);
+		pr_warn("got mdsmap version %d > 3, failing", version);
 		goto bad;
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

