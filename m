From: akpm@linux-foundation.org
Subject: - fix-setting-of-pf_superpriv-by-__capable.patch removed from -mm tree
Date: Tue, 24 Jun 2008 12:12:48 -0700
Message-ID: <200806241912.m5OJCnqt001655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091AbYFXTOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 15:14:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix setting of PF_SUPERPRIV by __capable()
has been removed from the -mm tree.  Its filename was
     fix-setting-of-pf_superpriv-by-__capable.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix setting of PF_SUPERPRIV by __capable()
From: David Howells <dhowells@redhat.com>

Fix the setting of PF_SUPERPRIV by __capable() as it could corrupt the
flags the target process if that is not the current process and it is
trying to change its own flags in a different way at the same time.

__capable() is using neither atomic ops nor locking to protect t->flags. 
This patch changes __capable() so it will only set PF_SUPERPRIV if current
is checking its own capabilities.

Possibly we should be setting PF_SUPERPRIV on current, regardless of the
target pointer; however there are cases where you probably don't want to
do this.

Two of the instances of __capable() actually only act on current, and so have
been changed to calls to capable().

Of those that remain:

 (1) The OOM killer calls __capable() thrice when weighing the killability of a
     process.  I think it would be reasonable for this not to set PF_SUPERPRIV
     at all.

 (2) cap_ptrace() and smack_ptrace() are called in two different ways:

     (a) The parent pointer is current, in which case it's securing PT_ATTACH,
     	 and setting PF_SUPERPRIV is correct.

     (b) The parent pointer is current->parent, in which case it's securing
     	 PT_TRACEME, in which case not setting PF_SUPERPRIV is probably
     	 reasonable as no-one has actually used a privileged operation as yet,
     	 merely verified that one can be used.

 (3) In smack_file_send_sigiotask(), we need to allow privileged processes to
     receive SIGIO on files they're manipulating.  Setting PF_SUPERPRIV on
     current is wrong, but setting it on the target might be correct.

 (4) In smack_task_wait(), we let a process wait for a privileged process,
     whether or not the process doing the waiting is privileged.  I'm not sure
     whether this should set PF_SUPERPRIV, and if so on whom.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c        |    3 ++-
 security/commoncap.c       |    2 +-
 security/smack/smack_lsm.c |    6 +++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/capability.c~fix-setting-of-pf_superpriv-by-__capable kernel/capability.c
--- a/kernel/capability.c~fix-setting-of-pf_superpriv-by-__capable
+++ a/kernel/capability.c
@@ -364,7 +364,8 @@ out:
 int __capable(struct task_struct *t, int cap)
 {
 	if (security_capable(t, cap) == 0) {
-		t->flags |= PF_SUPERPRIV;
+		if (t == current)
+			t->flags |= PF_SUPERPRIV;
 		return 1;
 	}
 	return 0;
diff -puN security/commoncap.c~fix-setting-of-pf_superpriv-by-__capable security/commoncap.c
--- a/security/commoncap.c~fix-setting-of-pf_superpriv-by-__capable
+++ a/security/commoncap.c
@@ -528,7 +528,7 @@ int cap_task_post_setuid (uid_t old_ruid
 static inline int cap_safe_nice(struct task_struct *p)
 {
 	if (!cap_issubset(p->cap_permitted, current->cap_permitted) &&
-	    !__capable(current, CAP_SYS_NICE))
+	    !capable(CAP_SYS_NICE))
 		return -EPERM;
 	return 0;
 }
diff -puN security/smack/smack_lsm.c~fix-setting-of-pf_superpriv-by-__capable security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~fix-setting-of-pf_superpriv-by-__capable
+++ a/security/smack/smack_lsm.c
@@ -2038,9 +2038,6 @@ static int smack_setprocattr(struct task
 {
 	char *newsmack;
 
-	if (!__capable(p, CAP_MAC_ADMIN))
-		return -EPERM;
