Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DC712B94
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498828; cv=none; b=U/GO6wxh3QP8sUgfzFOz5hZ0ner3+WCd7Dv4FoAfBO10smp+nUWJZMzqrRMguGXW3lufJ/fyYLgaemNT3latUVSjq+XL/4me8+nb98oGPzuVVCJa6+jZejkVdH6hw+A3Qiy50cRA0mnAiNs3d26Wgxlioma6qD3FL1xnwYEfqfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498828; c=relaxed/simple;
	bh=Qr8ZLjh34LSoRLoDJ5fBBjG/sscy1DiwJn2aXRQg+RE=;
	h=Date:To:From:Subject:Message-Id; b=fPFNncI0hV7HQpXLBg1Vqq9LS8462kmwp9pxLhzSPtG9uRrWKC85Ip9nLWGgRHNCpbN0KClUSFBJ7Vw3fEgFy+6Mzin1uCU894TGNObacX4lyvLG9ml2EPuukYBUFvvlPOYh0SspQZrWtfNbtSR+ZMCSq4S4JAMqLtVWgpZZvAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IF5KOdyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IF5KOdyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE7EC19424;
	Sat, 18 Apr 2026 07:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498828;
	bh=Qr8ZLjh34LSoRLoDJ5fBBjG/sscy1DiwJn2aXRQg+RE=;
	h=Date:To:From:Subject:From;
	b=IF5KOdyZpJJd47EUMqBlidtYL290enbLtGweT7NCUp83GCaWKLbVB+K2HOkU8E28X
	 fizt7DFMMBms7y5NpJTXN3zwIYA6bpJiLJCfwak3jT8yfvPO8LYIZbcreR5TmGiSk2
	 JlfsXvTdqvGDI4l0CiplhN6NnDiu3CJnt9Bc5ZVg=
Date: Sat, 18 Apr 2026 00:53:42 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-defer-file-handler-module-refcounting-to-active-sessions.patch removed from -mm tree
Message-Id: <20260418075346.ADE7EC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: defer file handler module refcounting to active sessions
has been removed from the -mm tree.  Its filename was
     liveupdate-defer-file-handler-module-refcounting-to-active-sessions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260327033335.696621-11-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

liveupdate-fix-return-value-on-session-allocation-failure.patch

