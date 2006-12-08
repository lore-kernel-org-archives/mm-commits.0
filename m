From: akpm@osdl.org
Subject: - struct-path-convert-sunrpc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:12 -0800
Message-ID: <200612082005.kB8K5C0N002276@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57458 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426319AbWLHUFR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert sunrpc
has been removed from the -mm tree.  Its filename was
     struct-path-convert-sunrpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert sunrpc
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/sunrpc/auth_gss/auth_gss.c |    2 +-
 net/sunrpc/cache.c             |   10 +++++-----
 net/sunrpc/rpc_pipe.c          |    8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN net/sunrpc/auth_gss/auth_gss.c~struct-path-convert-sunrpc net/sunrpc/auth_gss/auth_gss.c
--- a/net/sunrpc/auth_gss/auth_gss.c~struct-path-convert-sunrpc
+++ a/net/sunrpc/auth_gss/auth_gss.c
@@ -501,7 +501,7 @@ gss_pipe_downcall(struct file *filp, con
 	if (!buf)
 		goto out;
 
-	clnt = RPC_I(filp->f_dentry->d_inode)->private;
+	clnt = RPC_I(filp->f_path.dentry->d_inode)->private;
 	err = -EFAULT;
 	if (copy_from_user(buf, src, mlen))
 		goto err;
diff -puN net/sunrpc/cache.c~struct-path-convert-sunrpc net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~struct-path-convert-sunrpc
+++ a/net/sunrpc/cache.c
@@ -670,7 +670,7 @@ cache_read(struct file *filp, char __use
 {
 	struct cache_reader *rp = filp->private_data;
 	struct cache_request *rq;
-	struct cache_detail *cd = PDE(filp->f_dentry->d_inode)->data;
+	struct cache_detail *cd = PDE(filp->f_path.dentry->d_inode)->data;
 	int err;
 
 	if (count == 0)
@@ -747,7 +747,7 @@ cache_write(struct file *filp, const cha
 	    loff_t *ppos)
 {
 	int err;
-	struct cache_detail *cd = PDE(filp->f_dentry->d_inode)->data;
+	struct cache_detail *cd = PDE(filp->f_path.dentry->d_inode)->data;
 
 	if (count == 0)
 		return 0;
@@ -778,7 +778,7 @@ cache_poll(struct file *filp, poll_table
 	unsigned int mask;
 	struct cache_reader *rp = filp->private_data;
 	struct cache_queue *cq;
-	struct cache_detail *cd = PDE(filp->f_dentry->d_inode)->data;
+	struct cache_detail *cd = PDE(filp->f_path.dentry->d_inode)->data;
 
 	poll_wait(filp, &queue_wait, wait);
 
@@ -1254,7 +1254,7 @@ static struct file_operations content_fi
 static ssize_t read_flush(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	struct cache_detail *cd = PDE(file->f_dentry->d_inode)->data;
+	struct cache_detail *cd = PDE(file->f_path.dentry->d_inode)->data;
 	char tbuf[20];
 	unsigned long p = *ppos;
 	int len;
@@ -1275,7 +1275,7 @@ static ssize_t read_flush(struct file *f
 static ssize_t write_flush(struct file * file, const char __user * buf,
 			     size_t count, loff_t *ppos)
 {
-	struct cache_detail *cd = PDE(file->f_dentry->d_inode)->data;
+	struct cache_detail *cd = PDE(file->f_path.dentry->d_inode)->data;
 	char tbuf[20];
 	char *ep;
 	long flushtime;
diff -puN net/sunrpc/rpc_pipe.c~struct-path-convert-sunrpc net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~struct-path-convert-sunrpc
+++ a/net/sunrpc/rpc_pipe.c
@@ -214,7 +214,7 @@ out:
 static ssize_t
 rpc_pipe_read(struct file *filp, char __user *buf, size_t len, loff_t *offset)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct rpc_inode *rpci = RPC_I(inode);
 	struct rpc_pipe_msg *msg;
 	int res = 0;
@@ -257,7 +257,7 @@ out_unlock:
 static ssize_t
 rpc_pipe_write(struct file *filp, const char __user *buf, size_t len, loff_t *offset)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct rpc_inode *rpci = RPC_I(inode);
 	int res;
 
@@ -275,7 +275,7 @@ rpc_pipe_poll(struct file *filp, struct 
 	struct rpc_inode *rpci;
 	unsigned int mask = 0;
 
-	rpci = RPC_I(filp->f_dentry->d_inode);
+	rpci = RPC_I(filp->f_path.dentry->d_inode);
 	poll_wait(filp, &rpci->waitq, wait);
 
 	mask = POLLOUT | POLLWRNORM;
@@ -290,7 +290,7 @@ static int
 rpc_pipe_ioctl(struct inode *ino, struct file *filp,
 		unsigned int cmd, unsigned long arg)
 {
-	struct rpc_inode *rpci = RPC_I(filp->f_dentry->d_inode);
+	struct rpc_inode *rpci = RPC_I(filp->f_path.dentry->d_inode);
 	int len;
 
 	switch (cmd) {
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

