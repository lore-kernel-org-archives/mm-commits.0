Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CA23ACA74
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857145; cv=none; b=BjvXV9BT4JSMCH0QOG6SLJsjKOeV9EZ4ks4H+N7IrSpa3SjKcyLqMq6rLNIC0oRxAVv01OgoLkPVuRPiVxR26k1jFeYiD8cXLwH28ViBLpIRbJG8tlXVJOzkE1QnuZM1Ro2OdbQsQHpQJJ1UnB0UfwBnF3VAsI5FC7otBoG3IEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857145; c=relaxed/simple;
	bh=W4D2nPBTOX1g1U98WYNpO4UamHFIiWie9XNnGCdT9uk=;
	h=Date:To:From:Subject:Message-Id; b=j5yfF0MMdIEO1fwHglWzS/qI42PfysgEnYLWNOPC/gECyo00fqb6d895IkbObct3CGCRM9FGOsKuEonuZQE7WH0lhWlgr6ParMTy1PVVArAxw0h1Gv8rnYDJHfIA0UNLYrgFOxWp2uaWC3W8XYSmtNon6sXYDgPb8BtCvTRWbq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ebgD7q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ebgD7q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA2AC19421;
	Wed, 18 Mar 2026 18:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773857144;
	bh=W4D2nPBTOX1g1U98WYNpO4UamHFIiWie9XNnGCdT9uk=;
	h=Date:To:From:Subject:From;
	b=0ebgD7q8l9BIlS3C/skv5FdbBi+hX5UAi7WxbJ4TLbssHkGqCN/TxSmOpUhwY+MIl
	 BGvPSRelhoTUwowOEeITSKkUWq6mPX/+QZh5jJFskw+PU8KTycgnXZymdq8TnpOFQV
	 WKWezNK3A9CVn6mBHbeXChgjncI+6ajHEeVYgD2g=
Date: Wed, 18 Mar 2026 11:05:44 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-protect-file-handler-list-with-rwsem.patch added to mm-new branch
Message-Id: <20260318180544.BBA2AC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: protect file handler list with rwsem
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-protect-file-handler-list-with-rwsem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-protect-file-handler-list-with-rwsem.patch

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
Subject: liveupdate: protect file handler list with rwsem
Date: Wed, 18 Mar 2026 10:16:39 -0400

Patch series "liveupdate: Fix module unloading and unregister API", v2.

This patch series addresses an issue with how LUO handles module reference
counting and unregistration during a module unload (e.g., via rmmod).

Currently, modules that register live update file handlers are pinned for
the entire duration they are registered.  This prevents the modules from
being unloaded gracefully, even when no live update session is in
progress.

Furthermore, if a module is forcefully unloaded, the unregistration
functions return an error (e.g.  -EBUSY) if a session is active, which is
ignored by the kernel's module unload path, leaving dangling pointers in
the LUO global lists.

As pointed out by Jason Gunthorpe and Alex Williamson during the review
of the VFIO PCI live update patches [1]:
> "destroy" functions that fail are evil. :)
> IMHO blow up the kernel or something in the core code, you can't stop
> module unloading once it starts so it is pointless to propagate this

To resolve these issues, this series introduces the following changes:
1. Adds read-write semaphores (luo_file_handler_lock, luo_flb_lock, and
   a per-handler flb_lock) to protect the registration lists. This allows
   concurrent access for file preservation without blocking, while still
   preventing traversal races during module unload.
2. Defers FLB module reference counting (try_module_get / module_put)
   so that modules are only pinned when their FLBs are actively used
   in a live update session.
3. Removes module reference counting for file handlers, relying
   on the VFS 'struct file' pinning (via f_op->owner) and safe
   deserialization without concurrent unloads.
4. Removes the global luo_session_quiesce() mechanism since module
   unload behavior now handles active sessions implicitly.
5. Introduces auto-unregistration of FLBs during file handler
   unregistration to prevent leaving dangling resources.
6. Changes the unregistration functions to return void instead of
   an error code.


This patch (of 8):

Because liveupdate file handlers will no longer hold a module reference
when registered, we must ensure that the access to the handler list is
protected against concurrent module unloading.

Link: https://lkml.kernel.org/r/20260318141637.1870220-11-pasha.tatashin@soleen.com
Link: https://lore.kernel.org/all/20260303210733.GG972761@nvidia.com [1]
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c |   61 ++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 26 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-protect-file-handler-list-with-rwsem
+++ a/kernel/liveupdate/luo_file.c
@@ -112,6 +112,7 @@
 #include <linux/string.h>
 #include "luo_internal.h"
 
+static DECLARE_RWSEM(luo_file_handler_lock);
 static LIST_HEAD(luo_file_handler_list);
 
 /* 2 4K pages, give space for 128 files per file_set */
@@ -277,10 +278,12 @@ int luo_preserve_file(struct luo_file_se
 		goto  err_fput;
 
 	err = -ENOENT;
-	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-		if (fh->ops->can_preserve(fh, file)) {
-			err = 0;
-			break;
+	scoped_guard(rwsem_read, &luo_file_handler_lock) {
+		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+			if (fh->ops->can_preserve(fh, file)) {
+				err = 0;
+				break;
+			}
 		}
 	}
 
@@ -777,10 +780,12 @@ int luo_file_deserialize(struct luo_file
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
-		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-				handler_found = true;
-				break;
+		scoped_guard(rwsem_read, &luo_file_handler_lock) {
+			list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+				if (!strcmp(fh->compatible, file_ser[i].compatible)) {
+					handler_found = true;
+					break;
+				}
 			}
 		}
 
@@ -850,25 +855,27 @@ int liveupdate_register_file_handler(str
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
-	/* Check for duplicate compatible strings */
-	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
-		if (!strcmp(fh_iter->compatible, fh->compatible)) {
-			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
-			       fh->compatible);
-			err = -EEXIST;
+	scoped_guard(rwsem_write, &luo_file_handler_lock) {
+		/* Check for duplicate compatible strings */
+		list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
+			if (!strcmp(fh_iter->compatible, fh->compatible)) {
+				pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
+				       fh->compatible);
+				err = -EEXIST;
+				goto err_resume;
+			}
+		}
+
+		/* Pin the module implementing the handler */
+		if (!try_module_get(fh->ops->owner)) {
+			err = -EAGAIN;
 			goto err_resume;
 		}
-	}
 
-	/* Pin the module implementing the handler */
-	if (!try_module_get(fh->ops->owner)) {
-		err = -EAGAIN;
-		goto err_resume;
+		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
+		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
+		list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	}
-
-	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
-	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
-	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	luo_session_resume();
 
 	liveupdate_test_register(fh);
@@ -909,10 +916,12 @@ int liveupdate_unregister_file_handler(s
 	if (!luo_session_quiesce())
 		goto err_register;
 
-	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-		goto err_resume;
+	scoped_guard(rwsem_write, &luo_file_handler_lock) {
+		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
+			goto err_resume;
 
-	list_del(&ACCESS_PRIVATE(fh, list));
+		list_del(&ACCESS_PRIVATE(fh, list));
+	}
 	module_put(fh->ops->owner);
 	luo_session_resume();
 
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

