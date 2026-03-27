Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFE726290
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774574350; cv=none; b=JjsBTt9Kd5zrzeCCqBp1GCkLJwWf4YUe+ho3znavnp+yo+pq69gIciY6ks41dGkeFLc+qQL+cjEODWezOS7Prr5J7jmzkv9lzlryCi+JK8oqDGPHOK/wLsaYxzwqca0U27pNqFSMeMuKj4IPDGM8AXymdsxUksRLIvjU/uv87lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774574350; c=relaxed/simple;
	bh=36MhKpFNtWwlMNboiu70me7FKNEbAgJqBgYF4B3k830=;
	h=Date:To:From:Subject:Message-Id; b=jHaYJuWgHbXO9ZZzM3j2jIdQozmZ6Csj+3Vhira4XyKUcjbSz5kMNOA0MduWOPwExwDPqBF3rw3jrTMlGnLxX+ZKdB8wbC3QQYd4jFX3Tr01z4i7hZ1eJMP8V+LbVJJ7O1bX0wvkag/H99oQwjMkTC1DltEyvskUqzjeaNJxjNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sGExy22O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sGExy22O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF3AC116C6;
	Fri, 27 Mar 2026 01:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774574349;
	bh=36MhKpFNtWwlMNboiu70me7FKNEbAgJqBgYF4B3k830=;
	h=Date:To:From:Subject:From;
	b=sGExy22OUhwcQtuV1J0L4Wy71VXM8bHM33CCAcc8iQakAUzAqwDkbvRuW/GXxx9Ok
	 iw1PDBqt3LzG8t9NSfqfJOb0igjj4EMd5APt8PM4QEhOVxTzID91ZRR2zORW42ijW/
	 ubOGgf8lP8bsaDC1CAjcey8ckl2ILm51ufKRZKyI=
Date: Thu, 26 Mar 2026 18:19:09 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,shuah@kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-prevent-double-management-of-files.patch added to mm-new branch
Message-Id: <20260327011909.ACF3AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: prevent double management of files
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-prevent-double-management-of-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-prevent-double-management-of-files.patch

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
Subject: liveupdate: prevent double management of files
Date: Thu, 26 Mar 2026 16:39:41 +0000

Patch series "liveupdate: prevent double preservation", v4.

Currently, LUO does not prevent the same file from being managed twice
across different active sessions.

Because LUO preserves files of absolutely different types: memfd, and
upcoming vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd).
There is no common private data or guarantee on how to prevent that the
same file is not preserved twice beside using inode or some slower and
expensive method like hashtables.


This patch (of 4)

Currently, LUO does not prevent the same file from being managed twice
across different active sessions.

Use a global xarray luo_preserved_files to keep track of file identifiers
being preserved by LUO.  Update luo_preserve_file() to check and insert
the file identifier into this xarray when it is preserved, and erase it in
luo_file_unpreserve_files() when it is released.

To allow handlers to define what constitutes a "unique" file (e.g.,
different struct file objects pointing to the same hardware resource), add
a get_id() callback to struct liveupdate_file_ops.  If not provided, the
default identifier is the struct file pointer itself.

This ensures that the same file (or resource) cannot be managed by
multiple sessions.  If another session attempts to preserve an already
managed file, it will now fail with -EBUSY.

Link: https://lkml.kernel.org/r/20260326163943.574070-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20260326163943.574070-2-pasha.tatashin@soleen.com
Link: https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google.com [1]
Link: https://lore.kernel.org/all/20260203220948.2176157-1-skhawaja@google.com [2]
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h   |    2 ++
 kernel/liveupdate/luo_file.c |   32 ++++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

--- a/include/linux/liveupdate.h~liveupdate-prevent-double-management-of-files
+++ a/include/linux/liveupdate.h
@@ -64,6 +64,7 @@ struct liveupdate_file_op_args {
  *                finish, in order to do successful finish calls for all
  *                resources in the session.
  * @finish:       Required. Final cleanup in the new kernel.
+ * @get_id:       Optional. Returns a unique identifier for the file.
  * @owner:        Module reference
  *
  * All operations (except can_preserve) receive a pointer to a
@@ -79,6 +80,7 @@ struct liveupdate_file_ops {
 	int (*retrieve)(struct liveupdate_file_op_args *args);
 	bool (*can_finish)(struct liveupdate_file_op_args *args);
 	void (*finish)(struct liveupdate_file_op_args *args);
+	unsigned long (*get_id)(struct file *file);
 	struct module *owner;
 };
 
--- a/kernel/liveupdate/luo_file.c~liveupdate-prevent-double-management-of-files
+++ a/kernel/liveupdate/luo_file.c
@@ -108,6 +108,7 @@
 #include <linux/liveupdate.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
+#include <linux/xarray.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include "luo_internal.h"
@@ -115,6 +116,9 @@
 static DECLARE_RWSEM(luo_file_handler_lock);
 static LIST_HEAD(luo_file_handler_list);
 
+/* Keep track of files being preserved by LUO */
+static DEFINE_XARRAY(luo_preserved_files);
+
 /* 2 4K pages, give space for 128 files per file_set */
 #define LUO_FILE_PGCNT		2ul
 #define LUO_FILE_MAX							\
@@ -204,6 +208,12 @@ static void luo_free_files_mem(struct lu
 	file_set->files = NULL;
 }
 
+static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
+				struct file *file)
+{
+	return fh->ops->get_id ? fh->ops->get_id(file) : (unsigned long)file;
+}
+
 static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
 {
 	struct luo_file *iter;
@@ -249,6 +259,7 @@ static bool luo_token_is_used(struct luo
  * Context: Can be called from an ioctl handler during normal system operation.
  * Return: 0 on success. Returns a negative errno on failure:
  *         -EEXIST if the token is already used.
+ *         -EBUSY if the file descriptor is already preserved by another session.
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
  *         -ENOENT if no compatible handler is found.
@@ -291,10 +302,15 @@ int luo_preserve_file(struct luo_file_se
 	if (err)
 		goto err_free_files_mem;
 
-	err = luo_flb_file_preserve(fh);
+	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
+			file, GFP_KERNEL);
 	if (err)
 		goto err_free_files_mem;
 
+	err = luo_flb_file_preserve(fh);
+	if (err)
+		goto err_erase_xa;
+
 	luo_file = kzalloc_obj(*luo_file);
 	if (!luo_file) {
 		err = -ENOMEM;
@@ -323,6 +339,8 @@ err_kfree:
 	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
+err_erase_xa:
+	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -366,6 +384,8 @@ void luo_file_unpreserve_files(struct lu
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
+		xa_erase(&luo_preserved_files,
+			 luo_get_id(luo_file->fh, luo_file->file));
 		list_del(&luo_file->list);
 		file_set->count--;
 
@@ -609,6 +629,11 @@ int luo_retrieve_file(struct luo_file_se
 	luo_file->file = args.file;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
+
+	WARN_ON(xa_insert(&luo_preserved_files,
+			  luo_get_id(luo_file->fh, luo_file->file),
+			  luo_file->file, GFP_KERNEL));
+
 	*filep = luo_file->file;
 	luo_file->retrieve_status = 1;
 
@@ -704,8 +729,11 @@ int luo_file_finish(struct luo_file_set
 
 		luo_file_finish_one(file_set, luo_file);
 
-		if (luo_file->file)
+		if (luo_file->file) {
+			xa_erase(&luo_preserved_files,
+				 luo_get_id(luo_file->fh, luo_file->file));
 			fput(luo_file->file);
+		}
 		list_del(&luo_file->list);
 		file_set->count--;
 		mutex_destroy(&luo_file->mutex);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-rwsem.patch
liveupdate-remove-file-handler-module-refcounting.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch
liveupdate-prevent-double-management-of-files.patch
memfd-implement-get_id-for-memfd_luo.patch
selftests-liveupdate-add-test-for-double-preservation.patch

