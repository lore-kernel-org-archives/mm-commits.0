Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CF8435EF3
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 18:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785782987; cv=none; b=jI/GHBwK93qoxq01tsoY+jkGdVKmxRFGLNvvb0p8hjML4NqZhOvpnms/5l6No5ruNSlaWmtk2qvoJHaxCToru/ROCQwZoOiKvcLz9unvC8VRT53/Q8Uiq24/A4g2EKORoGni2uMF77Q6IFD4s8HFDUYSDUtBkXVO//fvnlNTruU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785782987; c=relaxed/simple;
	bh=gPLskcgD6/nNq/aAdE8yX+zhZCP+Bv9dcW3yzwIzZjE=;
	h=Date:To:From:Subject:Message-Id; b=Ulvn+R9E5Qz89q5yen9j4UpbdlBH/+pFUkQ/W2svLkF9YSmEeercilfYI3ercgJpaXIReuEP/Ij8rR/Bm51tJ9QE3H9AhIvZBfG4mFxGk4OQqe2fyHzLIDVUgWmdHEpd1h8a0hrfeJ+atC9aCPBBPvvnthPVbxEXoR0TUHFU/wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ecS9uw60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ecS9uw60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4445A1F000E9;
	Mon,  3 Aug 2026 18:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785782986;
	bh=SNp/snw5tommcJ2fNScNDMMypcUu4XHLqGBiNti33Zg=;
	h=Date:To:From:Subject;
	b=ecS9uw606CpdTHAutrSCZkJFfd7+sqZNYaJgOqkQy8F/LfuSM+ZHbsx8XHQBOSj/k
	 gafuJ0/DMGn7kIo41wlnk4abXU7EPplG2d8VngkIHoYEBQtTyMHM7nBVZE9CXNpwzX
	 lGKLtpF4AgOZklu8/Oi2k8HudagLPYJkbvhNmfl0=
Date: Mon, 03 Aug 2026 11:49:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch added to mm-new branch
Message-Id: <20260803184946.4445A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: kmemleak: drop stale min_unref_scans default from comments
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

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
Subject: selftests/mm: kmemleak: drop stale min_unref_scans default from comments
Date: Fri, 31 Jul 2026 03:13:06 -0700

The test writes min_unref_scans explicitly for every case, so its comments
describing 1 as the default are both unnecessary and, since the default is
now conditional, wrong.  Refer to the threshold values directly.

No functional change.

Link: https://lore.kernel.org/20260731-kmemleak_hardened-v2-3-7b9689ac77cb@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
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

 tools/testing/selftests/mm/ksft_kmemleak_confirm.sh |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh~selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments
+++ a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
@@ -5,7 +5,7 @@
 # (the min_unref_scans module parameter).
 #
 # kmemleak only reports an object once it has stayed unreferenced for
-# min_unref_scans consecutive scans. The default of 1 reports on the first
+# min_unref_scans consecutive scans. A threshold of 1 reports on the first
 # scan (historical behaviour); higher values filter transient false
 # positives where a live object's only reference is briefly invisible to a
 # single scan (e.g. an RCU tree update in flight while the scan runs). The
@@ -16,8 +16,7 @@
 #   - a freshly allocated object is greyed on its first scan (its checksum
 #     settles then), so nothing can be reported before that priming scan;
 #     each case below primes once first,
-#   - with the default threshold (min_unref_scans=1) one scan after priming
-#     reports the orphans,
+#   - at min_unref_scans=1 one scan after priming reports the orphans,
 #   - raising the threshold to 2 needs two scans after priming: one is not
 #     enough, the second reports,
 #   - the parameter reads back what was written.
@@ -105,9 +104,8 @@ echo 3 > "$PARAM"
 # scan. Every case below runs this priming scan before counting.
 prime() { scan; }
 
-# 1) min_unref_scans=1 (default): one scan after priming reports the
-#    orphans. This also establishes that the helper produces detectable
-#    orphans here.
+# 1) min_unref_scans=1: one scan after priming reports the orphans. This
+#    also establishes that the helper produces detectable orphans here.
 echo 1 > "$PARAM"
 gen_orphans
 prime
_

Patches currently in -mm which might be from leitao@debian.org are

mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

