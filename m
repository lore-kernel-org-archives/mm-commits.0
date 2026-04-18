Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2FB3161BE
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498782; cv=none; b=fzSVIPx7UmaBfON2e/mwqCYkHflz/wNWkon1N/zpouAWkAt8g/CP57Sxxz9c5uwiRAA1DSYh9S4jY0dhjhzNmhUjvMPS1CI0mZ+SWR0MXJyZjVNfNYmLWhUIxhRUydaL1b6HfMtCtbu05HGwRiMBorTT6h/KIVeWPQey2ZZR0Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498782; c=relaxed/simple;
	bh=r1yEI1q0W2iVdIo7hgcQNLSoNKm4qgBHvoHq8MRAn4g=;
	h=Date:To:From:Subject:Message-Id; b=Nwfq6sO9QhTzeyGbNDkRj4wr+HeImiZOPQD9KLcd8tECKQ/cX8v26FfKBPZXt+Q9YnSgaZeU7KHuzhJh41FPw8HwxRmLzl5ilV2qYdqKRJAMWeqM3zrzL0qHBBvkdX6kKlS4tCPDS1TGEUA2872nRGeWSS5SGXcRSuk2quROjVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=11q/ytWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="11q/ytWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6542AC19424;
	Sat, 18 Apr 2026 07:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498782;
	bh=r1yEI1q0W2iVdIo7hgcQNLSoNKm4qgBHvoHq8MRAn4g=;
	h=Date:To:From:Subject:From;
	b=11q/ytWEiwDPf8DavV+2lrN4HbD9JmWEGbULvExBSDLxtQvLJXSx4BGgYrWCr2dZY
	 bDSn3pKGSW+se7hbOLuOTl6+ZLmNMkiFTLZQRvsp61dgJb8UP5t3M98BSOPN5Z2xIN
	 2Z3RucNkYGV1StDZsGcNKv9z6/3BirlkvVLJOKqw=
Date: Sat, 18 Apr 2026 00:52:57 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-protect-file-handler-list-with-rwsem.patch removed from -mm tree
Message-Id: <20260418075301.6542AC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: protect file handler list with rwsem
has been removed from the -mm tree.  Its filename was
     liveupdate-protect-file-handler-list-with-rwsem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260327033335.696621-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

liveupdate-fix-return-value-on-session-allocation-failure.patch

