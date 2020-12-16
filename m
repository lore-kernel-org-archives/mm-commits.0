Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC2DC0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB1AB2313C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgLPEnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgLPEnt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:49 -0500
Date:   Tue, 15 Dec 2020 20:42:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093760;
        bh=GliZrUnRAR2gUEZFRFyzoS0DqL6+hjku8wTsf1HyQbw=;
        h=From:To:Subject:In-Reply-To:From;
        b=yNs3ZEagWU3qDkPZufWuD+J7PcxfiNgsf8lGHqh+Itfv57o7QDaTxPu/3t8f/2yak
         +KuJHI3AsNxoC0iTh8T0PftKvAVZ1YtfA1cs8+ivPUE9JG9B+OxA5djZFhahNAdqnE
         DsaTFb5dxSbwBmqX+Y4GOHpjK5FyV2DwzOU2wXXs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tommi.t.rantala@nokia.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 06/95] proc: fix lookup in /proc/net
 subdirectories after setns(2)
Message-ID: <20201216044239.UYlipLK-P%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix lookup in /proc/net subdirectories after setns(2)

	commit 1fde6f21d90f8ba5da3cb9c54ca991ed72696c43
	proc: fix /proc/net/* after setns(2)

only forced revalidation of regular files under /proc/net/

However, /proc/net/ is unusual in the sense of /proc/net/foo handlers
take netns pointer from parent directory which is old netns.

Steps to reproduce:

	(void)open("/proc/net/sctp/snmp", O_RDONLY);
	unshare(CLONE_NEWNET);

	int fd = open("/proc/net/sctp/snmp", O_RDONLY);
	read(fd, &c, 1);

Read will read wrong data from original netns.

Patch forces lookup on every directory under /proc/net .

Link: https://lkml.kernel.org/r/20201205160916.GA109739@localhost.localdomain
Fixes: 1da4d377f943 ("proc: revalidate misc dentries")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |   24 ++++++++++++++++++++++--
 fs/proc/internal.h      |    7 +++++++
 fs/proc/proc_net.c      |   16 ----------------
 include/linux/proc_fs.h |    8 +++++++-
 4 files changed, 36 insertions(+), 19 deletions(-)

--- a/fs/proc/generic.c~proc-fix-lookup-in-proc-net-subdirectories-after-setns2
+++ a/fs/proc/generic.c
@@ -349,6 +349,16 @@ static const struct file_operations proc
 	.iterate_shared		= proc_readdir,
 };
 
+static int proc_net_d_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	return 0;
+}
+
+const struct dentry_operations proc_net_dentry_ops = {
+	.d_revalidate	= proc_net_d_revalidate,
+	.d_delete	= always_delete_dentry,
+};
+
 /*
  * proc directories can do almost nothing..
  */
@@ -471,8 +481,8 @@ struct proc_dir_entry *proc_symlink(cons
 }
 EXPORT_SYMBOL(proc_symlink);
 
-struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
-		struct proc_dir_entry *parent, void *data)
+struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, void *data, bool force_lookup)
 {
 	struct proc_dir_entry *ent;
 
@@ -484,10 +494,20 @@ struct proc_dir_entry *proc_mkdir_data(c
 		ent->data = data;
 		ent->proc_dir_ops = &proc_dir_operations;
 		ent->proc_iops = &proc_dir_inode_operations;
+		if (force_lookup) {
+			pde_force_lookup(ent);
+		}
 		ent = proc_register(parent, ent);
 	}
 	return ent;
 }
+EXPORT_SYMBOL_GPL(_proc_mkdir);
+
+struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, void *data)
+{
+	return _proc_mkdir(name, mode, parent, data, false);
+}
 EXPORT_SYMBOL_GPL(proc_mkdir_data);
 
 struct proc_dir_entry *proc_mkdir_mode(const char *name, umode_t mode,
--- a/fs/proc/internal.h~proc-fix-lookup-in-proc-net-subdirectories-after-setns2
+++ a/fs/proc/internal.h
@@ -310,3 +310,10 @@ extern unsigned long task_statm(struct m
 				unsigned long *, unsigned long *,
 				unsigned long *, unsigned long *);
 extern void task_mem(struct seq_file *, struct mm_struct *);
+
+extern const struct dentry_operations proc_net_dentry_ops;
+static inline void pde_force_lookup(struct proc_dir_entry *pde)
+{
+	/* /proc/net/ entries can be changed under us by setns(CLONE_NEWNET) */
+	pde->proc_dops = &proc_net_dentry_ops;
+}
--- a/fs/proc/proc_net.c~proc-fix-lookup-in-proc-net-subdirectories-after-setns2
+++ a/fs/proc/proc_net.c
@@ -39,22 +39,6 @@ static struct net *get_proc_net(const st
 	return maybe_get_net(PDE_NET(PDE(inode)));
 }
 
-static int proc_net_d_revalidate(struct dentry *dentry, unsigned int flags)
-{
-	return 0;
-}
-
-static const struct dentry_operations proc_net_dentry_ops = {
-	.d_revalidate	= proc_net_d_revalidate,
-	.d_delete	= always_delete_dentry,
-};
-
-static void pde_force_lookup(struct proc_dir_entry *pde)
-{
-	/* /proc/net/ entries can be changed under us by setns(CLONE_NEWNET) */
-	pde->proc_dops = &proc_net_dentry_ops;
-}
-
 static int seq_open_net(struct inode *inode, struct file *file)
 {
 	unsigned int state_size = PDE(inode)->state_size;
--- a/include/linux/proc_fs.h~proc-fix-lookup-in-proc-net-subdirectories-after-setns2
+++ a/include/linux/proc_fs.h
@@ -80,6 +80,7 @@ extern void proc_flush_pid(struct pid *)
 
 extern struct proc_dir_entry *proc_symlink(const char *,
 		struct proc_dir_entry *, const char *);
+struct proc_dir_entry *_proc_mkdir(const char *, umode_t, struct proc_dir_entry *, void *, bool);
 extern struct proc_dir_entry *proc_mkdir(const char *, struct proc_dir_entry *);
 extern struct proc_dir_entry *proc_mkdir_data(const char *, umode_t,
 					      struct proc_dir_entry *, void *);
@@ -162,6 +163,11 @@ static inline struct proc_dir_entry *pro
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
 	struct proc_dir_entry *parent) {return NULL;}
 static inline struct proc_dir_entry *proc_create_mount_point(const char *name) { return NULL; }
+static inline struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
+		struct proc_dir_entry *parent, void *data, bool force_lookup)
+{
+	return NULL;
+}
 static inline struct proc_dir_entry *proc_mkdir_data(const char *name,
 	umode_t mode, struct proc_dir_entry *parent, void *data) { return NULL; }
 static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
@@ -199,7 +205,7 @@ struct net;
 static inline struct proc_dir_entry *proc_net_mkdir(
 	struct net *net, const char *name, struct proc_dir_entry *parent)
 {
-	return proc_mkdir_data(name, 0, parent, net);
+	return _proc_mkdir(name, 0, parent, net, true);
 }
 
 struct ns_common;
_
