Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68141D6193
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857163; cv=none; b=e55/y8jwxX5nUQUIL+x5R+fF/HFA52ij70h0vaeme+uE6WUe7EBazCoGOlriu0UqWml6s3A0sVfaoqb8UbKGMks3StqlaEOIAIpHu7XXmeQK7zfggPPzgSQ86znzl1TqFy2VDrI4wVSlej/nH0VEyCcHBy2f8XjQy2JqWLk4PwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857163; c=relaxed/simple;
	bh=d91OxTwxn94B01LLme6njOQdB63aa09y00cB+wz29KM=;
	h=Date:To:From:Subject:Message-Id; b=B3+1N5g+jTEIjzKIqChQyeenv3C4l1nSc52jqg7CtwFH8XK6/PhVIRGsgcoqYzQyP+TtDFCC1QWzqKEY5vRg2RTDS/i2/A1mh/X7jbio9lt4EmTbxB1KLs+9CBaqCxUYStOav7UZ3kz95BtPmpebbDU0Wr+89TQQvmip5maFRTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zJhSvscL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zJhSvscL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FB2C19421;
	Wed, 18 Mar 2026 18:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773857163;
	bh=d91OxTwxn94B01LLme6njOQdB63aa09y00cB+wz29KM=;
	h=Date:To:From:Subject:From;
	b=zJhSvscLldUETUL6F2VJspRK3esRQBbGyRfnZHL2yjAwSI40nXOtJ+sLtg04T4lrn
	 VHJz0/dIJdDeyTX/NvAvTqD7tx4Mctd6pdDmSwNs9htFsZci9LRmVrDiUUEpvNszqC
	 dvnpuP0HcfVUbbhqi0PinQPiIeqSMJDIiut9qysQ=
Date: Wed, 18 Mar 2026 11:06:03 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-make-unregister-functions-return-void.patch added to mm-new branch
Message-Id: <20260318180603.88FB2C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: make unregister functions return void
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-make-unregister-functions-return-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-make-unregister-functions-return-void.patch

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
Subject: liveupdate: make unregister functions return void
Date: Wed, 18 Mar 2026 10:16:46 -0400

Change liveupdate_unregister_file_handler and liveupdate_unregister_flb to
return void instead of an error code.  This follows the design principle
that unregistration during module unload should not fail, as the unload
cannot be stopped at that point.

Link: https://lkml.kernel.org/r/20260318141637.1870220-18-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h   |   14 ++++++--------
 kernel/liveupdate/luo_file.c |    6 ++----
 kernel/liveupdate/luo_flb.c  |    8 +++-----
 3 files changed, 11 insertions(+), 17 deletions(-)

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
@@ -874,15 +874,13 @@ int liveupdate_register_file_handler(str
  * Unregisters the file handler from the liveupdate core. This function
  * reverses the operations of liveupdate_register_file_handler().
  */
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
 		luo_flb_unregister_all(fh);
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
-
-	return 0;
 }
--- a/kernel/liveupdate/luo_flb.c~liveupdate-make-unregister-functions-return-void
+++ a/kernel/liveupdate/luo_flb.c
@@ -476,18 +476,16 @@ int liveupdate_register_flb(struct liveu
  * owner module (acquired during registration) is released.
  *
  */
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb)
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	guard(rwsem_write)(&luo_flb_lock);
 	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
 
 	luo_flb_unregister_one(fh, flb);
-
-	return 0;
 }
 
 /**
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

