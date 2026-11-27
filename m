Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795742368;
	b=wpMkQa2FK2c+gUEHRPnHPfeiwNGNT/yeh3xv1m+R/DClNaAmSJ+4wyj1An/XI3gvzlk3
	 RSsd53+flQk5brV+GRIz2lUQhSz0PSPaqd/4LXSnRFDl29HtkCTxISqVcQROAusnJzRDA
	 O7OboB4EERKcrOZ+hG44SmlZfh8ZfOvbPRkmpc0v29u5XqaUYGrfnERE1rpIAQ5hAWyDq
	 LAKhb98mI9JLHdBwT6ZSyCYRGTyForPTRH5Ka/aFPtOmzYjAIVpnlpFkrAt6h9ofvxUjI
	 lnjMSmXVAMYU20S//W1Huyy++U7Ziju6zWtuf4JbLajU+xHnmUzhDX+rKUiHqUvR+2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795742368;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6c4yiTRA5rY0IOWlexdxAlWvSdMTltxeSSFX63Lv8Ls=;
	b=rhdH+77eO2ETopbTxvdmWO9z+4E0jbxsY+7JtyBVNVZYpO4zKlmeLyJeEZT0H6jTVdkP
	 lVvLwf6ry7Vy6JFi6wRKz2RmugkDdXuKPxW1eHZKe+lBKImR4vzmchk5gYDCmLOnGgK53
	 jgdFO1jfzweTf4f0h5T8ty9wWg+Ii97HxnPWW8+DnmJqMRnp318rmomv5gYlTVHvwvPxJ
	 OcQsZ4rpM04/c9JtsyC8wOJvt2MrRn9tg8qvB2BPkida/yA6Uwf5OqOXqO+PPjlva/FK4
	 4qUzWKEHZhwg8UO41qhXafYGvKZqGDL1gSISYkyeFLRzXXtYhyrdAW2Bl6K5Ix5kJbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="E0PGpI/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AD0606A321
	for <mm-commits@vger.kernel.org>; Fri, 27 Nov 2026 01:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=E0PGpI/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542631F0089B;
	Fri, 27 Nov 2026 01:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795742368;
	bh=6c4yiTRA5rY0IOWlexdxAlWvSdMTltxeSSFX63Lv8Ls=;
	h=Date:To:From:Subject;
	b=E0PGpI/h5ZBXxtAVlvy9JVFFyWnzfjoBhmYOHHoXdY1m1OrKuQYEbG0nL7rcB/beH
	 eS4YyTvqtZXWe8cjTYAi3zDyeDo8ai2ztnDerzPzqXDuFvsTTkBpdwMH6Xxk1pwJz6
	 hRYeRY5+t/nLbg57WykozEQ3CwTye7TDeDJgHodQ=
Date: Thu, 26 Nov 2026 17:19:27 -0800
To: mm-commits@vger.kernel.org,ynorov@nvidia.com,vkoskiv@gmail.com,
	mfo@igalia.com,edumazet@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-bloat-o-meter-describe-output-fields-in-help-text-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261127011928.542631F0089B@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: scripts/bloat-o-meter: clarify Before and After help text
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-bloat-o-meter-describe-output-fields-in-help-text-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-bloat-o-meter-describe-output-fields-in-help-text-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/bloat-o-meter: clarify Before and After help text
Date: Thu, 26 Nov 2026 17:15:17 -0800

bloat-o-meter selects symbol types according to its options and filters
some names. Mauricio Faria de Oliveira's new help text describes Before
and After as the sizes of all symbols in each file, which includes
symbols that the script does not count. Say "selected symbols" instead.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Valtteri Koskivuori <vkoskiv@gmail.com>
Cc: Eric Dumazet <edumazet@kernel.org>

 scripts/bloat-o-meter |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-describe-output-fields-in-help-text-fix
+++ a/scripts/bloat-o-meter
@@ -27,8 +27,8 @@ fields:
                 '-' means symbol added/removed;
                 '0' delta symbols not included.
 
-  Before:       size of all symbols in old file.
-  After:        size of all symbols in new file.
+  Before:       size of selected symbols in old file.
+  After:        size of selected symbols in new file.
   chg:          percent change.
 
   Symbols in both files with the same size are only counted in Before/After/chg.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
afs-do-not-put-error-pointer-after-address-lookup-failure.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-0.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-1.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
proc-serialize-task-owner-updates.patch
proc-dont-lock-task-inodes-whose-owner-has-not-changed.patch
scripts-bloat-o-meter-describe-output-fields-in-help-text-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

