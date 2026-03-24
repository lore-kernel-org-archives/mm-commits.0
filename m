Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4195C402BA0
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364612; cv=none; b=pP7YR12/Y+I2xr0M4r0ZfJ6QoTkTazA+ViJBCAC4QBzEghi+NP/Xl9p3RyreErMgqYf6U0Y3A6oA72nug8cN0yg6qvXL34reNmPp8JP62qqwswaAOflORgnw52NQeXW4HYCqiAHze+FWfbT/KyZ6K2pf9x1TKrhiCTYtHb28Ylc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364612; c=relaxed/simple;
	bh=h0mt21jP6kmwF4lCGOF97MgTxDZuffydLSASFnUAdg4=;
	h=Date:To:From:Subject:Message-Id; b=WbJgxQk3lWqajYBfbAZyBsnnguBBO49ANJp0tJl0DB7icD+R6PsViaoFBO+jEfX+3DHKuejGlR94y13C2fVAk+eAlD7433Qh/dcSdqwVDKZjPnB/c7dma7DA+Myv2D2cCZ1U5UV/DEZbQbRLuOat+LeCxNtszXUfEBU7HPzrSlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zz1CeDwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zz1CeDwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF14C19424;
	Tue, 24 Mar 2026 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774364611;
	bh=h0mt21jP6kmwF4lCGOF97MgTxDZuffydLSASFnUAdg4=;
	h=Date:To:From:Subject:From;
	b=Zz1CeDwRTMJBBhVkkxncGfzsSGyvWfZfjeP+16OoTwIwsyxRJ9JvqCgCdRxHV/Gpu
	 WRyJ9n/2pdUZfV/dZYzMDcfgNw1b/VoEZl69dA5avjbTV4Op4IdVu/mytFmdEb9UO6
	 pxPcLjtFNtU+jx3BLPYgmhEx2rewHuH+ngNj1fRU=
Date: Tue, 24 Mar 2026 08:03:31 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,shuah@kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-prevent-double-management-of-files.patch added to mm-new branch
Message-Id: <20260324150331.BBF14C19424@smtp.kernel.org>
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
Date: Mon, 23 Mar 2026 20:31:44 +0000

Patch series "liveupdate: prevent double preservation", v2.

Currently, LUO does not prevent the same file from being preserved twice
across different active sessions.

Because LUO preserves files of absolutely different types: memfd, and
upcoming vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd). 
There is no common private data or guarantee on how to prevent that the
same file is not preserved twice beside using inode or some slower and
expensive method like hashtables.



Currently, LUO does not prevent the same file from being managed twice
across different active sessions.

Use a global xarray `luo_preserved_files_xa` to keep track of file
pointers being preserved by LUO.  Update luo_preserve_file() to check and
insert the file pointer into this xarray when it is preserved, and erase
it in luo_file_unpreserve_files() when it is released.

This ensures that the same file (struct file) cannot be managed by
multiple sessions.  If another session attempts to preserve an already
managed file, it will now fail with -EBUSY.

Link: https://lkml.kernel.org/r/20260323203145.148057-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20260323203145.148057-2-pasha.tatashin@soleen.com
Link: https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google.com [1]
Link: https://lore.kernel.org/all/20260203220948.2176157-1-skhawaja@google.com [2]
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-prevent-double-management-of-files
+++ a/kernel/liveupdate/luo_file.c
@@ -110,11 +110,15 @@
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/xarray.h>
 #include "luo_internal.h"
 
 static DECLARE_RWSEM(luo_file_handler_lock);
 static LIST_HEAD(luo_file_handler_list);
 
+/* Keep track of files being preserved by LUO */
+static DEFINE_XARRAY(luo_preserved_files_xa);
+
 /* 2 4K pages, give space for 128 files per file_set */
 #define LUO_FILE_PGCNT		2ul
 #define LUO_FILE_MAX							\
@@ -249,6 +253,7 @@ static bool luo_token_is_used(struct luo
  * Context: Can be called from an ioctl handler during normal system operation.
  * Return: 0 on success. Returns a negative errno on failure:
  *         -EEXIST if the token is already used.
+ *         -EBUSY if the file descriptor is already preserved by another session.
  *         -EBADF if the file descriptor is invalid.
  *         -ENOSPC if the file_set is full.
  *         -ENOENT if no compatible handler is found.
@@ -277,6 +282,11 @@ int luo_preserve_file(struct luo_file_se
 	if (err)
 		goto  err_fput;
 
+	err = xa_insert(&luo_preserved_files_xa, (unsigned long)file,
+			file, GFP_KERNEL);
+	if (err)
+		goto err_free_files_mem;
+
 	err = -ENOENT;
 	scoped_guard(rwsem_read, &luo_file_handler_lock) {
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
@@ -289,11 +299,11 @@ int luo_preserve_file(struct luo_file_se
 
 	/* err is still -ENOENT if no handler was found */
 	if (err)
-		goto err_free_files_mem;
+		goto err_erase_xa;
 
 	err = luo_flb_file_preserve(fh);
 	if (err)
-		goto err_free_files_mem;
+		goto err_erase_xa;
 
 	luo_file = kzalloc_obj(*luo_file);
 	if (!luo_file) {
@@ -323,6 +333,8 @@ err_kfree:
 	kfree(luo_file);
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
+err_erase_xa:
+	xa_erase(&luo_preserved_files_xa, (unsigned long)file);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -366,6 +378,7 @@ void luo_file_unpreserve_files(struct lu
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
+		xa_erase(&luo_preserved_files_xa, (unsigned long)luo_file->file);
 		list_del(&luo_file->list);
 		file_set->count--;
 
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
liveupdate-prevent-double-management-of-files.patch
selftests-liveupdate-add-test-for-double-preservation.patch

