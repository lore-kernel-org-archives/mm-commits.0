Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5591C36F42D
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498808; cv=none; b=om9cyYcIzQQvAa6z0RZaOkE1n1MDQMBsFk3PPZy7l17/CLqVyjvdD9m5fw/qplwrPNkC0iYH4uGvUQ04IAF5SRFtWDkEM5hgZsAIUB5WlnLq3u+BklJcoZoJYZGHyCe8gIA51WeE2AJa+TKEOqFJWfSQl4A8u8qY4OUEf1aoe5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498808; c=relaxed/simple;
	bh=sXeBz05/dgrc5eC/+vQJhiX93xIMcXYhV0aDVot5pFE=;
	h=Date:To:From:Subject:Message-Id; b=uansxUUvPkxaUMsJVQ128B8Rlnq4eWOOg5UREJarDKb21KIAZx71F+inedTv0J4LJpHrSOyZgZfabx7RKMgylatKc2Wx5lrYkfuA5LbufnKxZa1RSF4etmc2JUD025G49IBjbvgNush3s4j8ltD8vNuf40RsuGE0lZmOVeQZZn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DNMvAK/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DNMvAK/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46B1C19424;
	Sat, 18 Apr 2026 07:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498808;
	bh=sXeBz05/dgrc5eC/+vQJhiX93xIMcXYhV0aDVot5pFE=;
	h=Date:To:From:Subject:From;
	b=DNMvAK/Oj+OSRHJ3YdBzP8TWed+3OxFK5LryKOkCyV672OB9lZi/i7TLsYXzKuNdE
	 nX6IZYGIZEeBxFhV23UpA/UakXZhXsEPs6u4P2BEfOWoFZtibDK9OUZaK/J8LxWRSn
	 L7LsRz0yhm5mR6QDGq17/5MVUa85ZVfIbsZJ9g18=
Date: Sat, 18 Apr 2026 00:53:22 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch removed from -mm tree
Message-Id: <20260418075327.A46B1C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: auto unregister FLBs on file handler unregistration
has been removed from the -mm tree.  Its filename was
     liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: auto unregister FLBs on file handler unregistration
Date: Fri, 27 Mar 2026 03:33:31 +0000

To ensure that unregistration is always successful and doesn't leave
dangling resources, introduce auto-unregistration of FLBs: when a file
handler is unregistered, all FLBs associated with it are automatically
unregistered.

Introduce a new helper luo_flb_unregister_all() which unregisters all FLBs
linked to the given file handler.

Link: https://lore.kernel.org/20260327033335.696621-8-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c     |   14 ----
 kernel/liveupdate/luo_flb.c      |   84 +++++++++++++++++++----------
 kernel/liveupdate/luo_internal.h |    1 
 3 files changed, 60 insertions(+), 39 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-auto-unregister-flbs-on-file-handler-unregistration
+++ a/kernel/liveupdate/luo_file.c
@@ -923,26 +923,16 @@ err_unlock:
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	int err = -EBUSY;
-
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
 	liveupdate_test_unregister(fh);
 
-	down_write(&luo_register_rwlock);
-	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-		goto err_unlock;
-
+	guard(rwsem_write)(&luo_register_rwlock);
+	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
-	up_write(&luo_register_rwlock);
 
 	module_put(fh->ops->owner);
 
 	return 0;
-
-err_unlock:
-	up_write(&luo_register_rwlock);
-	liveupdate_test_register(fh);
-	return err;
 }
--- a/kernel/liveupdate/luo_flb.c~liveupdate-auto-unregister-flbs-on-file-handler-unregistration
+++ a/kernel/liveupdate/luo_flb.c
@@ -318,6 +318,62 @@ void luo_flb_file_finish(struct liveupda
 		luo_flb_file_finish_one(iter->flb);
 }
 
+static void luo_flb_unregister_one(struct liveupdate_file_handler *fh,
+				   struct liveupdate_flb *flb)
+{
+	struct luo_flb_private *private = luo_flb_get_private(flb);
+	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
+	struct luo_flb_link *iter;
+	bool found = false;
+
+	/* Find and remove the link from the file handler's list */
+	list_for_each_entry(iter, flb_list, list) {
+		if (iter->flb == flb) {
+			list_del(&iter->list);
+			kfree(iter);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		pr_warn("Failed to unregister FLB '%s': not found in file handler '%s'\n",
+			flb->compatible, fh->compatible);
+		return;
+	}
+
+	private->users--;
+
+	/*
+	 * If this is the last file-handler with which we are registred, remove
+	 * from the global list.
+	 */
+	if (!private->users) {
+		list_del_init(&private->list);
+		luo_flb_global.count--;
+	}
+}
+
+/**
+ * luo_flb_unregister_all - Unregister all FLBs associated with a file handler.
+ * @fh: The file handler whose FLBs should be unregistered.
+ *
+ * This function iterates through the list of FLBs associated with the given
+ * file handler and unregisters them all one by one.
+ */
+void luo_flb_unregister_all(struct liveupdate_file_handler *fh)
+{
+	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
+	struct luo_flb_link *iter, *tmp;
+
+	if (!liveupdate_enabled())
+		return;
+
+	lockdep_assert_held_write(&luo_register_rwlock);
+	list_for_each_entry_safe(iter, tmp, flb_list, list)
+		luo_flb_unregister_one(fh, iter->flb);
+}
+
 /**
  * liveupdate_register_flb - Associate an FLB with a file handler and register it globally.
  * @fh:   The file handler that will now depend on the FLB.
@@ -426,38 +482,12 @@ int liveupdate_register_flb(struct liveu
 int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 			      struct liveupdate_flb *flb)
 {
-	struct luo_flb_private *private = luo_flb_get_private(flb);
-	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
-	struct luo_flb_link *iter;
-	int err = -ENOENT;
-
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
 	guard(rwsem_write)(&luo_register_rwlock);
 
-	/* Find and remove the link from the file handler's list */
-	list_for_each_entry(iter, flb_list, list) {
-		if (iter->flb == flb) {
-			list_del(&iter->list);
-			kfree(iter);
-			err = 0;
-			break;
-		}
-	}
-
-	if (err)
-		return err;
-
-	private->users--;
-	/*
-	 * If this is the last file-handler with which we are registred, remove
-	 * from the global list.
-	 */
-	if (!private->users) {
-		list_del_init(&private->list);
-		luo_flb_global.count--;
-	}
+	luo_flb_unregister_one(fh, flb);
 
 	return 0;
 }
--- a/kernel/liveupdate/luo_internal.h~liveupdate-auto-unregister-flbs-on-file-handler-unregistration
+++ a/kernel/liveupdate/luo_internal.h
@@ -103,6 +103,7 @@ void luo_file_set_destroy(struct luo_fil
 int luo_flb_file_preserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
+void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
 int __init luo_flb_setup_outgoing(void *fdt);
 int __init luo_flb_setup_incoming(void *fdt);
 void luo_flb_serialize(void);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-fix-return-value-on-session-allocation-failure.patch

