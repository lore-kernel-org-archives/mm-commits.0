Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59880363C60
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857150; cv=none; b=HHMNjONF+Pgx1KeYMJec9tDlTFlXtrA/n6H9/7ejFxXb8B01kL0iJrhL0IdNqMcsV0aFDsabHC0Y1Fy4dKa6VyogaA/hLXLugdryaEpivQaXdImoEH2KFSGUy2e81RWovUoxIt9DAZhCDDD6NddKAud7aZ5jemQb5rkAmSE0FaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857150; c=relaxed/simple;
	bh=1qAMTEzPUDPtEWlBLUCrnqO4InIZUXrAgw9Q8RQ0sMw=;
	h=Date:To:From:Subject:Message-Id; b=YeRwGrbzMIn98+g15w1mAW5+Zb3xpcaeHx5kxlBvxj6iTx3grnscMoX0PqmdqhBQpLhWwIuLmF7tuJr5jEPj8I0ar+iDc8q9lXm58z9Xt1YArncJbd1r2OOscFDaGNYSxpD3M+jN/TC+Q9CDAQJHhaSBwSv07YInsDWcUnFlj54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XvXh6HWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XvXh6HWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A8AC19421;
	Wed, 18 Mar 2026 18:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773857150;
	bh=1qAMTEzPUDPtEWlBLUCrnqO4InIZUXrAgw9Q8RQ0sMw=;
	h=Date:To:From:Subject:From;
	b=XvXh6HWPpuudk6wXssXjlvpNhZsPW6rdvK27FkC3zTdYoa8Zcgcn2TwJErDqXtpM2
	 VL272MUw4GwJVLTEy2EfK/enHW41DTNnb7xP0p3urOxWDhVbW8p94HPmSiAOf9tjSf
	 7ZX0cvV5L1OdV8G811XaBJmbXHGqnScyRVvci8hk=
Date: Wed, 18 Mar 2026 11:05:49 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-remove-file-handler-module-refcounting.patch added to mm-new branch
Message-Id: <20260318180549.F3A8AC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: remove file handler module refcounting
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-remove-file-handler-module-refcounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-remove-file-handler-module-refcounting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: remove file handler module refcounting
Date: Wed, 18 Mar 2026 10:16:41 -0400

File handlers do not need to pin modules indefinitely or during active
live update sessions.  The VFS 'struct file' pins the file handler's
module via f_op->owner during active sessions, making dynamic reference
counting unnecessary for handlers.

When a file is preserved, the live update core obtains a 'struct file' via
fdget().  As long as the file is kept open within the live update session,
the module is pinned by the VFS and cannot be unloaded.

Similarly, during deserialization, file handlers are matched based on the
compatible string.  Because the handler list is protected by
luo_file_handler_lock, there is no race that requires dynamic module
refcounting.

Removing these module references ensures that modules implementing file
handlers can be unloaded when no longer providing active files.

Link: https://lkml.kernel.org/r/20260318141637.1870220-13-pasha.tatashin@soleen.com
Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-remove-file-handler-module-refcounting
+++ a/kernel/liveupdate/luo_file.c
@@ -836,7 +836,6 @@ void luo_file_set_destroy(struct luo_fil
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 {
 	struct liveupdate_file_handler *fh_iter;
-	int err;
 
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
@@ -861,17 +860,11 @@ int liveupdate_register_file_handler(str
 			if (!strcmp(fh_iter->compatible, fh->compatible)) {
 				pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
 				       fh->compatible);
-				err = -EEXIST;
-				goto err_resume;
+				luo_session_resume();
+				return -EEXIST;
 			}
 		}
 
-		/* Pin the module implementing the handler */
-		if (!try_module_get(fh->ops->owner)) {
-			err = -EAGAIN;
-			goto err_resume;
-		}
-
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
 		init_rwsem(&ACCESS_PRIVATE(fh, flb_lock));
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
@@ -882,10 +875,6 @@ int liveupdate_register_file_handler(str
 	liveupdate_test_register(fh);
 
 	return 0;
-
-err_resume:
-	luo_session_resume();
-	return err;
 }
 
 /**
@@ -907,8 +896,6 @@ err_resume:
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	int err = -EBUSY;
-
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
@@ -918,19 +905,18 @@ int liveupdate_unregister_file_handler(s
 		goto err_register;
 
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
-		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-			goto err_resume;
+		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list))) {
+			luo_session_resume();
+			goto err_register;
+		}
 
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
-	module_put(fh->ops->owner);
 	luo_session_resume();
 
 	return 0;
 
-err_resume:
-	luo_session_resume();
 err_register:
 	liveupdate_test_register(fh);
-	return err;
+	return -EBUSY;
 }
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-vmalloc-export-clear_vm_uninitialized_flag.patch
kho-fix-kasan-support-for-restored-vmalloc-regions.patch
liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-rwsem.patch
liveupdate-remove-file-handler-module-refcounting.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch

