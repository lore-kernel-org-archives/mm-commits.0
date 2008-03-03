From: akpm@linux-foundation.org
Subject: + selinux-setup-new-inode-ipc-getsecid-hooks.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:41:43 -0800
Message-ID: <200803030741.m237fhED005086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbYCCHo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:44:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, casey@schaufler-ca.com, chrisw@sous-sol.org, dwmw2@infradead.org, eparis@parisplace.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk


The patch titled
     SELinux: setup new inode/ipc getsecid hooks
has been added to the -mm tree.  Its filename is
     selinux-setup-new-inode-ipc-getsecid-hooks.patch

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
Subject: SELinux: setup new inode/ipc getsecid hooks
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Setup the new inode_getsecid and ipc_getsecid() LSM hooks for SELinux.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Moore <paul.moore@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN security/selinux/hooks.c~selinux-setup-new-inode-ipc-getsecid-hooks security/selinux/hooks.c
--- a/security/selinux/hooks.c~selinux-setup-new-inode-ipc-getsecid-hooks
+++ a/security/selinux/hooks.c
@@ -2749,6 +2749,12 @@ static int selinux_inode_killpriv(struct
 	return secondary_ops->inode_killpriv(dentry);
 }
 
+static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	struct inode_security_struct *isec = inode->i_security;
+	*secid = isec->sid;
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -3145,7 +3151,8 @@ static int selinux_task_getsid(struct ta
 
 static void selinux_task_getsecid(struct task_struct *p, u32 *secid)
 {
-	selinux_get_task_sid(p, secid);
+	struct task_security_struct *tsec = p->security;
+	*secid = tsec->sid;
 }
 
 static int selinux_task_setgroups(struct group_info *group_info)
@@ -4116,7 +4123,7 @@ static int selinux_socket_getpeersec_dgr
 		goto out;
 
 	if (sock && family == PF_UNIX)
-		selinux_get_inode_sid(SOCK_INODE(sock), &peer_secid);
+		selinux_inode_getsecid(SOCK_INODE(sock), &peer_secid);
 	else if (skb)
 		selinux_skb_peerlbl_sid(skb, family, &peer_secid);
 
@@ -4994,6 +5001,12 @@ static int selinux_ipc_permission(struct
 	return ipc_has_perm(ipcp, av);
 }
 
+static void selinux_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+{
+	struct ipc_security_struct *isec = ipcp->security;
+	*secid = isec->sid;
+}
+
 /* module stacking operations */
 static int selinux_register_security (const char *name, struct security_operations *ops)
 {
@@ -5301,6 +5314,7 @@ static struct security_operations selinu
 	.inode_listsecurity =           selinux_inode_listsecurity,
 	.inode_need_killpriv =		selinux_inode_need_killpriv,
 	.inode_killpriv =		selinux_inode_killpriv,
+	.inode_getsecid =               selinux_inode_getsecid,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,
@@ -5341,6 +5355,7 @@ static struct security_operations selinu
 	.task_to_inode =                selinux_task_to_inode,
 
 	.ipc_permission =		selinux_ipc_permission,
+	.ipc_getsecid =                 selinux_ipc_getsecid,
 
 	.msg_msg_alloc_security =	selinux_msg_msg_alloc_security,
 	.msg_msg_free_security =	selinux_msg_msg_free_security,
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-kvm.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks.patch
selinux-setup-new-inode-ipc-getsecid-hooks.patch
audit-use-new-lsm-hooks-instead-of-selinux-exports.patch
netlink-use-generic-lsm-hook.patch
selinux-remove-redundant-exports.patch
lsm-audit-introduce-generic-audit-lsm-hooks.patch
audit-internally-use-the-new-lsm-audit-hooks.patch
selinux-use-new-audit-hooks-remove-redundant-exports.patch
audit-final-renamings-and-cleanup.patch

