Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9C6344052
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498822; cv=none; b=XQ2FoIQ1YpMVQS/IsX1fgW28mnoSZV1uvcbuSx0Ix+FF35nGEpTwypWMyiXG0bW26d1B76g6ukGibaSc7LPgZuHX/zalI7lZ4XFTkiB62pRZIImhwsWbeIVLgyky4V3xwd8yj2CEBWFWgB4TnwQlB3GgHzzL2oVJt/sMrTDhdTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498822; c=relaxed/simple;
	bh=rwNCHD+2hWg1S9z+hR2cuTdNVY7DylLx+pAc778qIv4=;
	h=Date:To:From:Subject:Message-Id; b=gHWailNrA5BFz8uPKaXs3RGhCYL+pMee2xOzvPGQ5bpIzUZJlqea5o4NhbZNpBe0fKGuIgohMrqdot8TPC383b7x+yxrLwIC//1UyObe5Kb1XD8qGYwXWswpB26FI2G973LqtCGIgg8UUMLYKgXmIBLUvqOzJ9y5fCZMyceBY10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fyM5/3Jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fyM5/3Jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57893C19424;
	Sat, 18 Apr 2026 07:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498821;
	bh=rwNCHD+2hWg1S9z+hR2cuTdNVY7DylLx+pAc778qIv4=;
	h=Date:To:From:Subject:From;
	b=fyM5/3JokvBdL5zMdjcUBsfseNk023mPFMOh+Q5mtU9R13xHLl/22YlBFUYkWpP5+
	 RCiYcOkfpfEIe/OSLZ7Pe3fUZwdcplLGQpQnXpd/gQwiTeMR/kqujlLTduPTaUihyg
	 pkj8jj5Mz2SIyA8fwJts71b886Hb31Ayv+RJcNjI=
Date: Sat, 18 Apr 2026 00:53:35 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-make-unregister-functions-return-void.patch removed from -mm tree
Message-Id: <20260418075340.57893C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: make unregister functions return void
has been removed from the -mm tree.  Its filename was
     liveupdate-make-unregister-functions-return-void.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: make unregister functions return void
Date: Fri, 27 Mar 2026 03:33:33 +0000

Change liveupdate_unregister_file_handler and liveupdate_unregister_flb to
return void instead of an error code.  This follows the design principle
that unregistration during module unload should not fail, as the unload
cannot be stopped at that point.

Link: https://lore.kernel.org/20260327033335.696621-10-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h   |   14 ++++++--------
 kernel/liveupdate/luo_file.c |   14 ++------------
 kernel/liveupdate/luo_flb.c  |   11 +++--------
 3 files changed, 11 insertions(+), 28 deletions(-)

--- a/include/linux/liveupdate.h~liveupdate-make-unregister-functions-return-void
+++ a/include/linux/liveupdate.h
@@ -231,12 +231,12 @@ bool liveupdate_enabled(void);
 int liveupdate_reboot(void);
 
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh);
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
 
 int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 			    struct liveupdate_flb *flb);
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb);
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb);
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
@@ -258,9 +258,8 @@ static inline int liveupdate_register_fi
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+static inline void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
@@ -269,10 +268,9 @@ static inline int liveupdate_register_fl
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-					    struct liveupdate_flb *flb)
+static inline void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+					     struct liveupdate_flb *flb)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_flb_get_incoming(struct liveupdate_flb *flb,
--- a/kernel/liveupdate/luo_file.c~liveupdate-make-unregister-functions-return-void
+++ a/kernel/liveupdate/luo_file.c
@@ -912,25 +912,15 @@ err_unlock:
  *
  * Unregisters the file handler from the liveupdate core. This function
  * reverses the operations of liveupdate_register_file_handler().
- *
- * It ensures safe removal by checking that:
- * No FLB registered with this file handler.
- *
- * If the unregistration fails, the internal test state is reverted.
- *
- * Return: 0 Success. -EOPNOTSUPP when live update is not enabled. -EBUSY A live
- * update is in progress, FLB is registred with this file handler.
  */
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	guard(rwsem_write)(&luo_register_rwlock);
 	luo_flb_unregister_all(fh);
 	list_del(&ACCESS_PRIVATE(fh, list));
 
 	module_put(fh->ops->owner);
-
-	return 0;
 }
--- a/kernel/liveupdate/luo_flb.c~liveupdate-make-unregister-functions-return-void
+++ a/kernel/liveupdate/luo_flb.c
@@ -475,21 +475,16 @@ int liveupdate_register_flb(struct liveu
  * owner module (acquired during registration) is released.
  *
  * Context: It is typically called from a subsystem's module exit function.
- * Return: 0 on success.
- *         -EOPNOTSUPP if live update is disabled.
- *         -ENOENT if the FLB was not found in the file handler's list.
  */
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb)
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	guard(rwsem_write)(&luo_register_rwlock);
 
 	luo_flb_unregister_one(fh, flb);
-
-	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-fix-return-value-on-session-allocation-failure.patch

