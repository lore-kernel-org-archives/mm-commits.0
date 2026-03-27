Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024BD25B305
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632153; cv=none; b=CTmMM3LpS861X7IcAGON1KmzpbbKN/L0UfZUmwCEIj/QopXsJXFHHYxIhzGViO/yVNSwYPYcWwusfxssm4wm9i3NQgOOg6Su1Flbn9kZuekdPV7GzHTKT+6EpQNkcAd65UzOhDGNiiGBQoJGRxPXKa62oXwZ1QVwAhX4tK5iiqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632153; c=relaxed/simple;
	bh=07ho/e0f3EUEYNNeF29E7If3+GQZjVJ2B6GxugKgAo4=;
	h=Date:To:From:Subject:Message-Id; b=iKHBvpsOhHAuwfHOQZ6rmEyznyz2qdYh4CL0uiQTz4V8dgH9aPAreEgaQZ3oQND+S3HVL833U/dhmI+d8lr8gA+M8iQRU18eiTEYreAMv1ZrgSywugKnwX3lTGVbf7Cch5o0rxet7lV2l3cUzZ20zRHVFw5uMTpUShY56bKpyxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zt850Ezu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zt850Ezu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851FCC19423;
	Fri, 27 Mar 2026 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632152;
	bh=07ho/e0f3EUEYNNeF29E7If3+GQZjVJ2B6GxugKgAo4=;
	h=Date:To:From:Subject:From;
	b=zt850EzuD6G/Ki2eD7v7Hibo4w629xG+NNicaUnEogFHP1rqFwAMacPT2n8/OaujN
	 DmOX+X2MbX16Tm85zI1+wkq5qrEtCgj8qpAcftGWbRKu44dUuxlX7qjVVHNkwqj09W
	 FcsohwyuHoCvxYRseDdGKbNWlaCNwjJPEYmnBoEc=
Date: Fri, 27 Mar 2026 10:22:31 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-safely-print-untrusted-strings.patch added to mm-new branch
Message-Id: <20260327172232.851FCC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: safely print untrusted strings
has been added to the -mm mm-new branch.  Its filename is
     liveupdate-safely-print-untrusted-strings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-safely-print-untrusted-strings.patch

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
Subject: liveupdate: safely print untrusted strings
Date: Fri, 27 Mar 2026 03:33:25 +0000

Patch series "liveupdate: Fix module unloading and unregister API", v3.

This patch series addresses an issue with how LUO handles module reference
counting and unregistration during a module unload (e.g., via rmmod).

Currently, modules that register live update file handlers are pinned for
the entire duration they are registered.  This prevents the modules from
being unloaded gracefully, even when no live update session is in
progress.

Furthermore, if a module is forcefully unloaded, the unregistration
functions return an error (e.g.  -EBUSY) if a session is active, which is
ignored by the kernel's module unload path, leaving dangling pointers in
the LUO global lists.

To resolve these issues, this series introduces the following changes:
1. Adds a global read-write semaphore (luo_register_rwlock) to protect
   the registration lists for both file handlers and FLBs.
2. Reduces the scope of module reference counting for file handlers and
   FLBs. Instead of pinning modules indefinitely upon registration,
   references are now taken only when they are actively used in a live
   update session (e.g., during preservation, retrieval, or
   deserialization).
3. Removes the global luo_session_quiesce() mechanism since module
   unload behavior now handles active sessions implicitly.
4. Introduces auto-unregistration of FLBs during file handler
   unregistration to prevent leaving dangling resources.
5. Changes the unregistration functions to return void instead of
   an error code.
6. Fixes a data race in luo_flb_get_private() by introducing a spinlock
   for thread-safe lazy initialization.
7. Strengthens security by using %.*s when printing untrusted deserialized
   compatible strings and session names to prevent out-of-bounds reads.


This patch (of 10):

Deserialized strings from KHO data (such as file handler compatible
strings and session names) are provided by the previous kernel and might
not be null-terminated if the data is corrupted or maliciously crafted.

When printing these strings in error messages, use the %.*s format
specifier with the maximum buffer size to prevent out-of-bounds reads into
adjacent kernel memory.

Link: https://lkml.kernel.org/r/20260327033335.696621-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20260327033335.696621-2-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c    |    3 ++-
 kernel/liveupdate/luo_session.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-safely-print-untrusted-strings
+++ a/kernel/liveupdate/luo_file.c
@@ -813,7 +813,8 @@ int luo_file_deserialize(struct luo_file
 		}
 
 		if (!handler_found) {
-			pr_warn("No registered handler for compatible '%s'\n",
+			pr_warn("No registered handler for compatible '%.*s'\n",
+				(int)sizeof(file_ser[i].compatible),
 				file_ser[i].compatible);
 			return -ENOENT;
 		}
--- a/kernel/liveupdate/luo_session.c~liveupdate-safely-print-untrusted-strings
+++ a/kernel/liveupdate/luo_session.c
@@ -544,7 +544,8 @@ int luo_session_deserialize(void)
 
 		session = luo_session_alloc(sh->ser[i].name);
 		if (IS_ERR(session)) {
-			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
+			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
+				(int)sizeof(sh->ser[i].name),
 				sh->ser[i].name, session);
 			return PTR_ERR(session);
 		}
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

