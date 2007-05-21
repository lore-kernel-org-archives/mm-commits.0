From: akpm@linux-foundation.org
Subject: + nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch added to -mm tree
Date: Mon, 21 May 2007 14:41:26 -0700
Message-ID: <200705212141.l4LLfQXl020713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308AbXEUVox (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:44:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     NFS: add functions to parse nfs4 mount options to fs/nfs/super.c
has been added to the -mm tree.  Its filename is
     nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: add functions to parse nfs4 mount options to fs/nfs/super.c
From: Chuck Lever <chuck.lever@oracle.com>

Add helpers required for parsing nfs4 mount options in the NFS
client.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |  290 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 290 insertions(+)

diff -puN fs/nfs/super.c~nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-add-functions-to-parse-nfs4-mount-options-to-fs-nfs-superc
+++ a/fs/nfs/super.c
@@ -1380,6 +1380,296 @@ error_splat_super:
 
 #ifdef CONFIG_NFS_V4
 
+static match_table_t nfs4_tokens = {
+	{Opt_userspace, "bg"},
+	{Opt_userspace, "fg"},
+	{Opt_soft, "soft"},
+	{Opt_hard, "hard"},
+	{Opt_intr, "intr"},
+	{Opt_nointr, "nointr"},
+	{Opt_cto, "cto"},
+	{Opt_nocto, "nocto"},
+	{Opt_ac, "ac"},
+	{Opt_noac, "noac"},
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
+
+	{Opt_sec, "sec=%s"},
+	{Opt_proto, "proto=%s"},
+	{Opt_addr, "addr=%s"},
+	{Opt_clientaddr, "clientaddr=%s"},
+
+	{Opt_err, NULL},
+};
+
+static int nfs4_parse_options(char *raw, struct nfs4_mount_args *mnt)
+{
+	char *p, *string;
+
+	if (!raw)
+		return 1;
+
+	while ((p = strsep (&raw, ",")) != NULL) {
+		substring_t args[MAX_OPT_ARGS];
+		int option, token;
+
+		if (!*p)
+			continue;
+		token = match_token(p, nfs4_tokens, args);
+
+		dprintk("NFS:   nfs4 mount option '%s': parsing token %d\n",
+			p, token);
+
+		switch (token) {
+		case Opt_soft:
+			mnt->nmd.flags |= NFS4_MOUNT_SOFT;
+			break;
+		case Opt_hard:
+			mnt->nmd.flags &= ~NFS4_MOUNT_SOFT;
+			break;
+		case Opt_intr:
+			mnt->nmd.flags |= NFS4_MOUNT_INTR;
+			break;
+		case Opt_nointr:
+			mnt->nmd.flags &= ~NFS4_MOUNT_INTR;
+			break;
+		case Opt_cto:
+			mnt->nmd.flags &= ~NFS4_MOUNT_NOCTO;
+			break;
+		case Opt_nocto:
+			mnt->nmd.flags |= NFS4_MOUNT_NOCTO;
+			break;
+		case Opt_ac:
+			mnt->nmd.flags &= ~NFS4_MOUNT_NOAC;
+			break;
+		case Opt_noac:
+			mnt->nmd.flags |= NFS4_MOUNT_NOAC;
+			break;
+
+		case Opt_port:
+			if (match_int(args, &option))
+				return 0;
+			if (option < 0 || option > 65535)
+				return 0;
+			mnt->addr.sin_port = htonl(option);
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
+
+		case Opt_proto: {
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+			if (strcmp(string, "udp") == 0) {
+				mnt->nmd.proto = IPPROTO_UDP;
+				kfree(string);
+				break;
+			}
+			if (strcmp(string, "tcp") == 0) {
+				mnt->nmd.proto = IPPROTO_TCP;
+				kfree(string);
+				break;
+			}
+			goto out_unrec_xprt;
+		}
+		case Opt_sec: {
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+			token = match_token(string, nfs_sec_tokens, args);
+			kfree(string);
+
+			mnt->nmd.auth_flavourlen = 1;
+
+			switch (token) {
+			case Opt_sec_sys:
+				mnt->nmd.auth_flavourlen = 0;
+				break;
+			case Opt_sec_krb5:
+				mnt->authflavor = RPC_AUTH_GSS_KRB5;
+				break;
+			case Opt_sec_krb5i:
+				mnt->authflavor = RPC_AUTH_GSS_KRB5I;
+				break;
+			case Opt_sec_krb5p:
+				mnt->authflavor = RPC_AUTH_GSS_KRB5P;
+				break;
+			case Opt_sec_lkey:
+				mnt->authflavor = RPC_AUTH_GSS_LKEY;
+				break;
+			case Opt_sec_lkeyi:
+				mnt->authflavor = RPC_AUTH_GSS_LKEYI;
+				break;
+			case Opt_sec_lkeyp:
+				mnt->authflavor = RPC_AUTH_GSS_LKEYP;
+				break;
+			case Opt_sec_spkm:
+				mnt->authflavor = RPC_AUTH_GSS_SPKM;
+				break;
+			case Opt_sec_spkmi:
+				mnt->authflavor = RPC_AUTH_GSS_SPKMI;
+				break;
+			case Opt_sec_spkmp:
+				mnt->authflavor = RPC_AUTH_GSS_SPKMP;
+				break;
+			default:
+				goto out_unrec_sec;
+			}
+			break;
+		}
+		case Opt_addr:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+			mnt->addr.sin_family = AF_INET;
+			mnt->addr.sin_addr.s_addr = in_aton(string);
+			kfree(string);
+			break;
+		case Opt_clientaddr: {
+			unsigned int len = args[0].to - args[0].from;
+			if (len > 80)
+				goto out_clntaddr_long;
+			match_strcpy(mnt->clientaddr, args);
+			mnt->nmd.client_addr.data = mnt->clientaddr;
+			mnt->nmd.client_addr.len = len;
+			break;
+		}
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
+out_unrec_xprt:
+	printk(KERN_INFO "NFS4: unrecognized transport protocol\n");
+	return 0;
+
+out_unrec_sec:
+	printk(KERN_INFO "NFS4: unrecognized security flavor\n");
+	return 0;
+
+out_nomem:
+	printk(KERN_INFO "NFS4: not enough memory to parse option\n");
+	return 0;
+
+out_clntaddr_long:
+	printk(KERN_INFO "NFS4: clientaddr too long\n");
+	return 0;
+
+out_unknown:
+	printk(KERN_INFO "NFS4: unrecognized mount option: %s\n", p);
+	return 0;
+}
+
+/*
+ * Convert a string of nfs4 mount options into an nfs4_mount_data struct.
+ *
+ * User space handles the following behaviors:
+ *
+ * + DNS: mapping server host name to IP address ("addr=" option)
+ *
+ * + DNS: providing IP address of callback interface ("clientaddr=" option)
+ *
+ * + failure mode: how to behave if a mount request can't be handled
+ *   immediately ("fg/bg" option)
+ *
+ * + retry: how often to retry a mount request ("retry=" option)
+ *
+ */
+static struct nfs4_mount_data *nfs4_convert_mount_opts(const char *options)
+{
+	struct nfs4_mount_args *args;
+
+	dprintk("NFS: nfs4 mount opts='%s'\n", options);
+
+	args = kzalloc(sizeof(*args), GFP_KERNEL);
+	if (args == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	args->nmd.rsize = NFS_MAX_FILE_IO_SIZE;
+	args->nmd.wsize = NFS_MAX_FILE_IO_SIZE;
+	args->nmd.proto = IPPROTO_TCP;
+	args->nmd.timeo = 600;		/* in tenths of a second */
+	args->nmd.retrans = 2;
+	args->nmd.acregmin = 3;
+	args->nmd.acregmax = 60;
+	args->nmd.acdirmin = 30;
+	args->nmd.acdirmax = 60;
+
+	args->nmd.auth_flavourlen = 0;
+	args->nmd.auth_flavours = &args->authflavor;
+
+	args->nmd.host_addrlen = sizeof(args->addr);
+	args->nmd.host_addr = (struct sockaddr *) &args->addr;
+
+	args->addr.sin_port = htons(NFS_PORT);
+
+	if (nfs4_parse_options((char *) options, args) == 0)
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
  * Finish setting up a cloned NFS4 superblock
  */
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
