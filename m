Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25961C2AA
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498738; cv=none; b=LphKGe0rDWQOWNXTD/iHf6dTaXJoBBUnmEnJ38wAiVEM+8Xz6BMOzJc0ZIgFjNZ08f7XfWOYBaUaviExbgweAOFiIodscUolMlLKeykr0P2vs9BWKz9DMwf9qlhsYN8Cq0tpxqbAYqOT3ELuB7gC6UVTQMRCE4LQtc4wfw6KBq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498738; c=relaxed/simple;
	bh=vYLW12hcf0CW6nAqGpA8hmgXAic9pwCMRHK08KMo1bI=;
	h=Date:To:From:Subject:Message-Id; b=QDwsDk8NdLvllxM5YbM7lHtFw1Bfi9lhT5q8c8rh77BTqNp/tFeknhmvCp6H8fuKh9CREW6Ys4+ZyVjlI8SHi/4aU52XFdnp2lVEXtBl7HVOBxRsTROfh96BNQrFihNcp6eNUpSOQzFp4ShV4KAyf53kjuzcbeSWyf0B3FNa0Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R9I8BzMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R9I8BzMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBA2C19424;
	Sat, 18 Apr 2026 07:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498738;
	bh=vYLW12hcf0CW6nAqGpA8hmgXAic9pwCMRHK08KMo1bI=;
	h=Date:To:From:Subject:From;
	b=R9I8BzMQUmR3aUv5BEG92f/HJff42gayNe7Lbm2wGR/+ApPZI2xPh9QVJOJ/4MNcg
	 IJw/mqnt4i3SU2/WDPYDRymf9limdCgVgwlo5Z3dTiXRZivdTeeBzDtugNbn3gYTZp
	 U9vOnSctbVdtNXwGhh6Fvy1QHfC/W47MGTX8dcaM=
Date: Sat, 18 Apr 2026 00:52:13 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,shuah@kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-prevent-double-management-of-files.patch removed from -mm tree
Message-Id: <20260418075217.4BBA2C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: prevent double management of files
has been removed from the -mm tree.  Its filename was
     liveupdate-prevent-double-management-of-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260326163943.574070-1-pasha.tatashin@soleen.com
Link: https://lore.kernel.org/20260326163943.574070-2-pasha.tatashin@soleen.com
Link: https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google.com [1]
Link: https://lore.kernel.org/all/20260203220948.2176157-1-skhawaja@google.com [2]
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christian Brauner <brauner@kernel.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h   |    2 ++
 kernel/liveupdate/luo_file.c |   32 ++++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

--- a/include/linux/liveupdate.h~liveupdate-prevent-double-management-of-files
+++ a/include/linux/liveupdate.h
@@ -63,6 +63,7 @@ struct liveupdate_file_op_args {
  *                finish, in order to do successful finish calls for all
  *                resources in the session.
  * @finish:       Required. Final cleanup in the new kernel.
+ * @get_id:       Optional. Returns a unique identifier for the file.
  * @owner:        Module reference
  *
  * All operations (except can_preserve) receive a pointer to a
@@ -78,6 +79,7 @@ struct liveupdate_file_ops {
 	int (*retrieve)(struct liveupdate_file_op_args *args);
 	bool (*can_finish)(struct liveupdate_file_op_args *args);
 	void (*finish)(struct liveupdate_file_op_args *args);
+	unsigned long (*get_id)(struct file *file);
 	struct module *owner;
 };
 
--- a/kernel/liveupdate/luo_file.c~liveupdate-prevent-double-management-of-files
+++ a/kernel/liveupdate/luo_file.c
@@ -108,12 +108,16 @@
 #include <linux/liveupdate.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
+#include <linux/xarray.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include "luo_internal.h"
 
 static LIST_HEAD(luo_file_handler_list);
 
+/* Keep track of files being preserved by LUO */
+static DEFINE_XARRAY(luo_preserved_files);
+
 /* 2 4K pages, give space for 128 files per file_set */
 #define LUO_FILE_PGCNT		2ul
 #define LUO_FILE_MAX							\
@@ -203,6 +207,12 @@ static void luo_free_files_mem(struct lu
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
@@ -248,6 +258,7 @@ static bool luo_token_is_used(struct luo
  * Context: Can be called from an ioctl handler during normal system operation.
  * Return: 0 on success. Returns a negative errno on failure:
  *         -EEXIST if the token is already used.
+ *         -EBUSY if the file descriptor is already preserved by another session.
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
  *         -ENOENT if no compatible handler is found.
@@ -288,10 +299,15 @@ int luo_preserve_file(struct luo_file_se
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
@@ -320,6 +336,8 @@ err_kfree:
 	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
+err_erase_xa:
+	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -363,6 +381,8 @@ void luo_file_unpreserve_files(struct lu
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
+		xa_erase(&luo_preserved_files,
+			 luo_get_id(luo_file->fh, luo_file->file));
 		list_del(&luo_file->list);
 		file_set->count--;
 
@@ -606,6 +626,11 @@ int luo_retrieve_file(struct luo_file_se
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
 
@@ -701,8 +726,11 @@ int luo_file_finish(struct luo_file_set
 
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

liveupdate-fix-return-value-on-session-allocation-failure.patch

