Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494CF3783C6
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632155; cv=none; b=XLw6lVH+EK6KaqsWIKATU4gkXKltTtC/s3YNx55x/Uywd21ikToschtf6fjej/8/9u6ypG3upEub+oJWOmrvqv3ffcB4+iU5eVjardjC0VIVQx0j2/RXwfUvI0JsM4ZXPKthvF6vdvhNC+AZ0CcBbGT7EOOKJ15BlwodK3Mnn6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632155; c=relaxed/simple;
	bh=ifRBDUu9k0FI5fQnEORSoI/oFqjUB+viluZsyd5Hsqw=;
	h=Date:To:From:Subject:Message-Id; b=DIfKAsUXm5D0LVeRM7SeXMM9tgZxVCNQemzU8t0R1kKchEwZuFL978mwE4BWJGi8hyYk+xYsV+K2hFR4tDQy3x4/Uggiu+eZN4A9pbI8MhTM6v2e888aUfYKT94GjVEnZhDdoSUER3sQZU/CpdKA51B6AS1ro3N2W7iCZZqhfL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I0fJ7gr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I0fJ7gr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156E1C19423;
	Fri, 27 Mar 2026 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632155;
	bh=ifRBDUu9k0FI5fQnEORSoI/oFqjUB+viluZsyd5Hsqw=;
	h=Date:To:From:Subject:From;
	b=I0fJ7gr4raQZ6sYhw436fHT668DCf99ubZb58RHsmgSgk/V2a10DOHCHz7amXUDV+
	 5fxbwYNX6fEXKk+JLLB0A0BwgfnkZs7OxT0iWGXZkVnjEVsC7FoRm+4oZDXgoF/hSH
	 xDHvKSCHPCy0CKaPp8L4FDhSW0dEAb7fcmsG1LaA=
Date: Fri, 27 Mar 2026 10:22:34 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-synchronize-lazy-initialization-of-flb-private-state.patch added to mm-new branch
Message-Id: <20260327172235.156E1C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: synchronize lazy initialization of FLB private state
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-synchronize-lazy-initialization-of-flb-private-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-synchronize-lazy-initialization-of-flb-private-state.patch

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
Subject: liveupdate: synchronize lazy initialization of FLB private state
Date: Fri, 27 Mar 2026 03:33:26 +0000

The luo_flb_get_private() function, which is responsible for lazily
initializing the private state of FLB objects, can be called concurrently
from multiple threads.  This creates a data race on the 'initialized' flag
and can lead to multiple executions of mutex_init() and INIT_LIST_HEAD()
on the same memory.

Introduce a static spinlock (luo_flb_init_lock) local to the function to
synchronize the initialization path.  Use smp_load_acquire() and
smp_store_release() for memory ordering between the fast path and the slow
path.

Link: https://lkml.kernel.org/r/20260327033335.696621-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_flb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/luo_flb.c~liveupdate-synchronize-lazy-initialization-of-flb-private-state
+++ a/kernel/liveupdate/luo_flb.c
@@ -89,13 +89,18 @@ struct luo_flb_link {
 static struct luo_flb_private *luo_flb_get_private(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = &ACCESS_PRIVATE(flb, private);
+	static DEFINE_SPINLOCK(luo_flb_init_lock);
 
+	if (smp_load_acquire(&private->initialized))
+		return private;
+
+	guard(spinlock)(&luo_flb_init_lock);
 	if (!private->initialized) {
 		mutex_init(&private->incoming.lock);
 		mutex_init(&private->outgoing.lock);
 		INIT_LIST_HEAD(&private->list);
 		private->users = 0;
-		private->initialized = true;
+		smp_store_release(&private->initialized, true);
 	}
 
 	return private;
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

