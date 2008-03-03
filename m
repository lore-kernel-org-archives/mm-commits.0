From: akpm@linux-foundation.org
Subject: + selinux-remove-redundant-exports.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:41:49 -0800
Message-ID: <200803030741.m237fn2Y005095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbYCCHqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:46:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, casey@schaufler-ca.com, chrisw@sous-sol.org, dwmw2@infradead.org, eparis@parisplace.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk


The patch titled
     SELinux: remove redundant exports
has been added to the -mm tree.  Its filename is
     selinux-remove-redundant-exports.patch

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
Subject: SELinux: remove redundant exports
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Remove the following exported SELinux interfaces:
selinux_get_inode_sid(inode, sid)
selinux_get_ipc_sid(ipcp, sid)
selinux_get_task_sid(tsk, sid)
selinux_sid_to_string(sid, ctx, len)

They can be substitued with the following generic equivalents
respectively:
new LSM hook, inode_getsecid(inode, secid)
new LSM hook, ipc_getsecid*(ipcp, secid)
LSM hook, task_getsecid(tsk, secid)
LSM hook, sid_to_secctx(sid, ctx, len)

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

 include/linux/selinux.h    |   62 -----------------------------------
 security/selinux/exports.c |   42 -----------------------
 2 files changed, 104 deletions(-)

diff -puN include/linux/selinux.h~selinux-remove-redundant-exports include/linux/selinux.h
--- a/include/linux/selinux.h~selinux-remove-redundant-exports
+++ a/include/linux/selinux.h
@@ -16,7 +16,6 @@
 
 struct selinux_audit_rule;
 struct audit_context;
-struct inode;
 struct kern_ipc_perm;
 
 #ifdef CONFIG_SECURITY_SELINUX
@@ -70,45 +69,6 @@ int selinux_audit_rule_match(u32 sid, u3
 void selinux_audit_set_callback(int (*callback)(void));
 
 /**
- *     selinux_sid_to_string - map a security context ID to a string
- *     @sid: security context ID to be converted.
- *     @ctx: address of context string to be returned
- *     @ctxlen: length of returned context string.
- *
- *     Returns 0 if successful, -errno if not.  On success, the context
- *     string will be allocated internally, and the caller must call
- *     kfree() on it after use.
- */
-int selinux_sid_to_string(u32 sid, char **ctx, u32 *ctxlen);
-
-/**
- *     selinux_get_inode_sid - get the inode's security context ID
- *     @inode: inode structure to get the sid from.
- *     @sid: pointer to security context ID to be filled in.
- *
- *     Returns nothing
- */
-void selinux_get_inode_sid(const struct inode *inode, u32 *sid);
-
-/**
- *     selinux_get_ipc_sid - get the ipc security context ID
- *     @ipcp: ipc structure to get the sid from.
- *     @sid: pointer to security context ID to be filled in.
- *
- *     Returns nothing
- */
-void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid);
-
-/**
- *     selinux_get_task_sid - return the SID of task
- *     @tsk: the task whose SID will be returned
- *     @sid: pointer to security context ID to be filled in.
- *
- *     Returns nothing
- */
-void selinux_get_task_sid(struct task_struct *tsk, u32 *sid);
-
-/**
  *     selinux_string_to_sid - map a security context string to a security ID
  *     @str: the security context string to be mapped
  *     @sid: ID value returned via this.
@@ -175,28 +135,6 @@ static inline void selinux_audit_set_cal
 	return;
 }
 
-static inline int selinux_sid_to_string(u32 sid, char **ctx, u32 *ctxlen)
-{
-       *ctx = NULL;
-       *ctxlen = 0;
-       return 0;
-}
-
-static inline void selinux_get_inode_sid(const struct inode *inode, u32 *sid)
-{
-	*sid = 0;
-}
-
-static inline void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid)
-{
-	*sid = 0;
-}
-
-static inline void selinux_get_task_sid(struct task_struct *tsk, u32 *sid)
-{
-	*sid = 0;
-}
-
 static inline int selinux_string_to_sid(const char *str, u32 *sid)
 {
        *sid = 0;
diff -puN security/selinux/exports.c~selinux-remove-redundant-exports security/selinux/exports.c
--- a/security/selinux/exports.c~selinux-remove-redundant-exports
+++ a/security/selinux/exports.c
@@ -25,48 +25,6 @@
 /* SECMARK reference count */
 extern atomic_t selinux_secmark_refcount;
 
-int selinux_sid_to_string(u32 sid, char **ctx, u32 *ctxlen)
-{
-	if (selinux_enabled)
-		return security_sid_to_context(sid, ctx, ctxlen);
-	else {
-		*ctx = NULL;
-		*ctxlen = 0;
-	}
-
-	return 0;
-}
-
-void selinux_get_inode_sid(const struct inode *inode, u32 *sid)
-{
-	if (selinux_enabled) {
-		struct inode_security_struct *isec = inode->i_security;
-		*sid = isec->sid;
-		return;
-	}
-	*sid = 0;
-}
-
-void selinux_get_ipc_sid(const struct kern_ipc_perm *ipcp, u32 *sid)
-{
-	if (selinux_enabled) {
-		struct ipc_security_struct *isec = ipcp->security;
-		*sid = isec->sid;
-		return;
-	}
-	*sid = 0;
-}
-
-void selinux_get_task_sid(struct task_struct *tsk, u32 *sid)
-{
-	if (selinux_enabled) {
-		struct task_security_struct *tsec = tsk->security;
-		*sid = tsec->sid;
-		return;
-	}
-	*sid = 0;
-}
