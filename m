From: akpm@linux-foundation.org
Subject: - nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch removed from -mm tree
Date: Tue, 29 May 2007 09:29:08 -0700
Message-ID: <200705291629.l4TGT7pb005481@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383AbXE2Q3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 12:29:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NFS: add functions to parse nfs mount options to fs/nfs/super.c
has been removed from the -mm tree.  Its filename was
     nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: NFS: add functions to parse nfs mount options to fs/nfs/super.c
From: Chuck Lever <chuck.lever@oracle.com>

For NFSv2 and NFSv3 mount options.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |  449 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 449 insertions(+)

diff -puN fs/nfs/super.c~nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc
+++ a/fs/nfs/super.c
@@ -513,6 +513,455 @@ static void nfs_umount_begin(struct vfsm
 	shrink_submounts(vfsmnt, &nfs_automount_list);
 }
 
+
+static match_table_t nfs_tokens = {
+	{Opt_userspace, "bg"},
+	{Opt_userspace, "fg"},
+	{Opt_soft, "soft"},
+	{Opt_hard, "hard"},
+	{Opt_intr, "intr"},
+	{Opt_nointr, "nointr"},
+	{Opt_posix, "posix"},
+	{Opt_noposix, "noposix"},
+	{Opt_cto, "cto"},
+	{Opt_nocto, "nocto"},
+	{Opt_ac, "ac"},
+	{Opt_noac, "noac"},
+	{Opt_lock, "lock"},
+	{Opt_nolock, "nolock"},
+	{Opt_v2, "v2"},
+	{Opt_v3, "v3"},
+	{Opt_udp, "udp"},
+	{Opt_tcp, "tcp"},
+	{Opt_acl, "acl"},
+	{Opt_noacl, "noacl"},
+
+	{Opt_port, "port=%u"},
+	{Opt_rsize, "rsize=%u"},
+	{Opt_wsize, "wsize=%u"},
+	{Opt_timeo, "timeo=%u"},
+	{Opt_retrans, "retrans=%u"},
+	{Opt_acregmin, "acregmin=%u"},
+	{Opt_acregmax, "acregmax=%u"},
+	{Opt_acdirmin, "acdirmin=%u"},
+	{Opt_acdirmax, "acdirmax=%u"},
+	{Opt_actimeo, "actimeo=%u"},
+	{Opt_userspace, "retry=%u"},
+	{Opt_namelen, "namlen=%u"},
+	{Opt_mountport, "mountport=%u"},
+	{Opt_mountprog, "mountprog=%u"},
+	{Opt_mountvers, "mountvers=%u"},
+	{Opt_nfsprog, "nfsprog=%u"},
+	{Opt_nfsvers, "nfsvers=%u"},
+	{Opt_nfsvers, "vers=%u"},
+
+	{Opt_sec, "sec=%s"},
+	{Opt_proto, "proto=%s"},
+	{Opt_addr, "addr=%s"},
+	{Opt_mounthost, "mounthost=%s"},
+	{Opt_context, "context=%s"},
+
+	{Opt_err, NULL},
+};
+
+static int nfs_parse_options(char *raw, struct nfs_mount_args *mnt)
+{
+	char *p, *string;
+
+	if (!raw) {
+		dprintk("NFS: mount options string was NULL.\n");
+		return 1;
+	}
+
+	while ((p = strsep (&raw, ",")) != NULL) {
+		substring_t args[MAX_OPT_ARGS];
+		int option, token;
+
+		if (!*p)
+			continue;
+		token = match_token(p, nfs_tokens, args);
+
+		dprintk("NFS:   nfs mount option '%s': parsing token %d\n",
+			p, token);
+
+		switch (token) {
+		case Opt_soft:
+			mnt->nmd.flags |= NFS_MOUNT_SOFT;
+			break;
+		case Opt_hard:
+			mnt->nmd.flags &= ~NFS_MOUNT_SOFT;
+			break;
+		case Opt_intr:
+			mnt->nmd.flags |= NFS_MOUNT_INTR;
+			break;
+		case Opt_nointr:
+			mnt->nmd.flags &= ~NFS_MOUNT_INTR;
+			break;
+		case Opt_posix:
+			mnt->nmd.flags |= NFS_MOUNT_POSIX;
+			break;
+		case Opt_noposix:
+			mnt->nmd.flags &= ~NFS_MOUNT_POSIX;
+			break;
+		case Opt_cto:
+			mnt->nmd.flags &= ~NFS_MOUNT_NOCTO;
+			break;
+		case Opt_nocto:
+			mnt->nmd.flags |= NFS_MOUNT_NOCTO;
+			break;
+		case Opt_ac:
+			mnt->nmd.flags &= ~NFS_MOUNT_NOAC;
+			break;
+		case Opt_noac:
+			mnt->nmd.flags |= NFS_MOUNT_NOAC;
+			break;
+		case Opt_lock:
+			mnt->nmd.flags &= ~NFS_MOUNT_NONLM;
+			break;
+		case Opt_nolock:
+			mnt->nmd.flags |= NFS_MOUNT_NONLM;
+			break;
+		case Opt_v2:
+			mnt->nmd.flags &= ~NFS_MOUNT_VER3;
+			break;
+		case Opt_v3:
+			mnt->nmd.flags |= NFS_MOUNT_VER3;
+			break;
+		case Opt_udp:
+			mnt->nmd.flags &= ~NFS_MOUNT_TCP;
+			break;
+		case Opt_tcp:
+			mnt->nmd.flags |= NFS_MOUNT_TCP;
+			break;
+		case Opt_acl:
+			mnt->nmd.flags &= ~NFS_MOUNT_NOACL;
+			break;
+		case Opt_noacl:
+			mnt->nmd.flags |= NFS_MOUNT_NOACL;
+			break;
+
+		case Opt_port:
+			if (match_int(args, &option))
+				return 0;
+			if (option < 0 || option > 65535)
+				return 0;
+			mnt->nmd.addr.sin_port = htonl(option);
+			break;
+		case Opt_rsize:
+			if (match_int(args, &mnt->nmd.rsize))
+				return 0;
+			break;
+		case Opt_wsize:
+			if (match_int(args, &mnt->nmd.wsize))
+				return 0;
+			break;
+		case Opt_timeo:
+			if (match_int(args, &mnt->nmd.timeo))
+				return 0;
+			break;
+		case Opt_retrans:
+			if (match_int(args, &mnt->nmd.retrans))
+				return 0;
+			break;
+		case Opt_acregmin:
+			if (match_int(args, &mnt->nmd.acregmin))
+				return 0;
+			break;
+		case Opt_acregmax:
+			if (match_int(args, &mnt->nmd.acregmax))
+				return 0;
+			break;
+		case Opt_acdirmin:
+			if (match_int(args, &mnt->nmd.acdirmin))
+				return 0;
+			break;
+		case Opt_acdirmax:
+			if (match_int(args, &mnt->nmd.acdirmax))
+				return 0;
+			break;
+		case Opt_actimeo:
+			if (match_int(args, &option))
+				return 0;
+			if (option < 0)
+				return 0;
+			mnt->nmd.acregmin =
+			mnt->nmd.acregmax =
+			mnt->nmd.acdirmin =
+			mnt->nmd.acdirmax = option;
+			break;
+		case Opt_namelen:
+			if (match_int(args, &mnt->nmd.namlen))
+				return 0;
+			break;
+		case Opt_mountport:
+			if (match_int(args, &option))
+				return 0;
+			if (option < 0 || option > 65535)
+				return 0;
+			mnt->mnthost.sin_port = htonl(option);
+			break;
+		case Opt_mountprog:
+			if (match_int(args, &option))
+				return 0;
+			if (option < 0)
+				return 0;
+			mnt->mntprog = option;
+			break;
+		case Opt_mountvers:
+			if (match_int(args, &option))
+				return 0;
+			if (option < 0)
+				return 0;
+			mnt->mntvers = option;
+			break;
+		case Opt_nfsprog:
+			if (match_int(args, &option))
+				return 0;
+			if (option < 0)
+				return 0;
+			mnt->nfsprog = option;
+			break;
+		case Opt_nfsvers:
+			if (match_int(args, &option))
+				return 0;
+			switch (option) {
+			case 2:
+				mnt->nmd.flags &= ~NFS_MOUNT_VER3;
+				break;
+			case 3:
+				mnt->nmd.flags |= NFS_MOUNT_VER3;
+				break;
+			default:
+				goto out_unrec_vers;
+			}
+			break;
+
+		case Opt_sec: {
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+			token = match_token(string, nfs_sec_tokens, args);
+			kfree(string);
+
+			mnt->nmd.flags |= NFS_MOUNT_SECFLAVOUR;
+
+			switch (token) {
+			case Opt_sec_none:
+				mnt->nmd.flags &= ~NFS_MOUNT_SECFLAVOUR;
+				mnt->nmd.pseudoflavor = RPC_AUTH_NULL;
+				break;
+			case Opt_sec_sys:
+				mnt->nmd.flags &= ~NFS_MOUNT_SECFLAVOUR;
+				mnt->nmd.pseudoflavor = RPC_AUTH_UNIX;
+				break;
+			case Opt_sec_krb5:
+				mnt->nmd.pseudoflavor = RPC_AUTH_GSS_KRB5;
+				break;
+			case Opt_sec_krb5i:
+				mnt->nmd.pseudoflavor = RPC_AUTH_GSS_KRB5I;
+				break;
+			case Opt_sec_krb5p:
+				mnt->nmd.pseudoflavor = RPC_AUTH_GSS_KRB5P;
+				break;
+			case Opt_sec_lkey:
+				mnt->nmd.pseudoflavor = RPC_AUTH_GSS_LKEY;
+				break;
+			case Opt_sec_lkeyi:
+				mnt->nmd.pseudoflavor = RPC_AUTH_GSS_LKEYI;
+				break;
+			case Opt_sec_lkeyp:
+				mnt->nmd.pseudoflavor = RPC_AUTH_GSS_LKEYP;
+				break;
+			case Opt_sec_spkm:
+				mnt->nmd.pseudoflavor = RPC_AUTH_GSS_SPKM;
+				break;
+			case Opt_sec_spkmi:
+				mnt->nmd.pseudoflavor = RPC_AUTH_GSS_SPKMI;
+				break;
+			case Opt_sec_spkmp:
+				mnt->nmd.pseudoflavor = RPC_AUTH_GSS_SPKMP;
+				break;
+			default:
+				goto out_unrec_sec;
+			}
+			break;
+			}
+		case Opt_proto:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+			if (strcmp(string, "udp") == 0) {
+				mnt->nmd.flags &= ~NFS_MOUNT_TCP;
+				kfree(string);
+				break;
+			}
+			if (strcmp(string, "tcp") == 0) {
+				mnt->nmd.flags |= NFS_MOUNT_TCP;
+				kfree(string);
+				break;
+			}
+			goto out_unrec_xprt;
+		case Opt_addr:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+			mnt->nmd.addr.sin_family = AF_INET;
+			mnt->nmd.addr.sin_addr.s_addr = in_aton(string);
+			kfree(string);
+			break;
+		case Opt_mounthost:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+			mnt->mnthost.sin_family = AF_INET;
+			mnt->mnthost.sin_addr.s_addr = in_aton(string);
+			kfree(string);
+			mnt->use_mnthost = 1;
+			break;
+		case Opt_context:
+			match_strcpy(mnt->nmd.context, args);
+			break;
+
+		case Opt_userspace:
+		case Opt_deprecated:
+			break;
+
+		default:
+			goto out_unknown;
+		}
+	}
+
+	return 1;
+
+out_nomem:
+	printk(KERN_INFO "NFS: not enough memory to parse option\n");
+	return 0;
+
+out_unrec_vers:
+	printk(KERN_INFO "NFS: unrecognized NFS version number\n");
+	return 0;
+
+out_unrec_xprt:
+	printk(KERN_INFO "NFS: unrecognized transport protocol\n");
+	return 0;
+
+out_unrec_sec:
+	printk(KERN_INFO "NFS: unrecognized security flavor\n");
+	return 0;
+
+out_unknown:
+	printk(KERN_INFO "NFS: unknown mount option: %s\n", p);
+	return 0;
+}
+
+/*
+ * Use the remote server's MOUNT service to request the NFS file handle
+ * corresponding to the provided path.
+ */
+static int nfs_try_mount(struct nfs_mount_data *nmd, char *path)
+{
+	struct nfs_mount_args *args;
+	int status, version, protocol;
+	struct sockaddr_in sin;
+	struct nfs_fh fh;
+
+	args = container_of(nmd, struct nfs_mount_args, nmd);
+	if (args->mntvers == 0) {
+		version = (args->nmd.flags & NFS_MOUNT_VER3) ?
+					NFS_MNT3_VERSION : NFS_MNT_VERSION;
+	} else
+		version = args->mntvers;
+	protocol = (args->nmd.flags & NFS_MOUNT_TCP) ?
+				IPPROTO_TCP : IPPROTO_UDP;
+
+	sin.sin_family = AF_INET;
+	if (args->use_mnthost == 0)
+		sin.sin_addr.s_addr = args->nmd.addr.sin_addr.s_addr;
+	else
+		sin.sin_addr.s_addr = args->mnthost.sin_addr.s_addr;
+	if (args->mntport == 0) {
+		status = rpcb_getport_sync(&sin, args->mntprog, version, protocol);
+		if (status < 0)
+			goto out_bind_err;
+		sin.sin_port = htons(status);
+	} else
+		sin.sin_port = htons(args->mntport);
+
+	sin.sin_addr.s_addr = args->nmd.addr.sin_addr.s_addr;
+	status = nfs_mount(&sin, path, &fh, version, protocol);
+	if (status < 0)
+		goto out_mnt_err;
+
+	args->nmd.root.size = fh.size;
+	memcpy(args->nmd.root.data, fh.data, fh.size);
+	return status;
+
+out_bind_err:
+	printk(KERN_INFO "NFS: unable to contact bind server on host %s\n",
+	       nmd->hostname);
+	return status;
+out_mnt_err:
+	printk(KERN_INFO "NFS: unable to contact NFS server on host %s\n",
+	       nmd->hostname);
+	return status;
+}
+
+/*
+ * Convert a string of nfs mount options into an nfs_mount_data struct.
+ *
+ * User space handles the following behaviors:
+ *
+ * + DNS: mapping server host name to IP address ("addr=" option)
+ *
+ * + failure mode: how to behave if a mount request can't be handled
+ *   immediately ("fg/bg" option)
+ *
+ * + retry: how often to retry a mount request ("retry=" option)
+ *
+ * + breaking back: trying UDP after TCP, and v2 after v3
+ *
+ * XXX: as far as I can tell, changing the NFS program is not really supported
+ *      in the NFS client.
+ *
+ */
+static struct nfs_mount_data *nfs_convert_mount_opts(const char *options)
+{
+	struct nfs_mount_args *args;
+
+	dprintk("NFS: nfs mount opts='%s'\n", options);
+
+	args = kzalloc(sizeof(*args), GFP_KERNEL);
+	if (args == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	args->nmd.version = 7;
+
+	args->nmd.flags = (NFS_MOUNT_VER3 | NFS_MOUNT_TCP);
+	args->nmd.rsize = NFS_MAX_FILE_IO_SIZE;
+	args->nmd.wsize = NFS_MAX_FILE_IO_SIZE;
+	args->nmd.timeo = 600;		/* in tenths of a second */
+	args->nmd.retrans = 2;
+	args->nmd.acregmin = 3;
+	args->nmd.acregmax = 60;
+	args->nmd.acdirmin = 30;
+	args->nmd.acdirmax = 60;
+
+	args->nfsprog = NFS_PROGRAM;
+	args->use_mnthost = 0;
+	args->mntprog = NFS_MNT_PROGRAM;
+	args->mntvers = 0;
+	args->mntport = 0;
+
+	if (nfs_parse_options((char *) options, args) == 0)
+		goto out_err;
+
+	return &args->nmd;
+
+out_err:
+	kfree(args);
+	return ERR_PTR(-EINVAL);
+}
+
 /*
  * Sanity-check a server address provided by the mount command
  */
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

git-nfs.patch
nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
nfs-add-functions-to-parse-nfs-mount-options-to-fs-nfs-superc.patch
nfs-implement-nfsv2-3-in-kernel-mount-option-parsing.patch
nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch
nfs-move-nfs_copy_user_string.patch
nfs-more-nfs4-in-kernel-mount-option-parsing-infrastructure.patch
nfs-integrate-support-for-processing-nfs4-mount-options-in-fs-nfs-superc.patch
