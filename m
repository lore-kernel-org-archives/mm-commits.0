From: akpm@linux-foundation.org
Subject: + cred-fix-bug-upon-security_cred_alloc_blank-failure.patch added to -mm tree
Date: Mon, 07 Feb 2011 15:24:01 -0800
Message-ID: <201102072324.p17NO1lV001871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092Ab1BGXYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2011 18:24:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penguin-kernel@I-love.SAKURA.ne.jp, dhowells@redhat.com, jmorris@namei.org


The patch titled
     cred: fix BUG() upon security_cred_alloc_blank() failure
has been added to the -mm tree.  Its filename is
     cred-fix-bug-upon-security_cred_alloc_blank-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cred: fix BUG() upon security_cred_alloc_blank() failure
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

In cred_alloc_blank() since 2.6.32, abort_creds(new) is called with
new->security == NULL and new->magic == 0 when security_cred_alloc_blank()
returns an error.  As a result, BUG() will be triggered if SELinux is
enabled or CONFIG_DEBUG_CREDENTIALS=y.

If CONFIG_DEBUG_CREDENTIALS=y, BUG() is called from __invalid_creds()
because cred->magic == 0.  Failing that, BUG() is called from
selinux_cred_free() because selinux_cred_free() is not expecting
cred->security == NULL.  This does not affect smack_cred_free(),
tomoyo_cred_free() or apparmor_cred_free().

Fix these bugs by

(1) Set new->magic before calling security_cred_alloc_blank().

(2) Handle null cred->security in creds_are_invalid() and selinux_cred_free().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred.c            |   12 ++++++++----
 security/selinux/hooks.c |    6 +++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN kernel/cred.c~cred-fix-bug-upon-security_cred_alloc_blank-failure kernel/cred.c
--- a/kernel/cred.c~cred-fix-bug-upon-security_cred_alloc_blank-failure
+++ a/kernel/cred.c
@@ -252,13 +252,13 @@ struct cred *cred_alloc_blank(void)
 #endif
 
 	atomic_set(&new->usage, 1);
+#ifdef CONFIG_DEBUG_CREDENTIALS
+	new->magic = CRED_MAGIC;
+#endif
 
 	if (security_cred_alloc_blank(new, GFP_KERNEL) < 0)
 		goto error;
 
-#ifdef CONFIG_DEBUG_CREDENTIALS
-	new->magic = CRED_MAGIC;
-#endif
 	return new;
 
 error:
@@ -748,7 +748,11 @@ bool creds_are_invalid(const struct cred
 	if (cred->magic != CRED_MAGIC)
 		return true;
 #ifdef CONFIG_SECURITY_SELINUX
-	if (selinux_is_enabled()) {
+	/*
+	 * cred->security == NULL if security_cred_alloc_blank() or
+	 * security_prepare_creds() returned an error.
+	 */
+	if (selinux_is_enabled() && cred->security) {
 		if ((unsigned long) cred->security < PAGE_SIZE)
 			return true;
 		if ((*(u32 *)cred->security & 0xffffff00) ==
diff -puN security/selinux/hooks.c~cred-fix-bug-upon-security_cred_alloc_blank-failure security/selinux/hooks.c
--- a/security/selinux/hooks.c~cred-fix-bug-upon-security_cred_alloc_blank-failure
+++ a/security/selinux/hooks.c
@@ -3198,7 +3198,11 @@ static void selinux_cred_free(struct cre
 {
 	struct task_security_struct *tsec = cred->security;
 
-	BUG_ON((unsigned long) cred->security < PAGE_SIZE);
+	/*
+	 * cred->security == NULL if security_cred_alloc_blank() or
+	 * security_prepare_creds() returned an error.
+	 */
+	BUG_ON(cred->security && (unsigned long) cred->security < PAGE_SIZE);
 	cred->security = (void *) 0x7UL;
 	kfree(tsec);
 }
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

origin.patch
cred-fix-bug-upon-security_cred_alloc_blank-failure.patch
cred-fix-memory-and-refcount-leaks-upon-security_prepare_creds-failure.patch

