Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133031D6193
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857161; cv=none; b=hrNthsM29pLgrl4aMJUDh5TL3zlMuf0o4/R1xCJSrSOjlX4z5yfhjpOpA9LZ8Q5FJ5KTLzeiWPf5dACOfYfyrvlwBraUVy9rRLyK9R09WeF3srJ/34SNQzmU9GPjC3yrJsh/9LJqmJJfI755jns3coJgpkstfi7eSiSY+0sWgYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857161; c=relaxed/simple;
	bh=UfnkbUfnc5i337HMusB9dkvEJ/w6UqRKsn6n3UXasMQ=;
	h=Date:To:From:Subject:Message-Id; b=ScdIi3i4Kw4CF56ZqByq+C3B06wnw7NxWL2U+eDem215/yDiMVZph6/MYb9CmrK66sescivvj+qgCwQ6VkA/E2hr0+v2PkaxfD63cI2Am1S9d9X4azcxiGxxNpzM1JrDlx5oYjh9pLX3AiUT9mzw7/HDhmF1iFPtzYYTcCVjoow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jkEvBmGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jkEvBmGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74D8C19421;
	Wed, 18 Mar 2026 18:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773857160;
	bh=UfnkbUfnc5i337HMusB9dkvEJ/w6UqRKsn6n3UXasMQ=;
	h=Date:To:From:Subject:From;
	b=jkEvBmGKq4V4AqtL1854VcHfr7UKwG998QEx3+s2SYT+TLnPDj0B15oqbu2r3YQn+
	 +UJrhjwJq68ImCsCEYqA6+Vcf0qzwvKTcRRUcfGI8lQWaB5jO0HjKwje6yLMCtq4C9
	 CUbU7k9SWwVEet1N0yrl1I1x0WpzUYAxXcIplNXo=
Date: Wed, 18 Mar 2026 11:06:00 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-remove-liveupdate_test_unregister.patch added to mm-new branch
Message-Id: <20260318180600.A74D8C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: remove liveupdate_test_unregister()
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-remove-liveupdate_test_unregister.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-remove-liveupdate_test_unregister.patch

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
Subject: liveupdate: remove liveupdate_test_unregister()
Date: Wed, 18 Mar 2026 10:16:45 -0400

Now that file handler unregistration automatically unregisters all
associated file handlers (FLBs), the liveupdate_test_unregister() function
is no longer needed.  Remove it along with its usages and declarations.

Link: https://lkml.kernel.org/r/20260318141637.1870220-17-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c     |    2 --
 kernel/liveupdate/luo_internal.h |    2 --
 lib/tests/liveupdate.c           |   18 ------------------
 3 files changed, 22 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-remove-liveupdate_test_unregister
+++ a/kernel/liveupdate/luo_file.c
@@ -879,8 +879,6 @@ int liveupdate_unregister_file_handler(s
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
-	liveupdate_test_unregister(fh);
-
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
 		luo_flb_unregister_all(fh);
 		list_del(&ACCESS_PRIVATE(fh, list));
--- a/kernel/liveupdate/luo_internal.h~liveupdate-remove-liveupdate_test_unregister
+++ a/kernel/liveupdate/luo_internal.h
@@ -108,10 +108,8 @@ void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
 void liveupdate_test_register(struct liveupdate_file_handler *fh);
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh);
 #else
 static inline void liveupdate_test_register(struct liveupdate_file_handler *fh) { }
-static inline void liveupdate_test_unregister(struct liveupdate_file_handler *fh) { }
 #endif
 
 #endif /* _LINUX_LUO_INTERNAL_H */
--- a/lib/tests/liveupdate.c~liveupdate-remove-liveupdate_test_unregister
+++ a/lib/tests/liveupdate.c
@@ -135,24 +135,6 @@ void liveupdate_test_register(struct liv
 		TEST_NFLBS, fh->compatible);
 }
 
-void liveupdate_test_unregister(struct liveupdate_file_handler *fh)
-{
-	int err, i;
-
-	for (i = 0; i < TEST_NFLBS; i++) {
-		struct liveupdate_flb *flb = &test_flbs[i];
-
-		err = liveupdate_unregister_flb(fh, flb);
-		if (err) {
-			pr_err("Failed to unregister %s %pe\n",
-			       flb->compatible, ERR_PTR(err));
-		}
-	}
-
-	pr_info("Unregistered %d FLBs from file handler: [%s]\n",
-		TEST_NFLBS, fh->compatible);
-}
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pasha Tatashin <pasha.tatashin@soleen.com>");
 MODULE_DESCRIPTION("In-kernel test for LUO mechanism");
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

