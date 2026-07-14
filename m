Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D4678C9C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 00:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989461; cv=none; b=NlBtQeLGfCXQTS3qZWhFdc5KkatDx+dAqTY0Gq4Z2CrcQDNDYCB1FzArLWD7RFXHx5BoGgE/CJIoT5WUhPqtpymNjZNOAJ02kVsoC3V7TVCFJYK4/JqdF8MpPbYw45iTWrZE2pYtAgANmgmTyPMBQXCQKByXwxs+lDKCbn6a1Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989461; c=relaxed/simple;
	bh=/KbgxuNlXr4UnZ4CQ/eAQEMH7NxVI4UlzpWWLHvXm0c=;
	h=Date:To:From:Subject:Message-Id; b=qaK1iQ8TvQR7jvoOs88tz301acSEwKzfeeJP7qbBYyUvwmIaw1tJEoth3ieo8W3vcoX8j+b3zmKon3xFujZCbvwRTOLSbCI2070bYha9YFrsksGmTLUNpNzrXM6yxl2yCJE/vDrk4CZYEOEppGifskm0gMqbYbqnYRc4rGDaycQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iWSOHA83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iWSOHA83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398621F000E9;
	Tue, 14 Jul 2026 00:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783989460;
	bh=TVIHkuXJmpOPVZ9xi1KdOSegoRkWfiyg+aPqVi+dc90=;
	h=Date:To:From:Subject;
	b=iWSOHA83tuphOOlt44NkBRvoCh5m3jmMEP6y9/CamFjNUPS2EE4c72NbhIYZvDkH1
	 lTDDW5UTQD89hmNRLH7cOSn/UuNhRs0Kl/LHfT3zzTF/C3yGDMVbwuVls9jPT4HU5U
	 +IU+mIGCA2qPXsc//dNZa0b2v93p+YsqqYRRO0j8=
Date: Mon, 13 Jul 2026 17:37:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,geert@linux-m68k.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-factor-leak-confirmation-into-a-helper.patch added to mm-new branch
Message-Id: <20260714003740.398621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: factor leak confirmation into a helper
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-factor-leak-confirmation-into-a-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-factor-leak-confirmation-into-a-helper.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: kmemleak: factor leak confirmation into a helper
Date: Mon, 13 Jul 2026 04:48:06 -0700

The reporting loop in kmemleak_scan() decided whether to tag an object as
a reported leak with a four-term compound condition whose last operand
also had a side effect (++object->unref_scans).  Mixing the candidate
tests with the counter update made the check hard to read.

Move the state transition into confirm_leak(): it returns true when a
still-unreferenced suspect crosses min_unref_scans consecutive scans and
is newly flagged OBJECT_REPORTED, leaving only the reporting bookkeeping
in the caller.  No functional change.

Link: https://lore.kernel.org/20260713-catalin_pto-v1-3-5b93b1131089@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-factor-leak-confirmation-into-a-helper
+++ a/mm/kmemleak.c
@@ -2015,6 +2015,26 @@ scan_gray:
 }
 
 /*
+ * Promote a suspected object to a reported leak once it has stayed
+ * unreferenced for min_unref_scans consecutive scans. Called with
+ * object->lock held; returns true when the object is newly reported.
+ */
+static bool confirm_leak(struct kmemleak_object *object)
+{
+	if (!unreferenced_object(object) ||
+	    !(object->flags & OBJECT_SUSPECT) ||
+	    (object->flags & OBJECT_REPORTED))
+		return false;
+
+	object->unref_scans += 1;
+	if (object->unref_scans < min_unref_scans)
+		return false;
+
+	object->flags |= OBJECT_REPORTED;
+	return true;
+}
+
+/*
  * Scan the memory and report the unreferenced objects as leaks. Must be
  * called with the scan_mutex held.
  */
@@ -2074,11 +2094,7 @@ static void kmemleak_scan(void)
 		trace_handle = 0;
 		dedup_print = false;
 
-		if (unreferenced_object(object) &&
-		    (object->flags & OBJECT_SUSPECT) &&
-		    !(object->flags & OBJECT_REPORTED) &&
-		    ++object->unref_scans >= min_unref_scans) {
-			object->flags |= OBJECT_REPORTED;
+		if (confirm_leak(object)) {
 			if (kmemleak_verbose) {
 				trace_handle = object->trace_handle;
 				dedup_print = true;
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch

