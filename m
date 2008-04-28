From: akpm@linux-foundation.org
Subject: + fuse-fix-max-i-o-size-calculation.patch added to -mm tree
Date: Sun, 27 Apr 2008 19:26:30 -0700
Message-ID: <200804280226.m3S2QU4G003422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763255AbYD1C1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 22:27:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix max i/o size calculation
has been added to the -mm tree.  Its filename is
     fuse-fix-max-i-o-size-calculation.patch

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
Subject: fuse: fix max i/o size calculation
From: Miklos Szeredi <mszeredi@suse.cz>

Fix a bug that Werner Baumann reported: fuse can send a bigger write request
than the maximum specified.  This only affected direct_io operation.

In addition set a sane minimum for the max_read and max_write tunables, so I/O
always makes some progress.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c  |    7 ++++---
 fs/fuse/inode.c |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/fuse/file.c~fuse-fix-max-i-o-size-calculation fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fix-max-i-o-size-calculation
+++ a/fs/fuse/file.c
@@ -966,14 +966,15 @@ static ssize_t fuse_direct_io(struct fil
 
 	while (count) {
 		size_t nres;
-		size_t nbytes = min(count, nmax);
-		int err = fuse_get_user_pages(req, buf, nbytes, !write);
+		size_t nbytes_limit = min(count, nmax);
+		size_t nbytes;
+		int err = fuse_get_user_pages(req, buf, nbytes_limit, !write);
 		if (err) {
 			res = err;
 			break;
 		}
 		nbytes = (req->num_pages << PAGE_SHIFT) - req->page_offset;
-		nbytes = min(count, nbytes);
+		nbytes = min(nbytes_limit, nbytes);
 		if (write)
 			nres = fuse_send_write(req, file, inode, pos, nbytes,
 					       current->files);
diff -puN fs/fuse/inode.c~fuse-fix-max-i-o-size-calculation fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-max-i-o-size-calculation
+++ a/fs/fuse/inode.c
@@ -584,6 +584,7 @@ static void process_init_reply(struct fu
 		fc->bdi.ra_pages = min(fc->bdi.ra_pages, ra_pages);
 		fc->minor = arg->minor;
 		fc->max_write = arg->minor < 5 ? 4096 : arg->max_write;
+		fc->max_write = min_t(unsigned, 4096, fc->max_write);
 		fc->conn_init = 1;
 	}
 	fuse_put_request(fc, req);
@@ -658,7 +659,7 @@ static int fuse_fill_super(struct super_
 	fc->flags = d.flags;
 	fc->user_id = d.user_id;
 	fc->group_id = d.group_id;
-	fc->max_read = d.max_read;
+	fc->max_read = min_t(unsigned, 4096, d.max_read);
 
 	/* Used by get_root_inode() */
 	sb->s_fs_info = fc;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-nfsd.patch
mm-rotate_reclaimable_page-cleanup.patch
vfs-remove-lives_below_in_same_fs.patch
ecryptfs-add-missing-lock-around-notify_change.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-add-nr_writeback_temp-counter-fix.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch
fuse-update-file-size-on-short-read-fix.patch
fuse-fix-max-i-o-size-calculation.patch
fuse-fix-node-id-type.patch
fuse-fix-race-in-llseek.patch
fuse-fix-race-in-llseek-fix.patch
fuse-fix-sparse-warnings.patch

