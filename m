Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE03783C6
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632157; cv=none; b=RqGoX63E0+N9p62ODJK96BANZJi1e7kAJNMzXgKCPz0nSYdTH9wU5Oa2e/wFoMj5gqRBG7EIOB1hqkR4imVDbe1HZj54Gne7QQQarwZZlAGH/5ODatY64I2Q2PDuTlOrSKPxciykRmP1E4/cCj/Uuoolp3lsoeGDsym1aJWtbiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632157; c=relaxed/simple;
	bh=Zsed6e9uANah8nVdw+I2WTIygmbJxERUnekK59euZ1s=;
	h=Date:To:From:Subject:Message-Id; b=qNEKnoR0qeVOGOLBPCVgQ0o3/ImKMi0u3l1LOMNqnyed8ps0dAaEWf37xTwnqzb+D7bhM7/jta8ZIxr6ZpXlY38TJdpHpECzRCTgU8TAIHfvUXyjHfo3P1X8tK2/CqBRlZo4hDXHit6cZjAapJGEh96OYLKa5+/GzwgL3j0gmzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UzSP3yBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UzSP3yBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FED5C19423;
	Fri, 27 Mar 2026 17:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632157;
	bh=Zsed6e9uANah8nVdw+I2WTIygmbJxERUnekK59euZ1s=;
	h=Date:To:From:Subject:From;
	b=UzSP3yBkVc4nCD8Hs+9OOLPE3fv+5MIHTAsFYcvxwwZNTraFwOXN5w7jIbfL4fvko
	 82epXzYmxbPkgtfsZMZwj5XDL0j1437/FcYhcrfci/QU0JeN63FH/vKVazZJ8/m3pl
	 QgRd4T6m/7GeT6GE47IWapJ65XM2sSo7FRd/8jw0=
Date: Fri, 27 Mar 2026 10:22:36 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-protect-file-handler-list-with-rwsem.patch added to mm-new branch
Message-Id: <20260327172237.1FED5C19423@smtp.kernel.org>
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
Date: Fri, 27 Mar 2026 03:33:27 +0000

Because liveupdate file handlers will no longer hold a module reference
when registered, we must ensure that the access to the handler list is
protected against concurrent module unloading.

Utilize the global luo_register_rwlock to protect the global registry of
file handlers.  Read locks are taken during list traversals in
luo_preserve_file() and luo_file_deserialize().  Write locks are taken
during registration and unregistration.

Link: https://lkml.kernel.org/r/20260327033335.696621-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_core.c     |    6 ++++++
 kernel/liveupdate/luo_file.c     |   22 +++++++++++++++++-----
 kernel/liveupdate/luo_internal.h |    2 ++
 3 files changed, 25 insertions(+), 5 deletions(-)

--- a/kernel/liveupdate/luo_core.c~liveupdate-protect-file-handler-list-with-rwsem
+++ a/kernel/liveupdate/luo_core.c
@@ -54,6 +54,7 @@
 #include <linux/liveupdate.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
+#include <linux/rwsem.h>
 #include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
@@ -68,6 +69,11 @@ static struct {
 	u64 liveupdate_num;
 } luo_global;
 
+/*
+ * luo_register_rwlock - Protects registration of file handlers and FLBs.
+ */
+DECLARE_RWSEM(luo_register_rwlock);
+
 static int __init early_liveupdate_param(char *buf)
 {
 	return kstrtobool(buf, &luo_global.enabled);
--- a/kernel/liveupdate/luo_file.c~liveupdate-protect-file-handler-list-with-rwsem
+++ a/kernel/liveupdate/luo_file.c
@@ -288,12 +288,14 @@ int luo_preserve_file(struct luo_file_se
 		goto  err_fput;
 
 	err = -ENOENT;
+	down_read(&luo_register_rwlock);
 	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 		if (fh->ops->can_preserve(fh, file)) {
 			err = 0;
 			break;
 		}
 	}
+	up_read(&luo_register_rwlock);
 
 	/* err is still -ENOENT if no handler was found */
 	if (err)
@@ -805,12 +807,14 @@ int luo_file_deserialize(struct luo_file
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
+		down_read(&luo_register_rwlock);
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
 				handler_found = true;
 				break;
 			}
 		}
+		up_read(&luo_register_rwlock);
 
 		if (!handler_found) {
 			pr_warn("No registered handler for compatible '%.*s'\n",
@@ -879,32 +883,36 @@ int liveupdate_register_file_handler(str
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
 	/* Check for duplicate compatible strings */
 	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
 		if (!strcmp(fh_iter->compatible, fh->compatible)) {
 			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
 			       fh->compatible);
 			err = -EEXIST;
-			goto err_resume;
+			goto err_unlock;
 		}
 	}
 
 	/* Pin the module implementing the handler */
 	if (!try_module_get(fh->ops->owner)) {
 		err = -EAGAIN;
-		goto err_resume;
+		goto err_unlock;
 	}
 
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
 	INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
+	up_write(&luo_register_rwlock);
+
 	luo_session_resume();
 
 	liveupdate_test_register(fh);
 
 	return 0;
 
-err_resume:
+err_unlock:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 	return err;
 }
@@ -938,16 +946,20 @@ int liveupdate_unregister_file_handler(s
 	if (!luo_session_quiesce())
 		goto err_register;
 
+	down_write(&luo_register_rwlock);
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-		goto err_resume;
+		goto err_unlock;
 
 	list_del(&ACCESS_PRIVATE(fh, list));
+	up_write(&luo_register_rwlock);
+
 	module_put(fh->ops->owner);
 	luo_session_resume();
 
 	return 0;
 
-err_resume:
+err_unlock:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 err_register:
 	liveupdate_test_register(fh);
--- a/kernel/liveupdate/luo_internal.h~liveupdate-protect-file-handler-list-with-rwsem
+++ a/kernel/liveupdate/luo_internal.h
@@ -77,6 +77,8 @@ struct luo_session {
 	struct mutex mutex;
 };
 
+extern struct rw_semaphore luo_register_rwlock;
+
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
 int __init luo_session_setup_outgoing(void *fdt);
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

