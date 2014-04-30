From: akpm@linux-foundation.org
Subject: + fs-ceph-replace-pr_warning-by-pr_warn.patch added to -mm tree
Date: Wed, 30 Apr 2014 15:34:06 -0700
Message-ID: <53617a5e.EjujcG3kCIs5XJ8m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759653AbaD3WeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 18:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sage@inktank.com, fabf@skynet.be

Subject: + fs-ceph-replace-pr_warning-by-pr_warn.patch added to -mm tree
To: fabf@skynet.be,sage@inktank.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 15:34:06 -0700


The patch titled
     Subject: fs/ceph: replace pr_warning by pr_warn
has been added to the -mm tree.  Its filename is
     fs-ceph-replace-pr_warning-by-pr_warn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ceph-replace-pr_warning-by-pr_warn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ceph-replace-pr_warning-by-pr_warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -822,7 +822,7 @@ no_change:
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

ntfs-remove-null-value-assignments.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch

