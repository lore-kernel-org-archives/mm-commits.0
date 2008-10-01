From: akpm@linux-foundation.org
Subject: - cred-delete-alloc_creds-as-its-not-used.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:24:56 -0700
Message-ID: <200810012124.m91LOuWd004798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbYJAVZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:25:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     cred: delete alloc_creds() as it's not used
has been removed from the -mm tree.  Its filename was
     cred-delete-alloc_creds-as-its-not-used.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cred: delete alloc_creds() as it's not used
From: David Howells <dhowells@redhat.com>

Delete alloc_creds() as it's not used.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred-internals.h |    5 -----
 kernel/cred.c           |   15 ---------------
 2 files changed, 20 deletions(-)

diff -puN kernel/cred-internals.h~cred-delete-alloc_creds-as-its-not-used kernel/cred-internals.h
--- a/kernel/cred-internals.h~cred-delete-alloc_creds-as-its-not-used
+++ a/kernel/cred-internals.h
@@ -10,11 +10,6 @@
  */
 
 /*
- * cred.c
- */
-extern struct cred *alloc_creds(const struct cred *, gfp_t);
-
-/*
  * user.c
  */
 static inline void sched_switch_user(struct task_struct *p)
diff -puN kernel/cred.c~cred-delete-alloc_creds-as-its-not-used kernel/cred.c
--- a/kernel/cred.c~cred-delete-alloc_creds-as-its-not-used
+++ a/kernel/cred.c
@@ -112,21 +112,6 @@ void __put_cred(struct cred *cred)
 }
 EXPORT_SYMBOL(__put_cred);
 
-/*
- * Allocate new credentials
- */
-struct cred *alloc_creds(const struct cred *old, gfp_t gfp)
-{
-	struct cred *new;
-
-	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
-	if (!new)
-		return NULL;
-	if (old)
-		memcpy(new, old, sizeof(struct cred));
-	return new;
-}
-
 /**
  * prepare_creds - Prepare a new set of credentials for modification
  *
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-v4l-dvb.patch
git-xfs.patch
git-mtd.patch
git-cifs.patch
git-drm.patch
git-security-testing.patch
cifs-fix-range-check.patch
cred-delete-alloc_creds-as-its-not-used.patch
uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
sysctl-simplify-strategy.patch
mn10300-use-bcd2bin-bin2bcd.patch
mutex-subsystem-synchro-test-module.patch

