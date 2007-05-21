From: akpm@linux-foundation.org
Subject: + nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing.patch added to -mm tree
Date: Mon, 21 May 2007 14:41:20 -0700
Message-ID: <200705212141.l4LLfKxZ020704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757010AbXEUVoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     NFS: new infrastructure for NFS client in-kernel mount option parsing
has been added to the -mm tree.  Its filename is
     nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: new infrastructure for NFS client in-kernel mount option parsing
From: Chuck Lever <chuck.lever@oracle.com>

Add some data structures and definitions to support parsing NFS mount
options in the kernel NFS client.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 79 insertions(+)

diff -puN fs/nfs/super.c~nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing
+++ a/fs/nfs/super.c
@@ -45,6 +45,7 @@
 #include <linux/inet.h>
 #include <linux/nfs_xdr.h>
 #include <linux/magic.h>
+#include <linux/parser.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -57,6 +58,84 @@
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
 
+
+struct nfs_mount_args {
+	struct nfs_mount_data nmd;
+	unsigned int nfsprog;
+	unsigned use_mnthost;
+	struct sockaddr_in mnthost;
+	unsigned int mntprog;
+	unsigned int mntvers;
+	unsigned short mntport;
+};
+
+struct nfs4_mount_args {
+	struct nfs4_mount_data nmd;
+	struct sockaddr_in addr;
+	char clientaddr[16];
+	int authflavor;
+};
+
+enum {
+	/* Mount options that take no arguments */
+	Opt_soft, Opt_hard,
+	Opt_intr, Opt_nointr,
+	Opt_posix, Opt_noposix,
+	Opt_cto, Opt_nocto,
+	Opt_ac, Opt_noac,
+	Opt_lock, Opt_nolock,
+	Opt_v2, Opt_v3,
+	Opt_udp, Opt_tcp,
+	Opt_acl, Opt_noacl,
+
+	/* Mount options that take integer arguments */
+	Opt_port,
+	Opt_rsize, Opt_wsize,
+	Opt_timeo, Opt_retrans,
+	Opt_acregmin, Opt_acregmax,
+	Opt_acdirmin, Opt_acdirmax,
+	Opt_actimeo,
+	Opt_namelen,
+	Opt_mountport,
+	Opt_mountprog, Opt_mountvers,
+	Opt_nfsprog, Opt_nfsvers,
+
+	/* Mount options that take string arguments */
+	Opt_sec, Opt_proto, Opt_addr,
+	Opt_mounthost, Opt_clientaddr, Opt_context,
+
+	/* Mount options that are ignored */
+	Opt_userspace, Opt_deprecated,
+
+	Opt_err,
+};
+
+enum {
+	Opt_sec_none, Opt_sec_sys,
+	Opt_sec_krb5, Opt_sec_krb5i, Opt_sec_krb5p,
+	Opt_sec_lkey, Opt_sec_lkeyi, Opt_sec_lkeyp,
+	Opt_sec_spkm, Opt_sec_spkmi, Opt_sec_spkmp,
+
+	Opt_sec_err,
+};
+
+static match_table_t nfs_sec_tokens = {
+	{Opt_sec_none, "none"},
+	{Opt_sec_none, "null"},
+	{Opt_sec_sys, "sys"},
+
+	{Opt_sec_krb5, "krb5"},
+	{Opt_sec_krb5i, "krb5i"},
+	{Opt_sec_krb5p, "krb5p"},
+
+	{Opt_sec_lkey, "lkey"},
+	{Opt_sec_lkeyi, "lkeyi"},
+	{Opt_sec_lkeyp, "lkeyp"},
+
+	{Opt_sec_err, NULL},
+};
+
+
 static void nfs_umount_begin(struct vfsmount *, int);
 static int  nfs_statfs(struct dentry *, struct kstatfs *);
 static int  nfs_show_options(struct seq_file *, struct vfsmount *);
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

git-nfs.patch
nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
sunrpc-rename-rpcb_getport_external-routine.patch
sunrpc-rename-rpcb_getport-to-be-consistent-with-new-rpcb_getport_sync-name.patch
nfs-remake-nfsroot_mount-as-a-permanent-part-of-nfs-client.patch
nfs-clean-up-in-kernel-nfs-mount.patch
nfs-improve-debugging-output-in-nfs-in-kernel-mount-client.patch
nfs-new-infrastructure-for-nfs-client-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch
nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch
nfs-move-nfs_copy_user_string.patch
nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch
