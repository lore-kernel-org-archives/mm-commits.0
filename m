Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA1B175A9E
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632160; cv=none; b=lbWnY/gfehafPM0MZzGniOjpE9mD3JC/uVR6BS7e1H37qS1Megc5hinTCt/ZwYJgEJ9IiR26xoxNasPWvFmicSs3cwTGOojXoL+Br1RFy1ocTZRnVcdik05bwDwJvDjikTZjiFM7dZlmcIQay2YcHmkUyDdj3h29IPhCUuKH5W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632160; c=relaxed/simple;
	bh=UXGgsJMZTVehH+gKFgPJu1dVZ0Er1fqScTI1iAqJkho=;
	h=Date:To:From:Subject:Message-Id; b=RmS733Y5GzCmXf3aVz36My3oRLQqvXq+Cto+/sclAVJ68MYtvnOIFh8IPlsnowo4gHZQB7+oa7g+jVK8jHr/EgiFhAK3DAiFTaQTXp4qb4L2fzIHcur6Y/gXXa5uwBpMjshiBpm0Z4B5OEtIK3561Y0jyjLlSNeUtZCdVRwj50E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FPB0bGDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FPB0bGDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F59BC19423;
	Fri, 27 Mar 2026 17:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632160;
	bh=UXGgsJMZTVehH+gKFgPJu1dVZ0Er1fqScTI1iAqJkho=;
	h=Date:To:From:Subject:From;
	b=FPB0bGDS76SnJoxAjxk5qwgtmxi5/y92IHLPYkM+K1xQ9+Rs/PD9ccvhWX+U6spV8
	 SziBha4HOzgPglsFqatsGcZLEVvjnbTNGlIN4ZCcTBZ2Yk6yBS642z3fsgGUjyxNjs
	 sqWpiWL800brDpQPz+0zJYMT2m4uTICFozLmYBtU=
Date: Fri, 27 Mar 2026 10:22:39 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-protect-flb-lists-with-luo_register_rwlock.patch added to mm-new branch
Message-Id: <20260327172240.0F59BC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: protect FLB lists with luo_register_rwlock
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-protect-flb-lists-with-luo_register_rwlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-protect-flb-lists-with-luo_register_rwlock.patch

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
Subject: liveupdate: protect FLB lists with luo_register_rwlock
Date: Fri, 27 Mar 2026 03:33:28 +0000

Because liveupdate FLB objects will soon drop their persistent module
references when registered, list traversals must be protected against
concurrent module unloading.

To provide this protection, utilize the global luo_register_rwlock.  It
protects the global registry of FLBs and the handler's specific list of
FLB dependencies.

Read locks are used during concurrent list traversals (e.g., during
preservation and serialization).  Write locks are taken during
registration and unregistration.

Link: https://lkml.kernel.org/r/20260327033335.696621-5-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h  |    1 +
 kernel/liveupdate/luo_flb.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

--- a/include/linux/liveupdate.h~liveupdate-protect-flb-lists-with-luo_register_rwlock
+++ a/include/linux/liveupdate.h
@@ -12,6 +12,7 @@
 #include <linux/kho/abi/luo.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/types.h>
 #include <uapi/linux/liveupdate.h>
 
--- a/kernel/liveupdate/luo_flb.c~liveupdate-protect-flb-lists-with-luo_register_rwlock
+++ a/kernel/liveupdate/luo_flb.c
@@ -262,17 +262,20 @@ int luo_flb_file_preserve(struct liveupd
 	struct luo_flb_link *iter;
 	int err = 0;
 
+	down_read(&luo_register_rwlock);
 	list_for_each_entry(iter, flb_list, list) {
 		err = luo_flb_file_preserve_one(iter->flb);
 		if (err)
 			goto exit_err;
 	}
+	up_read(&luo_register_rwlock);
 
 	return 0;
 
 exit_err:
 	list_for_each_entry_continue_reverse(iter, flb_list, list)
 		luo_flb_file_unpreserve_one(iter->flb);
+	up_read(&luo_register_rwlock);
 
 	return err;
 }
@@ -294,6 +297,7 @@ void luo_flb_file_unpreserve(struct live
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_unpreserve_one(iter->flb);
 }
@@ -314,6 +318,7 @@ void luo_flb_file_finish(struct liveupda
 	struct list_head *flb_list = &ACCESS_PRIVATE(fh, flb_list);
 	struct luo_flb_link *iter;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_for_each_entry_reverse(iter, flb_list, list)
 		luo_flb_file_finish_one(iter->flb);
 }
@@ -377,6 +382,8 @@ int liveupdate_register_flb(struct liveu
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
+
 	/* Check that this FLB is not already linked to this file handler */
 	err = -EEXIST;
 	list_for_each_entry(iter, flb_list, list) {
@@ -418,11 +425,13 @@ int liveupdate_register_flb(struct liveu
 	private->users++;
 	link->flb = flb;
 	list_add_tail(&no_free_ptr(link)->list, flb_list);
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 
 	return 0;
 
 err_resume:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 	return err;
 }
@@ -466,6 +475,8 @@ int liveupdate_unregister_flb(struct liv
 	if (!luo_session_quiesce())
 		return -EBUSY;
 
+	down_write(&luo_register_rwlock);
+
 	/* Find and remove the link from the file handler's list */
 	list_for_each_entry(iter, flb_list, list) {
 		if (iter->flb == flb) {
@@ -490,11 +501,13 @@ int liveupdate_unregister_flb(struct liv
 		module_put(flb->ops->owner);
 	}
 
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 
 	return 0;
 
 err_resume:
+	up_write(&luo_register_rwlock);
 	luo_session_resume();
 	return err;
 }
@@ -660,6 +673,7 @@ void luo_flb_serialize(void)
 	struct liveupdate_flb *gflb;
 	int i = 0;
 
+	guard(rwsem_read)(&luo_register_rwlock);
 	list_private_for_each_entry(gflb, &luo_flb_global.list, private.list) {
 		struct luo_flb_private *private = luo_flb_get_private(gflb);
 
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

