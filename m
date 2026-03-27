Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2788D175A9E
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632177; cv=none; b=Bb0xVJOVx3WDGIz7CUw2RwcYAOSaunvchDNXxx+Mw8cOxXO8Fl4qeKWkn5PKHmFLAFwNA8QkK9XrVZs/WniOduHrJ+9U2vDdZC/FiDYPMBQPnIcOVmXspfPjM0mD5YKt+PYkGVKNSwmDrDh1JgANgXRrJE/dEI8DdPPNYPD32vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632177; c=relaxed/simple;
	bh=jA0dITAyYIADKCkTQOFLEYdpvXs7p4ZOvI0gC+GMcSw=;
	h=Date:To:From:Subject:Message-Id; b=YQ+mX3uMWwy4QbxDy+68Glzt3ughffIIKGxjLuHuFQQ+qW5Q3Yc4IdULgT63GV70hMvJ3866GX6tgY5DBkVrUCQYjvmgewE6hh6A05qO5C5VQ+FVfKTdXmUjsF4UONU3k1/8r3rdEH1O9jMG1zKyLvdSmC891Pe0Y0NlNs15Mw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H0bUA7H6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H0bUA7H6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0254C19423;
	Fri, 27 Mar 2026 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632176;
	bh=jA0dITAyYIADKCkTQOFLEYdpvXs7p4ZOvI0gC+GMcSw=;
	h=Date:To:From:Subject:From;
	b=H0bUA7H6Lvrn9HwJVXymVPg+Z+X9ekPDYRvbnsopBpvMzQHapD9X8mXJ1ZEAdPtIN
	 63XIuVvOikQvmG7ZN4xCPnrJkhT0GtuEmx8oqUMvovpZhwmFHyC/M3nYED0c0jDHbZ
	 QylUhovtzpanItefe2eJgnb8ipuE7+AAL1RdA2pU=
Date: Fri, 27 Mar 2026 10:22:56 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-defer-file-handler-module-refcounting-to-active-sessions.patch added to mm-new branch
Message-Id: <20260327172256.C0254C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: defer file handler module refcounting to active sessions
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-defer-file-handler-module-refcounting-to-active-sessions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-defer-file-handler-module-refcounting-to-active-sessions.patch

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
Subject: liveupdate: defer file handler module refcounting to active sessions
Date: Fri, 27 Mar 2026 03:33:34 +0000

Stop pinning modules indefinitely upon file handler registration. 
Instead, dynamically increment the module reference count only when a live
update session actively uses the file handler (e.g., during preservation
or deserialization), and release it when the session ends.

This allows modules providing live update handlers to be gracefully
unloaded when no live update is in progress.

Link: https://lkml.kernel.org/r/20260327033335.696621-11-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-defer-file-handler-module-refcounting-to-active-sessions
+++ a/kernel/liveupdate/luo_file.c
@@ -291,7 +291,8 @@ int luo_preserve_file(struct luo_file_se
 	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 		if (fh->ops->can_preserve(fh, file)) {
-			err = 0;
+			if (try_module_get(fh->ops->owner))
+				err = 0;
 			break;
 		}
 	}
@@ -304,7 +305,7 @@ int luo_preserve_file(struct luo_file_se
 	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
 			file, GFP_KERNEL);
 	if (err)
-		goto err_free_files_mem;
+		goto err_module_put;
 
 	err = luo_flb_file_preserve(fh);
 	if (err)
@@ -340,6 +341,8 @@ err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
 err_erase_xa:
 	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
+err_module_put:
+	module_put(fh->ops->owner);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -382,6 +385,7 @@ void luo_file_unpreserve_files(struct lu
 		args.private_data = luo_file->private_data;
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
+		module_put(luo_file->fh->ops->owner);
 
 		xa_erase(&luo_preserved_files,
 			 luo_get_id(luo_file->fh, luo_file->file));
@@ -673,6 +677,7 @@ static void luo_file_finish_one(struct l
 
 	luo_file->fh->ops->finish(&args);
 	luo_flb_file_finish(luo_file->fh);
+	module_put(luo_file->fh->ops->owner);
 }
 
 /**
@@ -810,7 +815,8 @@ int luo_file_deserialize(struct luo_file
 		down_read(&luo_register_rwlock);
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-				handler_found = true;
+				if (try_module_get(fh->ops->owner))
+					handler_found = true;
 				break;
 			}
 		}
@@ -824,8 +830,10 @@ int luo_file_deserialize(struct luo_file
 		}
 
 		luo_file = kzalloc_obj(*luo_file);
-		if (!luo_file)
+		if (!luo_file) {
+			module_put(fh->ops->owner);
 			return -ENOMEM;
+		}
 
 		luo_file->fh = fh;
 		luo_file->file = NULL;
@@ -886,12 +894,6 @@ int liveupdate_register_file_handler(str
 		}
 	}
 
-	/* Pin the module implementing the handler */
-	if (!try_module_get(fh->ops->owner)) {
-		err = -EAGAIN;
-		goto err_unlock;
-	}
-
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
@@ -921,6 +923,4 @@ void liveupdate_unregister_file_handler(
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
-
-	module_put(fh->ops->owner);
 }
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-prevent-double-management-of-files.patch
memfd-implement-get_id-for-memfd_luo.patch
selftests-liveupdate-add-test-for-double-preservation.patch
liveupdate-safely-print-untrusted-strings.patch
liveupdate-synchronize-lazy-initialization-of-flb-private-state.patch
liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-luo_register_rwlock.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch
liveupdate-defer-file-handler-module-refcounting-to-active-sessions.patch

