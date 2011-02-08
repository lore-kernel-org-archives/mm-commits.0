From: akpm@linux-foundation.org
Subject: [merged] cred-fix-memory-and-refcount-leaks-upon-security_prepare_creds-failure.patch removed from -mm tree
Date: Tue, 08 Feb 2011 12:14:48 -0800
Message-ID: <201102082014.p18KEmnK023130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441Ab1BHUPC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 15:15:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, dhowells@redhat.com, jmorris@namei.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cred: fix memory and refcount leaks upon security_prepare_creds() failure
has been removed from the -mm tree.  Its filename was
     cred-fix-memory-and-refcount-leaks-upon-security_prepare_creds-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cred: fix memory and refcount leaks upon security_prepare_creds() failure
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

In prepare_kernel_cred() since 2.6.29, put_cred(new) is called without
assigning new->usage when security_prepare_creds() returned an error.  As
a result, memory for new and refcount for new->{user,group_info,tgcred}
are leaked because put_cred(new) won't call __put_cred() unless old->usage
== 1.

Fix these leaks by assigning new->usage (and new->subscribers which was
added in 2.6.32) before calling security_prepare_creds().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cred.c~cred-fix-memory-and-refcount-leaks-upon-security_prepare_creds-failure kernel/cred.c
--- a/kernel/cred.c~cred-fix-memory-and-refcount-leaks-upon-security_prepare_creds-failure
+++ a/kernel/cred.c
@@ -657,6 +657,8 @@ struct cred *prepare_kernel_cred(struct 
 	validate_creds(old);
 
 	*new = *old;
+	atomic_set(&new->usage, 1);
+	set_cred_subscribers(new, 0);
 	get_uid(new->user);
 	get_group_info(new->group_info);
 
@@ -674,8 +676,6 @@ struct cred *prepare_kernel_cred(struct 
 	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
 		goto error;
 
-	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
 	put_cred(old);
 	validate_creds(new);
 	return new;
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


