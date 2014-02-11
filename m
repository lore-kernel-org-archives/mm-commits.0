From: akpm@linux-foundation.org
Subject: + ncpfs-convert-pprintk-to-ncp_vdbg.patch added to -mm tree
Date: Mon, 10 Feb 2014 16:16:13 -0800
Message-ID: <52f96bcd.0URmW4ZTMw1+wF4k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaBKAQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 19:16:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com

Subject: + ncpfs-convert-pprintk-to-ncp_vdbg.patch added to -mm tree
To: joe@perches.com,petr@vandrovec.name
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 16:16:13 -0800


The patch titled
     Subject: ncpfs: convert PPRINTK to ncp_vdbg
has been added to the -mm tree.  Its filename is
     ncpfs-convert-pprintk-to-ncp_vdbg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-convert-pprintk-to-ncp_vdbg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-convert-pprintk-to-ncp_vdbg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ncpfs: convert PPRINTK to ncp_vdbg

Use a more current logging style.

Convert the paranoia debug statement to vdbg.
Remove the embedded function names as dynamic_debug can do that.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/dir.c           |   19 +++++++++----------
 fs/ncpfs/file.c          |    4 ++--
 fs/ncpfs/ncp_fs.h        |    9 +++++++--
 fs/ncpfs/ncplib_kernel.c |    6 +++---
 fs/ncpfs/sock.c          |    2 +-
 5 files changed, 22 insertions(+), 18 deletions(-)

diff -puN fs/ncpfs/dir.c~ncpfs-convert-pprintk-to-ncp_vdbg fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~ncpfs-convert-pprintk-to-ncp_vdbg
+++ a/fs/ncpfs/dir.c
@@ -736,8 +736,8 @@ ncp_do_readdir(struct file *file, struct
 	size_t bufsize;
 
 	ncp_dbg(1, "%pD2, fpos=%ld\n", file, (unsigned long)ctx->pos);
-	PPRINTK("ncp_do_readdir: init %pD, volnum=%d, dirent=%u\n",
-		file, NCP_FINFO(dir)->volNumber, NCP_FINFO(dir)->dirEntNum);
+	ncp_vdbg("init %pD, volnum=%d, dirent=%u\n",
+		 file, NCP_FINFO(dir)->volNumber, NCP_FINFO(dir)->dirEntNum);
 
 	err = ncp_initialize_search(server, dir, &seq);
 	if (err) {
@@ -804,8 +804,7 @@ int ncp_conn_logged_in(struct super_bloc
 			goto out;
 		result = -ENOENT;
 		if (ncp_get_volume_root(server, __name, &volNumber, &dirEntNum, &DosDirNum)) {
-			PPRINTK("ncp_conn_logged_in: %s not found\n",
-				server->m.mounted_vol);
+			ncp_vdbg("%s not found\n", server->m.mounted_vol);
 			goto out;
 		}
 		dent = sb->s_root;
@@ -842,7 +841,7 @@ static struct dentry *ncp_lookup(struct
 	if (!ncp_conn_valid(server))
 		goto finished;
 
-	PPRINTK("ncp_lookup: server lookup for %pd2\n", dentry);
+	ncp_vdbg("server lookup for %pd2\n", dentry);
 
 	len = sizeof(__name);
 	if (ncp_is_server_root(dir)) {
@@ -858,7 +857,7 @@ static struct dentry *ncp_lookup(struct
 		if (!res)
 			res = ncp_obtain_info(server, dir, __name, &(finfo.i));
 	}
-	PPRINTK("ncp_lookup: looked for %pd2, res=%d\n", dentry, res);
+	ncp_vdbg("looked for %pd2, res=%d\n", dentry, res);
 	/*
 	 * If we didn't find an entry, make a negative dentry.
 	 */
@@ -882,7 +881,7 @@ add_entry:
 	}
 
 finished:
-	PPRINTK("ncp_lookup: result=%d\n", error);
+	ncp_vdbg("result=%d\n", error);
 	return ERR_PTR(error);
 }
 
@@ -905,7 +904,7 @@ out:
 	return error;
 
 out_close:
-	PPRINTK("ncp_instantiate: %pd2 failed, closing file\n", dentry);
+	ncp_vdbg("%pd2 failed, closing file\n", dentry);
 	ncp_close_file(NCP_SERVER(dir), finfo->file_handle);
 	goto out;
 }
@@ -919,7 +918,7 @@ int ncp_create_new(struct inode *dir, st
 	int opmode;
 	__u8 __name[NCP_MAXPATHLEN + 1];
 	
-	PPRINTK("ncp_create_new: creating %pd2, mode=%hx\n", dentry, mode);
+	ncp_vdbg("creating %pd2, mode=%hx\n", dentry, mode);
 
 	ncp_age_dentry(server, dentry);
 	len = sizeof(__name);
@@ -1069,7 +1068,7 @@ static int ncp_unlink(struct inode *dir,
 	 * Check whether to close the file ...
 	 */
 	if (inode) {
-		PPRINTK("ncp_unlink: closing file\n");
+		ncp_vdbg("closing file\n");
 		ncp_make_closed(inode);
 	}
 
diff -puN fs/ncpfs/file.c~ncpfs-convert-pprintk-to-ncp_vdbg fs/ncpfs/file.c
--- a/fs/ncpfs/file.c~ncpfs-convert-pprintk-to-ncp_vdbg
+++ a/fs/ncpfs/file.c
@@ -73,7 +73,7 @@ int ncp_make_open(struct inode *inode, i
 				break;
 		}
 		if (result) {
-			PPRINTK("ncp_make_open: failed, result=%d\n", result);
+			ncp_vdbg("failed, result=%d\n", result);
 			goto out_unlock;
 		}
 		/*
@@ -85,7 +85,7 @@ int ncp_make_open(struct inode *inode, i
 	}
 
 	access = NCP_FINFO(inode)->access;
-	PPRINTK("ncp_make_open: file open, access=%x\n", access);
+	ncp_vdbg("file open, access=%x\n", access);
 	if (access == right || access == O_RDWR) {
 		atomic_inc(&NCP_FINFO(inode)->opened);
 		error = 0;
diff -puN fs/ncpfs/ncp_fs.h~ncpfs-convert-pprintk-to-ncp_vdbg fs/ncpfs/ncp_fs.h
--- a/fs/ncpfs/ncp_fs.h~ncpfs-convert-pprintk-to-ncp_vdbg
+++ a/fs/ncpfs/ncp_fs.h
@@ -7,9 +7,14 @@
 
 #undef NCPFS_PARANOIA
 #ifdef NCPFS_PARANOIA
-#define PPRINTK(format, args...) PRINTK(format , ## args)
+#define ncp_vdbg(fmt, ...)					\
+	pr_debug(fmt, ##__VA_ARGS__)
 #else
-#define PPRINTK(format, args...)
+#define ncp_vdbg(fmt, ...)					\
+do {								\
+	if (0)							\
+		pr_debug(fmt, ##__VA_ARGS__);			\
+} while (0)
 #endif
 
 #ifndef DEBUG_NCP
diff -puN fs/ncpfs/ncplib_kernel.c~ncpfs-convert-pprintk-to-ncp_vdbg fs/ncpfs/ncplib_kernel.c
--- a/fs/ncpfs/ncplib_kernel.c~ncpfs-convert-pprintk-to-ncp_vdbg
+++ a/fs/ncpfs/ncplib_kernel.c
@@ -295,9 +295,9 @@ ncp_make_closed(struct inode *inode)
 		err = ncp_close_file(NCP_SERVER(inode), NCP_FINFO(inode)->file_handle);
 
 		if (!err)
-			PPRINTK("ncp_make_closed: volnum=%d, dirent=%u, error=%d\n",
-				NCP_FINFO(inode)->volNumber,
-				NCP_FINFO(inode)->dirEntNum, err);
+			ncp_vdbg("volnum=%d, dirent=%u, error=%d\n",
+				 NCP_FINFO(inode)->volNumber,
+				 NCP_FINFO(inode)->dirEntNum, err);
 	}
 	mutex_unlock(&NCP_FINFO(inode)->open_mutex);
 	return err;
diff -puN fs/ncpfs/sock.c~ncpfs-convert-pprintk-to-ncp_vdbg fs/ncpfs/sock.c
--- a/fs/ncpfs/sock.c~ncpfs-convert-pprintk-to-ncp_vdbg
+++ a/fs/ncpfs/sock.c
@@ -823,7 +823,7 @@ int ncp_request2(struct ncp_server *serv
 	result = reply->completion_code;
 
 	if (result != 0)
-		PPRINTK("ncp_request: completion code=%x\n", result);
+		ncp_vdbg("completion code=%x\n", result);
 out:
 	return result;
 }
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-fix-detection-of-git-repository.patch
checkpatch-fix-detection-of-git-repository.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

