From: akpm@linux-foundation.org
Subject: + netlink-use-generic-lsm-hook.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:41:47 -0800
Message-ID: <200803030741.m237flhL005092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYCCHoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:44:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, casey@schaufler-ca.com, chrisw@sous-sol.org, dwmw2@infradead.org, eparis@parisplace.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk


The patch titled
     Netlink: Use generic LSM hook
has been added to the -mm tree.  Its filename is
     netlink-use-generic-lsm-hook.patch

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
Subject: Netlink: Use generic LSM hook
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Don't use SELinux exported selinux_get_task_sid symbol.  Use the generic LSM
equivalent instead.

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

 net/netlink/af_netlink.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN net/netlink/af_netlink.c~netlink-use-generic-lsm-hook net/netlink/af_netlink.c
--- a/net/netlink/af_netlink.c~netlink-use-generic-lsm-hook
+++ a/net/netlink/af_netlink.c
@@ -54,7 +54,6 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <linux/audit.h>
-#include <linux/selinux.h>
 #include <linux/mutex.h>
 
 #include <net/net_namespace.h>
@@ -1239,7 +1238,7 @@ static int netlink_sendmsg(struct kiocb 
 	NETLINK_CB(skb).pid	= nlk->pid;
 	NETLINK_CB(skb).dst_group = dst_group;
 	NETLINK_CB(skb).loginuid = audit_get_loginuid(current);
-	selinux_get_task_sid(current, &(NETLINK_CB(skb).sid));
+	security_task_getsecid(current, &(NETLINK_CB(skb).sid));
 	memcpy(NETLINK_CREDS(skb), &siocb->scm->creds, sizeof(struct ucred));
 
 	/* What can I do? Netlink is asynchronous, so that
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

